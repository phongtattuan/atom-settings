describe 'filling line', ->
  [workspaceView, editor, activationPromise] = []

  beforeEach ->
    waitsForPromise ->
      atom.workspace.open('sample.js')

    waitsForPromise ->
      atom.packages.activatePackage('atom-fill-line')

    runs ->
      workspaceView = atom.views.getView(atom.workspace)
      editor = atom.workspace.getActiveTextEditor()
      editor.selectAll();
      editor.backspace();

  text = (actual) ->
    editor.setText actual
    editor.moveToBottom()
    editor.moveToEndOfLine()

    return fill: (expected) ->
      atom.commands.dispatch(workspaceView, 'fill-line')
      expect(editor.getText()).toBe expected

  it 'empty editor should do nothing', ->
    text('').fill('')

  it 'one line editor should do nothing', ->
    text('WorkspaceView').fill 'WorkspaceView'

  it 'empty line above should do nothing', ->
    text('\nWorkspaceView').fill '\nWorkspaceView'

  it 'should duplicate character to length of line above', ->
    text('WorkspaceView\n+').fill 'WorkspaceView\n+++++++++++++'

  it 'should duplicate string to length of line above', ->
    text('WorkspaceView\n+-~').fill 'WorkspaceView\n+-~+-~+-~+-~+'
