shell = require 'shell'
path = require 'path'
UrlReplace = require './url-replace'
module.exports =
  toolBar: null
  configFilePath: null
  currentGrammar: null

  config:
    toolBarConfigurationFilePath:
      type: 'string'
      default: path.join process.env.ATOM_HOME, 'toolbar.cson'
    showConfigButton:
      type: 'boolean'
      default: true
    reloadToolBarWhenEditConfigFile:
      type: 'boolean'
      default: true
    useBrowserPlusWhenItIsActive:
      type: 'boolean'
      default: false

  activate: ->
    @storeGrammar()
    @resolveConfigPath()

    @subscriptions = atom.commands.add 'atom-workspace',
      'flex-tool-bar:edit-config-file': =>
        atom.workspace.open @configFilePath
    if atom.config.get('flex-tool-bar.reloadToolBarWhenEditConfigFile')
      watch = require 'node-watch'
      watch @configFilePath, =>
        @reloadToolbar()

    @subscriptions.add atom.config.onDidChange 'flex-tool-bar.showConfigButton', =>
      @reloadToolbar true

    atom.workspace.onDidChangeActivePaneItem (item) =>
      if @storeGrammar()
        @reloadToolbar true

  consumeToolBar: (toolBar) ->
    @toolBar = toolBar 'flex-toolBar'
    @reloadToolbar true

  reloadToolbar: (init) ->
    try
      toolBarButtons = @loadConfig()
      # Remove and add buttons after successful JSON parse
      @removeButtons()
      @addButtons toolBarButtons
      if atom.config.get('flex-tool-bar.showConfigButton')
        @toolBar.addButton
          icon: 'gear'
          callback: 'flex-tool-bar:edit-config-file'
          tooltip: 'Edit ToolBar'
        @toolBar.addSpacer()
      atom.notifications.addSuccess 'The tool-bar was successfully updated.' if not init
    catch error
      atom.notifications.addError 'Your `toolbar.json` is **not valid JSON**!' if not init
      console.debug 'JSON is not valid'
      console.error error

  addButtons: (toolBarButtons) ->
    if toolBarButtons?
      devMode = atom.inDevMode()
      for btn in toolBarButtons

        if ( btn.hide? && @grammarCondition(btn.hide) ) or ( btn.show? && !@grammarCondition(btn.show) )
          continue

        continue if btn.mode and btn.mode is 'dev' and not devMode
        switch btn.type
          when 'button'
            button = @toolBar_addButton btn
          when 'spacer'
            button = @toolBar.addSpacer priority: btn.priority
          when 'url'
            button = @toolBar.addButton
              icon: btn.icon
              callback: (url) =>
                urlReplace = new UrlReplace()
                url = urlReplace.replace url
                if atom.config.get('flex-tool-bar.useBrowserPlusWhenItIsActive')
                  if atom.packages.isPackageActive('browser-plus')
                    atom.workspace.open url, split:'right'
                  else
                    warning = "Package browser-plus is not active. Using default browser instead!"
                    options = detail: "Use apm install browser-plus to install the needed package."
                    atom.notifications.addWarning warning, options
                    shell.openExternal url
                else
                  shell.openExternal url
              tooltip: btn.tooltip
              iconset: btn.iconset
              data: btn.url
              priority: btn.priority
        button.addClass "tool-bar-mode-#{btn.mode}" if btn.mode

        if btn.style?
          for k, v of btn.style
            button.css(k, v)

        if ( btn.disable? && @grammarCondition(btn.disable) ) or ( btn.enable? && !@grammarCondition(btn.enable) )
          button.setEnabled false

  toolBar_addButton: (btn) ->
    if Array.isArray btn.callback
      @toolBar.addButton
        icon: btn.icon
        callback: (callbacks, target) ->
          for callback in callbacks
            atom.commands.dispatch target, callback
        tooltip: btn.tooltip
        iconset: btn.iconset
        priority: btn.priority
        data: btn.callback
    else
      @toolBar.addButton
        icon: btn.icon
        callback: btn.callback
        tooltip: btn.tooltip
        iconset: btn.iconset
        priority: btn.priority

  resolveConfigPath: ->
    fs = require 'fs-plus'
    @configFilePath = atom.config.get('flex-tool-bar.toolBarConfigurationFilePath')

    if !fs.isFileSync @configFilePath
      configDir = process.env.ATOM_HOME
      @configFilePath = fs.resolve configDir, 'toolbar', ['cson', 'json5', 'json']
      unless @configFilePath
        @configFilePath = path.join configDir, 'toolbar.cson'


  loadConfig: ->
    ext = path.extname @configFilePath

    switch ext
      when '.json'
        config = require @configFilePath
        delete require.cache[@configFilePath]

      when '.json5'
        require 'json5/lib/require'
        config = require @configFilePath
        delete require.cache[@configFilePath]

      when '.cson'
        CSON = require 'cson'
        config = CSON.requireCSONFile @configFilePath

    return config

  grammarCondition: (grammars) ->
    result = false
    grammars = [grammars] if typeof grammars is 'string'

    for grammar in grammars
      reverse  = false
      if grammar.includes '!'
        grammar = grammar.replace '!', ''
        reverse = true

      if @currentGrammar? && @currentGrammar.includes grammar.toLowerCase()
        result = true

      result = !result if reverse

    return result

  storeGrammar: ->
    editor = atom.workspace.getActiveTextEditor()
    if editor && editor.getGrammar().name.toLowerCase() isnt @currentGrammar
      @currentGrammar = editor.getGrammar().name.toLowerCase()
      return true
    else
      return false

  removeButtons: ->
    @toolBar.removeItems()

  deactivate: ->
    @subscriptions.dispose()
    @removeButtons()

  serialize: ->
