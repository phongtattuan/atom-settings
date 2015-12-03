
module.exports = class YamlKeyReader
  constructor: (@string) ->

  keys: ->
    for key in @keysWithRow()
      [key[0], key[1] ]

  keysWithRow: ->
    indentationRules = [-1]
    keys = []
    for row, line in @string.split("\n") when row.indexOf(':') > -1 && !row.match(/^\s*#/)
      spaces = row.split(/[^\s]/)[0].length
      split = row.split(":")
      key = split.shift()
      values = split.join(":").trim()

      while(spaces <= indentationRules[0])
        indentationRules.shift()
        keys.pop()

      indentationRules.unshift(spaces)
      keys.push(key.trim())
      [keys.join("."), values, line]
