

util = require 'util'
openid = require 'openid'
cookies = require 'cookies'
keygrip = require 'keygrip'
hashlib = require 'hashlib'


exports.authen = (c) ->
    (req, res, next) ->
        rp = relyingParty req, c.verify_path
        rp.authenticate c.provider_url, false, (error, provider) ->
            redirect res, provider if provider


exports.verify = (c) ->
    (req, res, next) ->
        rp = relyingParty req, c.verify_path
        rp.verifyAssertion req.url, (error, result) ->
            if !error and result.authenticated
                cs = new cookies req, res, keygrip SS.config.keygrip.keys
                cs.set 'id64', cookieEncode(result.claimedIdentifier), {signed: true, httpOnly: false, expires:expiry()}
                redirect res, c.success_path
            else
                redirect res, c.failure_path


foo = (req, res, next) ->
    ## when the logout url is requested, clear the authentication
    ## cookie and redirect.
    if u.pathname == c.logout_path
        cs = new cookies req, res
        cs.set 'id64', ''
        console.log "HAVE SESSION"
        #console.log "LOGOUT: ", SS

        redirect res, c.success_path


cookieEncode = (v) ->
    encodeURI new Buffer(v).toString('base64')


relyingParty = (request, verify) ->
    realm = 'http://' + request.headers.host
    new openid.RelyingParty(
        realm + verify,   # verification url
        realm,            # realm (optional, specifies realm for openid authentication)
        true,             # use stateless verification
        false,            # strict mode
        []                # list of extensions to enable and include
    )


redirect = (res, location, code=302) ->
    res.statusCode = code
    res.setHeader 'Location', location
    res.end()


expiry = (hours=24*7) ->
    d = new Date()
    d.setHours(d.getHours() + hours)
    d

