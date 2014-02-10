
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

urllite = (raw) -> urllite.URL.parse raw

urllite.URL =
  class URL
    @parse = (raw) ->
      url = new URL
      m = raw.toString().match URL_PATTERN
      url.protocol = m[1] or ''
      url.username = m[3] or ''
      url.password = m[4] or ''
      url.host = m[5] or ''
      url.hostname = m[6] or ''
      url.port = m[7] or ''
      pathname = m[8] or ''
      url.pathname = if url.protocol and pathname.charAt(0) isnt '/' then "/#{ pathname }" else pathname
      url.search = m[9] or ''
      url.hash = m[10] or ''
      url.origin = if url.protocol then "#{ url.protocol }//#{ url.host }" else ''

      url.isSchemeRelative = m[2]?
      url.isAbsolutePathRelative = not url.host and url.pathname.charAt(0) is '/'
      url.isPathRelative = not url.host and url.pathname.charAt(0) isnt '/'
      url.isRelative = url.isSchemeRelative or url.isAbsolutePathRelative or url.isPathRelative
      url.isAbsolute = not url.isRelative

      url

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
