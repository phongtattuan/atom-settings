module.exports =
  activate: ->
    atom.commands.add 'atom-workspace', "terminal-to-text:convert", => @convert()

  convert: ->
    editor = atom.workspace.getActivePaneItem()
    selection = editor.getLastSelection()
    converted = selection.getText().replace(/\\n/g, "\n").replace(/\\"/g, '"')
    selection.insertText(converted)
