urllite = require '../core'
{URL} = urllite


URL::normalize = ->
  pathname = @pathname
  while m = /^(.*?)[^\/]+\/\.\.\/*(.*)$/.exec pathname
    pathname = "#{ m[1] }#{ m[2] }"

  if @host and pathname.indexOf('..') isnt -1 then throw new Error 'Path is behind root.'

  new urllite.URL
    protocol: @protocol
    username: @username
    password: @password
    host: @host
    hostname: @hostname
    port: @port
    pathname: pathname
    search: @search
    hash: @hash
    origin: @origin
    isSchemeRelative: @isSchemeRelative
    isAbsolutePathRelative: @isAbsolutePathRelative
    isPathRelative: @isPathRelative
    isRelative: @isRelative
    isAbsolute: @isAbsolute
