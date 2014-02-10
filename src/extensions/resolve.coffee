urllite = require '../core'
{URL} = urllite


oldParse = URL.parse


copyProps = (target, source, props...) ->
  target[prop] = source[prop] for prop in props
  target


URL.parse = (raw, opts) ->
  if base = opts?.base
    delete opts.base
  url = oldParse raw, opts
  if base then url.resolve base else url


URL::resolve = (base) ->
  return new urllite.URL(this) if @isAbsolute
  base = urllite base if typeof base is 'string'
  p = {}
  if @isSchemeRelative
    copyProps p, this, 'username', 'password', 'host', 'hostname', 'port', 'pathname', 'search', 'hash'
    p.isSchemeRelative = !(p.protocol = base.protocol)
  else if @isAbsolutePathRelative or @isPathRelative
    copyProps p, this, 'search', 'hash'
    copyProps p, base, 'protocol', 'username', 'password', 'host', 'hostname', 'port'

    p.pathname =
      if @isPathRelative
        if base.pathname[...-1] is '/'
          "#{ base.pathname }/#{ @pathname }"
        else
          "#{ base.pathname.split('/')[...-1].join('/') }/#{ @pathname }"
      else
        @pathname

  while m = /^(.*?)[^\/]+\/\.\.\/*(.*)$/.exec p.pathname
    p.pathname = "#{ m[1] }#{ m[2] }"

  if p.host and p.pathname.indexOf('..') isnt -1 then throw new Error 'Path is behind root.'

  p.origin = if p.protocol then "#{ p.protocol }//#{ p.host }" else ''
  p.isAbsolutePathRelative = not p.host and p.pathname.charAt(0) is '/'
  p.isPathRelative = not p.host and p.pathname.charAt(0) isnt '/'
  p.isRelative = p.isSchemeRelative or p.isAbsolutePathRelative or p.isPathRelative
  p.isAbsolute = not p.isRelative

  new URL p
