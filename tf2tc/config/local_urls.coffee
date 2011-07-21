## middleware to handle specific urls: openid authentication, game
## data, and player data.
#
#
url = require 'url'
util = require 'util'
openid = require 'openid'
cookies = require 'cookies'
keygrip = require 'keygrip'
server = require 'socketstream/lib/utils/server.coffee'
hashlib = require 'hashlib'


exports.call = (request, response, next) ->
    u = url.parse request.url
    c = SS.config.openid_auth

    ## when the login url is requested, setup the openid url and
    ## redirect the client to it.
    if u.pathname == c.authen_path
        rp = relyingParty request, c.verify_path
        rp.authenticate c.provider_url, false, (error, provider) ->
            redirect response, provider if provider

    ## when the user verification url is requested, check with the
    ## openid provider, and redirect the user appropriately.
    else if u.pathname == c.verify_path
        rp = relyingParty request, c.verify_path
        rp.verifyAssertion request.url, (error, result) ->
            if !error and result.authenticated
                cs = new cookies request, response, keygrip SS.config.keygrip.keys
                cs.set 'id64', cookieEncode(result.claimedIdentifier), {signed: true, httpOnly: false, expires:expiry()}
                redirect response, c.success_path
            else
                redirect response, c.failure_path

    ## when the logout url is requested, clear the authentication
    ## cookie and redirect.
    else if u.pathname == c.logout_path
        cs = new cookies request, response
        cs.set 'id64', ''
        redirect response, c.success_path

    ## when the game schema is requested, fetch it (possibly from
    ## cache) and return it or a 304.
    else if u.pathname == '/schema'
        SS.server.steam.schema (s) ->
            maybe304 s, server, request, response

    ## when a game player profile is requested, fetch it (possibly
    ## from cache) and return it or a 304.
    else if u.pathname.match(/^\/profile\/7656\d{12}/)
        SS.server.steam.profile {id64:u.pathname.split('/').pop()}, (p) ->
            maybe304 p, server, request, response

    ## when a game player backpack is requested, fetch it (possibly
    ## from cache) and return it or a 304.
    else if u.pathname.match(/^\/items\/7656\d{12}/)
        SS.server.steam.items {id64:u.pathname.split('/').pop()}, (i) ->
            maybe304 i, server, request, response

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


redirect = (response, location, code=302) ->
    response.statusCode = code
    response.setHeader 'Location', location
    response.end()


expiry = (hours=24*7) ->
    d = new Date()
    d.setHours(d.getHours() + hours)
    d


maybe304 = (obj, server, request, response, mime='text/javascript') ->
    str = JSON.stringify obj
    tag = hashlib.md5 str
    response.setHeader 'ETag', tag
    if request.headers['if-none-match'] == tag
        util.log "etag object data hit #{request.url}"
        response.setHeader 'Content-Length', 0
        server.deliver response, 304, mime, ''
    else
        util.log "etag object data miss #{request.url}"
        server.deliver response, 200, mime, str
