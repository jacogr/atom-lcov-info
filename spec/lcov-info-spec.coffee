{WorkspaceView} = require 'atom'
LcovInfo = require '../lib/lcov-info'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "LcovInfo", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('lcov-info')

  describe "when the lcov-info:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.lcov-info')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch atom.workspaceView.element, 'lcov-info:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.lcov-info')).toExist()
        atom.commands.dispatch atom.workspaceView.element, 'lcov-info:toggle'
        expect(atom.workspaceView.find('.lcov-info')).not.toExist()
