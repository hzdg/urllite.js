{assert} = require 'chai'
_ = require 'underscore'

# Use the global urllite
urllite = window.urllite
urls = require './urls.json'


testParsing = (url, parts) ->
  assert.deepEqual _.pick(urllite(url), _.keys(parts)...), parts


describe 'urllite', ->
  for test in urls
    do (test) ->
      it "should parse #{ test.name }", -> testParsing test.url, test.URLUtils
