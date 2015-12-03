SchemaEditor = require "./schema-editor"

class SchemaEditorsCollection
  constructor: (@subscriptions)->
    @editors = []

  add: (pane, { enabled }) ->
    unless @findByPane(pane)
      editor = new SchemaEditor(pane, enabled)
      @_setupPaneEvents(pane)
      @editors.push(editor)
      editor

  activateEditor: (editor) ->
    @deactivateCurrentEditors()
    if editor.enabled
      editor.tryActivation()

  deactivateCurrentEditors: ->
    for editor in @openedEditors()
      editor.deactivate()

  openedEditors: ->
    @editors.filter (editor) -> editor.view?

  findByPane: (paneToLook) ->
    results = @editors.filter(({pane}) => pane == paneToLook)
    if results.length > 0 then results[0] else null

  _setupPaneEvents: (pane) ->
    if pane.onDidDestroy?
      @subscriptions.add pane.onDidDestroy =>
        @editors = @editors.filter ({pane}) => pane.alive

module.exports = SchemaEditorsCollection
