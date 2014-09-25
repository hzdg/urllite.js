urllite = require '../core'
require './normalize'
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
          prefix = base.pathname.split('/')[...-1].join('/')
          if prefix then "#{ prefix }/#{ @pathname }" else @pathname
      else
        @pathname

  new urllite.URL(p).normalize()
