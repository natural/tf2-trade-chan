url = require 'url'
openid = require 'openid'
Cookies = require 'cookies'
Keygrip = require 'keygrip'
server = require 'socketstream/lib/utils/server.coffee'
hashlib = require 'hashlib'


exports.call = (request, response, next) ->
    u = url.parse(request.url)
    c = SS.config.openid_auth

    if u.pathname == c.verify_path
        rp = relying_party(request, c.verify_path)
        rp.verifyAssertion request.url, (error, result) ->
            if !error and result.authenticated
                cookies = new Cookies request, response, Keygrip SS.config.keygrip.keys
                cookies.set 'id64', encode(result.claimedIdentifier), {signed: true, httpOnly: false, expires:expiry()}
                redirect response, c.success_path
            else
                redirect response, c.failure_path

    else if u.pathname == c.authen_path
        rp = relying_party(request, c.verify_path)
        rp.authenticate c.provider_url, false, (error, provider) ->
            redirect response, provider if provider
            ## what to do with no provider url?

    else if u.pathname == c.logout_path
        cookies = new Cookies request, response
        cookies.set 'id64', ''
        redirect response, c.success_path

    else if u.pathname == '/schema'

        SS.server.steam.schema (s) ->
            ss = JSON.stringify s
            et = hashlib.md5(ss)
            response.setHeader('ETag', et)
            if request.headers['if-none-match'] == et
                response.setHeader('Content-Length', 0)
                rc = 304
                rd = ''
            else
                rc = 200
                rd = ss
            server.deliver response, rc, 'text/javascript', rd

    else
        next()


encode = (v) ->
    encodeURI( new Buffer(v).toString('base64') )


relying_party = (request, verify) ->
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


expiry = (hours=24*7) ->
    d = new Date()
    d.setHours(d.getHours() + hours)
    d
