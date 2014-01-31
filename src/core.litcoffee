
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
              ([a-z0-9-\._~%])                    # username*
              (?:
                :
                ([a-z0-9-\._~%])                  # password*
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

    urllite = (raw) -> new urllite.URL raw

    urllite.URL =
      class URL
        constructor: (raw) ->
          m = raw.toString().match URL_PATTERN
          @protocol = m[1] or ''
          isProtocolRelative = m[2]?
          @username = m[3] or ''
          @password = m[4] or ''
          @host = m[5] or ''
          @hostname = m[6] or ''
          @port = m[7] or ''
          @pathname = m[8] or ''
          @search = m[9] or ''
          @hash = m[10] or ''
          @origin = "#{ @protocol }//#{ @host }"

    module.exports = urllite
