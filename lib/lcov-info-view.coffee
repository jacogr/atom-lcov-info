fs = require 'fs'
path = require 'path'
{Range,View} = require 'atom'
parse = require 'lcov-parse'

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
    if editors[editor.id].decorations.length
      for decoration in editors[editor.id].decorations
        decoration.destroy()

    editors[editor.id].decorations = []

  updateCovInfo: (editor) ->
    return unless toggled
    return unless editor and editor.decorateMarker and editor.buffer.file

    @removeCovInfo(editor)

    filePath = editor.buffer.file.path
    infoFilePath = @findLCovInfoFile(filePath)

    unless infoFilePath
      console.log 'LcovInfoView: No coverage/lcov.info file found for', filePath
      return

    fp = filePath.replace(/\\/g, '/').split('/')
    matchPath = (lcovData) ->
      lp = lcovData.file.replace(/\\/g, '/').split('/')

      return null unless lp.length <= fp.length

      for i in [1..lp.length] by 1
        unless i is 0 and lp[0] is '.'
          if lp[lp.length - i] isnt fp[fp.length - i]
            return null

      return lcovData

    parse infoFilePath, (err, data) =>
      if err
        console.error 'LcovinfoView:', err
        return

      fileData = null
      for fileInfo in data when not fileData
        fileData = matchPath fileInfo

      unless fileData
        console.log 'LcovInfoView: No coverage info found for', filePath
        return

      total = 0
      covered = 0

      fileData.lines.details.forEach (detail) ->
        range = [[detail.line - 1, 0], [detail.line - 1, 0]]
        marker = editor.markBufferRange(range, invalidate: 'touch')

        total++
        klass = 'lcov-info-no-coverage'
        if detail.hit > 0
          klass = 'lcov-info-has-coverage'
          covered++

        decoration = editor.decorateMarker marker,
          class: klass, type: 'line'#'gutter'
        editors[editor.id].decorations.push decoration

      editors[editor.id].coverage = (if total then covered/total else 0)*100
      @updateStatus(editor)

  findLCovInfoFile: (filePath) ->
    while filePath and filePath != path.dirname(filePath)
      filename = path.join(filePath, 'coverage', 'lcov.info')

      if fs.existsSync(filename)
        console.log('LcovInfoView: Using info at', filename)
        return filename

      filePath = path.dirname(filePath)

    return null
