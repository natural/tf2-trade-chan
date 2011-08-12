##
# openid_apps -> request handlers for various openid urls (authen and verify)


cookies = require 'cookies'
hashlib = require 'hashlib'
keygrip = require 'keygrip'
openid = require 'openid'
util = require 'util'


# closure over the openid config; when the openid authentication url
# is requested, formulate the openid provider url and redirect the
# browser to it.
exports.authen = (c) ->
    (req, res, next) ->
        rp = relyingParty req, c.verify_path
        rp.authenticate c.provider_url, false, (error, provider) ->
            redirect res, provider if provider


# closure over the openid config; when the openid verification url is
# requested, set our cookie with the player's id64 if the verification
# is a success.  redirect the browser to either the success path or
# the failure path when complete.
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


cookieEncode = (v) ->
    encodeURI new Buffer(v).toString('base64')


relyingParty = (request, verify) ->
    realm = (if SS.config.https.enabled then 'https://' else 'http://') + request.headers.host
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

