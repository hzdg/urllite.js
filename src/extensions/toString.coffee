urllite = require '../core'
{URL} = urllite


URL::toString = ->
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
