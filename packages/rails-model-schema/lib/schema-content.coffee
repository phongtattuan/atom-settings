{pluralize, underscore} = require('inflection')

tableName = (modelClassName)->
  underscore(pluralize(modelClassName))

normalizeSuperClass = (modelClassName) ->
  if modelClassName == "ActiveRecord::Base"
    null
  else
    modelClassName

class SchemaContent
  constructor: (@modelClass, @modelSuperClass) ->
    @attributes = []
    @schemaFound = false
    @tableFound = false
    @tableScanned = false
    @tableName = tableName(@modelClass)
    @modelSuperClass = normalizeSuperClass(@modelSuperClass)
    @superTableName = tableName(@modelSuperClass) if @modelSuperClass

  fill: (schemaContent) ->
    lines = schemaContent.toString().split(/\n/)
    for line, index in lines
      @fillFromLine(line, index + 1)

  fillFromLine: (line, lineNumber) ->
    { schemaRegexp, tableRegexp, columnRegexp, endRegexp } = @regularExpressions()

    if schemaRegexp.test(line)
      @schemaFound = true
    else if @schemaFound
      if tableRegexp(@tableName).test(line)
        @tableFound = true
      else if @superTableName and tableRegexp(@superTableName).test(line)
        @tableFound = true
      else if @tableFound and !@tableScanned
        if matches = columnRegexp.exec(line)
          @push(type: matches[1], name: matches[2], line: lineNumber)
        else if endRegexp.test(line)
          @tableScanned = true

  regularExpressions: ->
    {
      schemaRegexp: /ActiveRecord::Schema\.define\((version:|:version\s=>)\s[\d]+\) do/
      tableRegexp: (tableName) ->
        ///create_table\s("#{tableName})"[\w\W]+do\s*\|t\|///
      columnRegexp: /\bt\.([a-zA-Z_]+)[\W]+"([a-zA-Z_]+)"[^\n]*/
      endRegexp: /^[\s]+end$/
    }

  push: ({type, name, line})->
    @attributes.push(type: type, name: name, line: line)

module.exports = SchemaContent
