
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
      protocol = m[1] or ''
      host = m[5] or ''
      props =
        protocol: protocol
        username: m[3] or ''
        password: m[4] or ''
        host: host
        hostname: m[6] or ''
        port: m[7] or ''
        pathname: if protocol and pathname.charAt(0) isnt '/' then "/#{ pathname }" else pathname
        search: m[9] or ''
        hash: m[10] or ''
        origin: if protocol then "#{ protocol }//#{ host }" else ''
        isSchemeRelative: m[2]?

      props.isAbsolutePathRelative = not props.host and props.pathname.charAt(0) is '/'
      props.isPathRelative = not props.host and props.pathname.charAt(0) isnt '/'
      props.isRelative = props.isSchemeRelative or props.isAbsolutePathRelative or props.isPathRelative
      props.isAbsolute = not props.isRelative
      new urllite.URL props

    toString: ->
      prefix =
        if @isSchemeRelative then '//'
        else if @protocol is 'file:' then "#{ @protocol }///"
        else if @protocol then "#{ @protocol }//"
        else ''
      userinfo =
        if @password then "#{ @username }:#{ @password }"
        else if @username then "#{ @username }"
        else ''
      authority =
        if userinfo then "#{ userinfo }@#{ @host }"
        else if @host then "#{ @host }"
        else ''
      "#{ prefix }#{ authority }#{ @pathname }#{ @search }#{ @hash }"

module.exports = urllite
