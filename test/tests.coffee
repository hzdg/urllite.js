{assert} = require 'chai'
_ = require 'underscore'

# Use the global urllite
urllite = window.urllite
urls = require './urls.json'


testParsing = (url, parts) ->
  assert.deepEqual _.pick(urllite(url), _.keys(parts)...), parts

testStringified = (url, expected) ->
  assert.equal urllite(url).toString(), expected


describe 'urllite', ->
  describe '#parse', ->
    for test in urls.parsing
      do (test) ->
        it "should parse #{ test.name }", -> testParsing test.url, test.URLUtils
  describe '#toString', ->
    for test in urls.parsing
      do (test) ->
        it "should stringify the parsed URL <#{ test.url }>", -> testStringified test.url, test.stringified
