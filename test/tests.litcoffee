    {assert} = require 'chai'
    _ = require 'underscore'

Use the global urllite

    urllite = window.urllite

A list of the URL properties we want to verify.

    urlUtilsProps = [
      'protocol'
      'username'
      'password'
      'host'
      'hostname'
      'port'
      'pathname'
      'search'
      'hash'
      'origin'
    ]

A list of URLs to check.

    urls = require './urls.json'

Create an HTML element. We'll use its [decomposed IDL attributes][idl-attributes]
as the canonical parse result to check against.

    a = document.createElement 'a'


    assertParsedEqual = (actual, expected) ->
      assert.deepEqual _.pick(actual, urlUtilsProps...), _.pick(expected, urlUtilsProps...)


    testParsing = (url) ->
      a.href = url
      assertParsedEqual urllite(url), a


    describe 'urllite', ->
      for url in urls
        do (url) ->
          it "should correctly parse #{ url }", -> testParsing url


[idl-attributes]: http://www.whatwg.org/specs/web-apps/current-work/multipage/urls.html#url-decomposition-idl-attributes
