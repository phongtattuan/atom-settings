module.exports = AtomFillLine =
  activate: (state) ->
    atom.commands.add 'atom-text-editor', 'fill-line', ->
      editor = atom.workspace.getActiveTextEditor()
      return unless editor?

      for cursor in editor.getCursors()
        # read current line
        thisLine = prefix = cursor.getCurrentWordPrefix()

        # read line above, ensure it's longer than current line
        position = cursor.getBufferPosition()
        lineAbove = editor.lineTextForBufferRow(position.row - 1)
        return if not lineAbove? or lineAbove.length < thisLine.length

        # duplicate current line to match length of line above
        while thisLine.length < lineAbove.length
          thisLine += prefix

        # replace current line with expanded version
        range = cursor.getCurrentLineBufferRange()
        editor.setTextInBufferRange(range, thisLine.substr(0, lineAbove.length))
