module.exports = class
  constructor: (@fileName) ->

  key: ->
    if @fileName.match(/app[\/\\]views[\/\\]/)
      @fileName.replace /.*?views[\/\\]/, ''
        .replace(/\.(html|erb|rhtml)/g, '')
        .replace(/[\/\\]/, '.')
    else
      'bar'
