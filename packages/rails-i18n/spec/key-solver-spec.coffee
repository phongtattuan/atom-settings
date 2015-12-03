KeySolver = require '../lib/key-solver'

describe "KeySolver", ->
  it "solves for views", ->
    solver = new KeySolver('app/views/foo/index.html.erb')
    expect(solver.key()).toEqual 'foo.index'
