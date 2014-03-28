
URL_PATTERN = ///
  ^
  (?:
    (?:
      (                                       # protocol* ("http:")
         [^:/?\#]+                            # scheme ("http")
         :
      )/+
      |
      (//)                                    # [Scheme-relative]
    )
    # (                                       # authority
      (?:
        # (                                   # userinfo
          ([a-z0-9-\._~%]+)                   # username*
          (?:
            :
            ([a-z0-9-\._~%]+)                 # password*
          )?
        # )
        @
      )?
      (                                       # host*
        ([a-z0-9-\._~%!$&'()*+,;=]+)          # hostname*
        (?:
          :
          ([0-9]+)                            # port*
        )?
      )?
    # )
  )?
  ([^?\#]*?)                                  # pathname*
  (\?                                         # search*
    [^\#]*                                    # query
  )?
  (\#                                         # hash*
    .*                                        # fragment
  )?
  $
///

urllite = (raw, opts) -> urllite.URL.parse raw, opts

urllite.URL =
  class URL
    constructor: (props) ->
      for own k, v of props
        this[k] = v

    @parse = (raw) ->
      m = raw.toString().match URL_PATTERN
      pathname = m[8] or ''
      protocol = m[1]
      urllite._createURL
        protocol: protocol
        username: m[3]
        password: m[4]
        hostname: m[6]
        port: m[7]
        pathname: if protocol and pathname.charAt(0) isnt '/' then "/#{ pathname }" else pathname
        search: m[9]
        hash: m[10]
        isSchemeRelative: m[2]?

defaults =
  protocol: ''
  username: ''
  password: ''
  host: ''
  hostname: ''
  port: ''
  pathname: ''
  search: ''
  hash: ''
  origin: ''
  isSchemeRelative: false

# A utility to build a new URL instance from only the minimum required
# attributes. All attributes that can be inferred are.
urllite._createURL = (bases...) ->
  props = {}
  for base in bases
    for own k, v of defaults
      props[k] = base[k] ? props[k] ? v

  props.host =
    if props.hostname and props.port then "#{ props.hostname }:#{ props.port }"
    else if props.hostname then props.hostname
    else ''
  props.origin = if props.protocol then "#{ props.protocol }//#{ props.host }" else ''
  props.isAbsolutePathRelative = not props.host and props.pathname.charAt(0) is '/'
  props.isPathRelative = not props.host and props.pathname.charAt(0) isnt '/'
  props.isRelative = props.isSchemeRelative or props.isAbsolutePathRelative or props.isPathRelative
  props.isAbsolute = not props.isRelative

  new urllite.URL props

module.exports = urllite
