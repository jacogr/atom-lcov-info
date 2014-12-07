{Range,View} = require 'atom'

coverage = require './coverage-lcov'
PanelView = require './panel'

CMD_TOGGLE = 'lcov-info:toggle'
EVT_SWITCH = 'pane-container:active-pane-item-changed'

toggled = false
editors = {}

module.exports =
class LcovInfoView extends View
  @content: -> @div ''

  serialize: ->

  initialize: (serializeState) ->
    console.log 'LcovInfoView: Initializing'

    atom.workspaceView.command CMD_TOGGLE, => @toggle()
    atom.workspaceView.on EVT_SWITCH, => @updateEditor()
    atom.workspaceView.eachEditorView (ev) => @updateEditor(ev.getEditor())

    return
    
  destroy: ->
    @detach()

  toggle: ->
    console.log 'LcovInfoView: Toggled to display =', toggled = not toggled
    @updateEditor()

  updateEditor: (editor) ->
    editor or= atom.workspace.getActiveEditor()

    if toggled
      @updateCovInfo(editor)
    else
      @removeCovInfo(editor)
      @removePanel()
      @removeStatus()

    return

  updatePanel: ->
    unless @panelView
      @panelView = new PanelView
      @panelView.initialize()

    @panelView.update(coverage.getLcov())
    return

  removePanel: ->
    if @panelView
      @panelView.destroy()
    @panelView = null
    return

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

    return

  removeStatus: ->
    atom.workspaceView.statusBar?.find('.lcov-info-status').remove()
    return

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

    coverage.getCoverage editor.buffer.file.path, (cover) =>
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
      @updatePanel()

      return
    return
