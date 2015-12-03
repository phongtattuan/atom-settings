TerminalToText = require '../lib/terminal-to-text'

describe "TerminalToText", ->
  [activationPromise, editor, editorView] = []

  convert = (callback) ->
    atom.commands.dispatch editorView, "terminal-to-text:convert"
    waitsForPromise -> activationPromise
    runs(callback)

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open()

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editorView = atom.views.getView(editor)

      activationPromise = atom.packages.activatePackage('terminal-to-text')

  describe "when the terminal-to-text:convert event is triggered", ->
    # it "converts newlines in the selection", ->
    #   editor.setText 'Hydrogen\\nHelium\\nLithium'
    #   editor.selectAll()
    #
    #   convert ->
    #     expect(editor.getText()).toBe """
    #       Helium
    #       Hydrogen
    #       Lithium
    #     """
