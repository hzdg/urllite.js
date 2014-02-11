urllite = require '../core'
{URL} = urllite


URL::normalize = ->
  pathname = @pathname
  while m = /^(.*?)[^\/]+\/\.\.\/*(.*)$/.exec pathname
    pathname = "#{ m[1] }#{ m[2] }"
  if @host and pathname.indexOf('..') isnt -1 then throw new Error 'Path is behind root.'
  urllite._createURL this, {pathname}
