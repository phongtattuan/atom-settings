findLocales = require '../lib/find-locales'

describe "findLocales", ->
  it "finds locales using a promise", ->
    waitsForPromise ->
      findLocales().then (values) ->
        match = includes(values, key:'en.view.title', value:'List of things', line:4)
        expect(match).toBe(true)

  includes = (array, elements) ->
    array.some (e) ->
      matches = for key, value of elements
        e[key] == value
      matches.every (e) -> e == true
