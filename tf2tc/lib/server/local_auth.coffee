



url = require 'url'
cookies = require 'cookies'
keygrip = require 'keygrip'


exports.authenticate = (params, cb) ->
    cs = parseCookies params
    id64 = cs.get 'id64', {signed: true, httpOnly: false}
    if id64
        cb success: true, user_id: decode id64
    else
        cb success: false, user_id: null


parseCookies = (p) ->
    new cookies dummyReq(p), dummyRes(), keygrip SS.config.keygrip.keys


decode = (v) ->
    decodeURI new Buffer(v, 'base64').toString()


dummyRes = () ->
    getHeader: () -> null,
    setHeader: () -> null,
    socket:
        encrypted: false


dummyReq = (cs) ->
    headers:
        cookie: cs
