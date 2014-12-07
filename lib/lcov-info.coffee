LcovInfoView = require './lcov-info-view'

module.exports =
  config:
    highlightType:
      title: 'Highlight Type'
      description: 'Perform highlighting either on the line, or the gutter'
      type: 'string'
      default: 'line'
      enum: ['line', 'gutter']

  lcovInfoView: null

  activate: (state) ->
    @lcovInfoView = new LcovInfoView(state.lcovInfoViewState)

  deactivate: ->
    @lcovInfoView.destroy()

  serialize: ->
    lcovInfoViewState: @lcovInfoView.serialize()
