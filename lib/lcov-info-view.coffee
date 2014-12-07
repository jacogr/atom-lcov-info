{Range,View} = require 'atom'

coverage = require './coverage-lcov'

CMD_TOGGLE = 'lcov-info:toggle'
EVT_SWITCH = 'pane-container:active-pane-item-changed'

toggled = false
editors = {}

module.exports =
class LcovInfoView extends View
  @content: -> @div ''

  initialize: (serializeState) ->
    console.log 'LcovInfoView: Initializing'

    atom.workspaceView.command CMD_TOGGLE, => @toggle()
    atom.workspaceView.on EVT_SWITCH, => @updateStatus()
    atom.workspaceView.eachEditorView (ev) => @updateEditor(ev.getEditor())

  serialize: ->

  destroy: ->
    @detach()

  updateEditor: (editor) ->
    if toggled
      @updateCovInfo(editor)
    else
      @removeCovInfo(editor)
      @removeStatus()

  toggle: ->
    console.log 'LcovInfoView: Toggled to display =', toggled = not toggled
    @updateEditor(atom.workspace.getActiveEditor())

  removeStatus: ->
    atom.workspaceView.statusBar?.find('.lcov-info-status').remove()

  updateStatus: (editor) ->
    active = atom.workspace.getActiveEditor()
    editor = active unless editor

    @removeStatus()

    return unless active and editor.id is active.id
    return unless toggled and editors[editor.id]

    atom.workspaceView.statusBar?.appendLeft """
      <span class='lcov-info-status'>
        #{editors[editor.id].coverage.toFixed(2)}%
      </span>
    """

  removeCovInfo: (editor) ->
    return unless editor

    editors[editor.id] or= {decorations: [], coverage:0}
    for decoration in editors[editor.id].decorations
      decoration.destroy()

    editors[editor.id].decorations = []

  updateCovInfo: (editor) ->
    return unless toggled
    return unless editor and editor.decorateMarker and editor.buffer.file

    @removeCovInfo(editor)

    coverage editor.buffer.file.path, (cover) =>
      return unless cover

      hltype = atom.config.get('lcov-info.highlightType') or 'line'
      editors[editor.id].hltype = hltype

      for line in cover.lines
        marker = editor.markBufferRange(line.range, invalidate: 'touch')
        decoration = editor.decorateMarker marker,
          class: line.klass, type: hltype
        editors[editor.id].decorations.push decoration

      editors[editor.id].coverage = cover.coverage
      @updateStatus(editor)
