url = require('url')
openid = require('openid')
Session = require('socketstream/lib/session.coffee').Session
Cookies = require('cookies')
Keygrip = require('keygrip')


exports.call = (request, response, next) ->
  u = url.parse(request.url)
  c = SS.config.openid_auth

  if u.pathname == c.verify_path
    relyingParty(request, c.verify_path).verifyAssertion request.url, (error, result) ->
        if !error and result.authenticated
          console.log 'authentication success. user: ', result.claimedIdentifier
          cookies = new Cookies request, response, Keygrip SS.config.keygrip.keys
          cookies.set "id64", encode(result.claimedIdentifier), { signed: true, httpOnly: false } # needs date
          redirect response, c.success_path
        else
          console.log 'authentication failed.'
          redirect response, c.failure_path

  else if u.pathname == c.authen_path
    relyingParty(request, c.verify_path).authenticate c.provider_url, false, (error, provider) ->
        redirect response, provider if provider
        ## what to do with no provider url?

  else if u.pathname == c.logout_path
      cookies = new Cookies request, response
      cookies.set "id64", ""
      redirect response, c.success_path

  else
    next()


encode = (v) ->
  encodeURI( new Buffer(v).toString('base64') )


relyingParty = (request, verify) ->
    realm = 'http://' + request.headers.host
    new openid.RelyingParty(
        realm + verify,   # verification url
        realm,            # realm (optional, specifies realm for openid authentication)
        true,             # use stateless verification
        false,            # strict mode
        []                # list of extensions to enable and include
    )


redirect = (response, location, code=302) ->
    response.statusCode = code
    response.setHeader 'Location', location
    response.end()

