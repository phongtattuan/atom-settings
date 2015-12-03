{CompositeDisposable} = require 'atom'
{SelectListView} = require 'atom-space-pen-views'

YamlKeyReader = require './yaml-key-reader'
child = require 'child_process'
fs = require 'fs'
findLocales = require './find-locales'

class Finder extends SelectListView
  initialize: (items, key, addInfo) ->
    super
    @filterKey = key
    @addInfo = addInfo
    @addClass('overlay from-top')
    i = for k, item of items
      item
    @setItems(i)

    @panel = atom.workspace.addModalPanel(item: this, visible: true)
    @focusFilterEditor()
    @on 'keypress', (evt) =>
      if evt.ctrlKey
        atom.clipboard.write @getSelectedItem().key

  viewForItem: (item) ->
    if @addInfo
      "<li>#{item[@filterKey]} <div class='pull-right key-binding'>" +
        item[@addInfo] + "</div></li>"
    else
      "<li>#{item[@filterKey]}</li>"

  getFilterKey: -> @filterKey

  confirmed: (item) ->
    atom.workspace.open(item.file, initialLine: item.line)
    @cancel()

  cancelled: ->
    @panel.hide()

  destroy: ->
    @cancel()
    @pane.destroy()


module.exports = RailsI18n =
  activate: (state) ->
    atom.commands.add 'atom-workspace', 'rails-i18n:search-key', =>
      findLocales().then (locales) ->
        new Finder(locales, 'key')

    atom.commands.add 'atom-workspace', 'rails-i18n:search-translation', =>
      findLocales().then (locales) ->
        new Finder(locales, 'value', 'key')

  findLocalesSync: ->
    projectPath = atom.project.getPaths()[0]
    ymls = child.spawnSync('find', ['-L', projectPath, '-name', '*.yml']).stdout.toString().trim()
    return Promisse.resolve([]) if ymls == ''

    keys = []
    for yml in ymls.split("\n")
      contents = fs.readFileSync(yml).toString()
      reader = new YamlKeyReader(contents)
      for [key, value, line] in reader.keysWithRow()
        keys.push(key: key, value: value, file: yml, line: line)
    keys

  provide: ->
    items = []
    promise = null

    {
      name: 'rails-i18n',

      function: (query) -> promise

      shouldRun: (query) -> query.length > 5

      onStart: -> promise = new Promise (resolve) ->
        findLocales().then (values) ->
          items = values.map (item) ->
            fn = ->
              items = []
              loaded = false
              atom.workspace.open(item.file, initialLine: item.line)

            {
              displayName: item.value
              queryString: "#{item.key} #{item.value}"
              function: fn
              additionalInfo: item.key
              commands: {
                "Open File": fn
                "Copy Key to Clipboard": =>
                  atom.clipboard.write(item.key.replace(/.*?\./, ''))
              }
            }
          resolve(items)
    }
