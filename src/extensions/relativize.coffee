urllite = require '../core'
require './resolve'
{URL} = urllite


URL::relativize = (other) ->
  if @isPathRelative then return new urllite.URL this
  other = urllite other if typeof other is 'string'
  url = @resolve other

  if url.origin and url.origin isnt other.origin
    throw new Error "Origins don't match (#{ url.origin } and #{ other.origin })"
  else if not other.isAbsolute and not other.isAbsolutePathRelative
    throw new Error "Other URL (<#{ other }>) is neither absolute nor absolute path relative."

  otherSegments = other.pathname.split('/')[1..]
  urlSegments = url.pathname.split('/')[1..]

  for c, i in urlSegments
    break unless c is otherSegments[i] and urlSegments.length > i + 1 < otherSegments.length

  newSegments = urlSegments[i..]
  while i < otherSegments.length - 1
    newSegments.unshift '..' if otherSegments[i]
    i++
  if newSegments.length is 1
    newSegments =
      if newSegments[0] is otherSegments[i] then ['']
      else if newSegments[0] is '' then ['.']
      else newSegments

  new urllite.URL
    pathname: newSegments.join '/'
    search: url.search
    hash: url.hash
