##
# game_apps -> request handlers for various game data.
#
#

hashlib = require 'hashlib'
util = require 'util'
steam = require '../app/server/steam.coffee'


# when the game schema is requested, fetch it (possibly from cache)
# and return it or a 304.
exports.schema = (req, res, next) ->
    steam.actions.schema (s) ->
        maybe304 s, req, res


# when a game player profile is requested, fetch it (possibly from
# cache) and return it or a 304.
exports.profile = (req, res, next) ->
    steam.actions.profile id64:req.params[0], (p) ->
        maybe304 p, req, res


# when a game player backpack is requested, fetch it (possibly from
# cache) and return it or a 304.
exports.items = (req, res, next) ->
    steam.actions.items id64:req.params[0], (i) ->
        maybe304 i, req, res


maybe304 = (obj, req, res, mime='text/javascript') ->
    con = 'Content-type':mime
    if not obj
        res.writeHead 500, con
        res.end ''
        return
    str = JSON.stringify obj
    tag = hashlib.md5 str
    res.setHeader 'ETag', tag
    if req.headers['if-none-match'] == tag
        util.log "ETag object data hit #{req.url}"
        res.setHeader 'Content-Length', 0
        res.writeHead 304, con
        res.end ''
    else
        util.log "ETag object data miss #{req.url}"
        res.writeHead 200, con
        res.end str
