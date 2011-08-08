## middleware to handle specific urls: openid authentication, game
## data, and player data.
#
#
url = require 'url'
util = require 'util'
openid = require 'openid'
cookies = require 'cookies'
keygrip = require 'keygrip'
hashlib = require 'hashlib'
steam = require '../app/server/steam.coffee'

module.exports = (req, res, next) ->
    u = url.parse req.url
    c = SS.config.openid_auth

    ## when the login url is requested, setup the openid url and
    ## redirect the client to it.
    if u.pathname == c.authen_path
        rp = relyingParty req, c.verify_path
        rp.authenticate c.provider_url, false, (error, provider) ->
            redirect res, provider if provider

    ## when the user verification url is requested, check with the
    ## openid provider, and redirect the user appropriately.
    else if u.pathname == c.verify_path
        rp = relyingParty req, c.verify_path
        rp.verifyAssertion req.url, (error, result) ->
            if !error and result.authenticated
                cs = new cookies req, res, keygrip SS.config.keygrip.keys
                cs.set 'id64', cookieEncode(result.claimedIdentifier), {signed: true, httpOnly: false, expires:expiry()}
                redirect res, c.success_path
            else
                redirect res, c.failure_path

    ## when the logout url is requested, clear the authentication
    ## cookie and redirect.
    else if u.pathname == c.logout_path
        cs = new cookies req, res
        cs.set 'id64', ''
        console.log "HAVE SESSION"
        #console.log "LOGOUT: ", SS

        redirect res, c.success_path

    ## when the game schema is requested, fetch it (possibly from
    ## cache) and return it or a 304.
    else if u.pathname == '/schema'
        steam.actions.schema (s) ->
            maybe304 s, req, res

    ## when a game player profile is requested, fetch it (possibly
    ## from cache) and return it or a 304.
    else if u.pathname.match(/^\/profile\/7656\d{12}/)
        steam.actions.profile {id64:u.pathname.split('/').pop()}, (p) ->
            maybe304 p, req, res

    ## when a game player backpack is requested, fetch it (possibly
    ## from cache) and return it or a 304.
    else if u.pathname.match(/^\/items\/7656\d{12}/)
        steam.actions.items {id64:u.pathname.split('/').pop()}, (i) ->
            maybe304 i, req, res

    ## not a local, custom url; call the next middleware.
    else
        next()


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


maybe304 = (obj, req, res, mime='text/javascript') ->
    if not obj
        res.writeHead 500, {'Content-type':mime}
        res.end ''
        return
    str = JSON.stringify obj
    tag = hashlib.md5 str
    res.setHeader 'ETag', tag
    if req.headers['if-none-match'] == tag
        util.log "etag object data hit #{req.url}"
        res.setHeader 'Content-Length', 0
        res.writeHead 304, {'Content-type':mime}
        res.end ''
    else
        util.log "etag object data miss #{req.url}"
        res.writeHead 200, {'Content-type':mime}
        res.end str