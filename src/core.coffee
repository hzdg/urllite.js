
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
      for own k, v of defaults
        this[k] = props[k] ? v

      @host or=
        if @hostname and @port then "#{ @hostname }:#{ @port }"
        else if @hostname then @hostname
        else ''
      @origin or= if @protocol then "#{ @protocol }//#{ @host }" else ''
      @isAbsolutePathRelative = not @host and @pathname.charAt(0) is '/'
      @isPathRelative = not @host and @pathname.charAt(0) isnt '/'
      @isRelative = @isSchemeRelative or @isAbsolutePathRelative or @isPathRelative
      @isAbsolute = not @isRelative

    @parse = (raw) ->
      m = raw.toString().match URL_PATTERN
      pathname = m[8] or ''
      protocol = m[1]
      new urllite.URL
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

module.exports = urllite
