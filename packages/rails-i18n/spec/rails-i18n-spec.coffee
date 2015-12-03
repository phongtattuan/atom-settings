RailsI18n = require '../lib/rails-i18n'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "RailsI18n", ->
  describe "when providing Everything services", ->
    it "returns all itens for every query, after 5 chars", ->
      p = RailsI18n.provide()
      expect(p.name).toEqual('rails-i18n')

      expect(p.shouldRun('asd')).toBe(false)
      expect(p.shouldRun('asdfgh')).toBe(true)

      waitsForPromise ->
        p.function('asdfg').then (entries) ->
          matches = findMatch(entries,
            displayName: "List of things",
            queryString: "en.view.title List of things",
            additionalInfo: "en.view.title"
          )
          expect(matches).not.toBe([])

    it "copies to clipboard, or opens the file in the correct line", ->
      callstack = []
      atom.workspace.open = (file, opts) ->
        callstack = [file, opts.initialLine]

      p = RailsI18n.provide()
      waitsForPromise ->
        p.function('asdfg').then (entries) ->
          match = findMatch(entries, displayName: "List of things")[0]
          match.function()
          [opened, line] = callstack
          expect(opened).toContain 'fixtures/en.yml'
          expect(line).toEqual 4

          atom.clipboard.write("foo")
          match.commands["Copy Key to Clipboard"]()
          expect(atom.clipboard.read()).toEqual "view.title"

  findMatch = (array, elements) ->
    array.filter (e) ->
      matches = for key, value of elements
        e[key] == value
      matches.every (e) -> e == true
  # [workspaceElement, activationPromise] = []
  #
  # beforeEach ->
  #   workspaceElement = atom.views.getView(atom.workspace)
  #   activationPromise = atom.packages.activatePackage('rails-i18n')

  describe "when the rails-i18n:toggle event is triggered", ->
    # it "hides and shows the modal panel", ->
    #   # Before the activation event the view is not on the DOM, and no panel
    #   # has been created
    #   expect(workspaceElement.querySelector('.rails-i18n')).not.toExist()
    #
    #   # This is an activation event, triggering it will cause the package to be
    #   # activated.
    #   atom.commands.dispatch workspaceElement, 'rails-i18n:toggle'
    #
    #   waitsForPromise ->
    #     activationPromise
    #
    #   runs ->
    #     expect(workspaceElement.querySelector('.rails-i18n')).toExist()
    #
    #     railsI18nElement = workspaceElement.querySelector('.rails-i18n')
    #     expect(railsI18nElement).toExist()
    #
    #     railsI18nPanel = atom.workspace.panelForItem(railsI18nElement)
    #     expect(railsI18nPanel.isVisible()).toBe true
    #     atom.commands.dispatch workspaceElement, 'rails-i18n:toggle'
    #     expect(railsI18nPanel.isVisible()).toBe false
    #
    # it "hides and shows the view", ->
    #   # This test shows you an integration test testing at the view level.
    #
    #   # Attaching the workspaceElement to the DOM is required to allow the
    #   # `toBeVisible()` matchers to work. Anything testing visibility or focus
    #   # requires that the workspaceElement is on the DOM. Tests that attach the
    #   # workspaceElement to the DOM are generally slower than those off DOM.
    #   jasmine.attachToDOM(workspaceElement)
    #
    #   expect(workspaceElement.querySelector('.rails-i18n')).not.toExist()
    #
    #   # This is an activation event, triggering it causes the package to be
    #   # activated.
    #   atom.commands.dispatch workspaceElement, 'rails-i18n:toggle'
    #
    #   waitsForPromise ->
    #     activationPromise
    #
    #   runs ->
    #     # Now we can test for view visibility
    #     railsI18nElement = workspaceElement.querySelector('.rails-i18n')
    #     expect(railsI18nElement).toBeVisible()
    #     atom.commands.dispatch workspaceElement, 'rails-i18n:toggle'
    #     expect(railsI18nElement).not.toBeVisible()
