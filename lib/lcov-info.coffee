LcovInfoView = require './lcov-info-view'

module.exports =
  lcovInfoView: null

  activate: (state) ->
    @lcovInfoView = new LcovInfoView(state.lcovInfoViewState)

  deactivate: ->
    @lcovInfoView.destroy()

  serialize: ->
    lcovInfoViewState: @lcovInfoView.serialize()
