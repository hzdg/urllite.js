{assert} = require 'chai'
_ = require 'underscore'
urllite = require '../src/complete'
urls = require './urls.json'

assertThrows = (fn, args...) -> assert.throws args..., fn

testParsing = (url, parts) ->
  assert.deepEqual _.pick(urllite(url), _.keys(parts)...), parts

testStringified = (url, expected) ->
  assert.equal urllite(url).toString(), expected

testResolve = (url, base, expected) ->
  assert.deepEqual _.pick(urllite(url).resolve(base), _.keys(expected)), expected

describe 'urllite', ->
  describe '#parse', ->
    for test in urls.parsing
      do (test) ->
        it "should parse #{ test.name }", -> testParsing test.url, test.URLUtils
  describe '#toString', ->
    for test in urls.parsing
      do (test) ->
        it "should stringify the parsed URL <#{ test.url }>", -> testStringified test.url, test.stringified
  describe '#resolve', ->
    for test in urls.resolve
      do (test) ->
        it "should correctly resolve #{ test.name } (<#{ test.url }> to <#{ test.base }>)", ->
          testResolve test.url, test.base, test.expected
    it 'should error if the path puts you behind the root', ->
      assertThrows 'behind root', ->
        urllite('../').resolve 'http://example.com'
