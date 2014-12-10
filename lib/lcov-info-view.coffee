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

  updatePanel: (lcovData) ->
    unless @panelView
      @panelView = new PanelView
      @panelView.initialize()

    @panelView.update(lcovData)
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

    color = switch
      when editors[editor.id].coverage >= 90 then 'green'
      when editors[editor.id].coverage >= 75 then 'orange'
      else 'red'

    atom.workspaceView.statusBar?.appendLeft """
      <span class='lcov-info-status #{color}'>
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
    return

  updateCovInfo: (editor) ->
    return unless toggled
    return unless editor and editor.decorateMarker and editor.buffer.file

    @removeCovInfo(editor)

    coverage editor.buffer.file.path, (lcovData, cover) =>
      return unless lcovData

      @updatePanel(lcovData)

      return unless cover

      displayAll = atom.config.get('lcov-info.coveredType') isnt 'Uncovered Lines Only'
      lineType = atom.config.get('lcov-info.highlightType') isnt 'gutter'

      for lineno, line of cover.lines
        if displayAll or line.hit is 0
          marker = editor.markBufferRange(line.range, invalidate: 'touch')
          editors[editor.id].decorations.push editor.decorateMarker marker,
            class: line.klass, type: 'gutter'
          if lineType
            editors[editor.id].decorations.push editor.decorateMarker marker,
              class: line.klass, type: 'line'

      editors[editor.id].coverage = cover.coverage
      @updateStatus(editor)

      return
    return
