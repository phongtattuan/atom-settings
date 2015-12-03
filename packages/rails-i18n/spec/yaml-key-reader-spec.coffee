Reader = require '../lib/yaml-key-reader'

describe 'YamlKeyReader', ->
  it 'reads simple keys', ->
    reader = new Reader("en: foo")
    expect(reader.keys()).toEqual([["en", 'foo']])

  it 'reads composite keys', ->
    reader = new Reader("en:\n  foo: Bar")
    expect(reader.keys()).toEqual [["en", ''], ["en.foo", 'Bar']]

  it 'reads multiple levels of indentation', ->
    reader = new Reader("en:\n  foo: Bar\npt:\n  bar: Foo\n  baz: Nada")
    expect(reader.keys()).toEqual [["en", ''], ["en.foo", 'Bar'],
      ['pt', ''], ['pt.bar', 'Foo'], ['pt.baz', 'Nada']]

  it 'checks when identation have "jumps"', ->
    reader = new Reader  "en:\n  foo:\n    bar: baz\npt:\n  baz: Nada"
    expect(reader.keys()).toEqual [["en", ''], ["en.foo", ''], ['en.foo.bar', 'baz'],
      ['pt', ''], ['pt.baz', 'Nada']]

  it 'ignores lines without :', ->
    reader = new Reader  "pt:\n  foo: ! 'Foo bar\n  baz'"
    expect(reader.keys()).toEqual [["pt", ''], ["pt.foo", "! 'Foo bar"]]

  it 'ignores comments', ->
    reader = new Reader  "# nothing: at all\npt: #BR\n#  foo:bar"
    expect(reader.keys()).toEqual [["pt", '#BR']]

  it 'shows line numbers with keys', ->
    reader = new Reader  "# nothing: at all\npt: #BR\n#  foo:bar\n  bar: baz"
    expect(reader.keysWithRow()).toEqual [["pt", '#BR', 1], ['pt.bar', 'baz', 3]]
