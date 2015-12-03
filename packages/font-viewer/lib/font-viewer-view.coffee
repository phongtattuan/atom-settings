_ = require 'underscore-plus'
path = require 'path'
{$, ScrollView} = require 'atom-space-pen-views'
{Emitter, CompositeDisposable} = require 'atom'

# View that renders a {FontViewer}.
module.exports =
class FontViewerView extends ScrollView
  @content: ->
    @div class: 'font-viewer', tabindex: -1, =>
      @style outlet: 'style'
      @div class: 'font-container', outlet: 'container', =>
        @div class: 'font-preview', outlet: 'preview'

  initialize: (@fontViewer) ->
    super
    @emitter = new Emitter

  attached: ->
    @disposables = new CompositeDisposable

    @disposables.add atom.commands.add @element,
      'font-viewer:zoom-in': => @zoomIn()
      'font-viewer:zoom-out': => @zoomOut()
      'font-viewer:reset-zoom': => @resetZoom()

    preview = @preview
    @fontViewer.getAvailableCharacters (availableCharacters) ->
      _.each availableCharacters, (c)->
        preview.append "<div class=\"font-glyph\">&#x#{c.toString(16)};<div class=\"font-glyph-id\">U+#{c.toString(16)}</div></div>"

    @style.append "@font-face { font-family: \"#{@fontViewer.getUri()}\"; src: url('#{@fontViewer.getUri()}'); }"
    @container.css 'font-family': "\"#{@fontViewer.getUri()}\""

  detached: ->
    @disposables.dispose()

  # Zooms the font preview out by 10%.
  zoomOut: ->
    @adjustSize(0.9)

  # Zooms the font preview in by 10%.
  zoomIn: ->
    @adjustSize(1.1)

  # Zooms the font preview to its normal size.
  resetZoom: ->
    return unless @isVisible()

    @container.css 'font-size': ''

  # Adjust the size of the font preview by the given multiplying factor.
  #
  # factor - A {Number} to multiply against the current size.
  adjustSize: (factor) ->
    return unless @isVisible()

    @container.css 'font-size': "#{parseInt(@container.css('font-size'), 10) * factor}px"
