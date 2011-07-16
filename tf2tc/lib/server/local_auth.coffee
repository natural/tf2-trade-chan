url = require('url')
Cookies = require('cookies')
Keygrip = require('keygrip')


exports.authenticate = (params, cb) ->
    cs = cookies params
    id64 = cs.get 'id64', {signed: true, httpOnly: false} # needs date
    if id64
        cb success: true, user_id: decode id64
    else
        cb success: false, user_id: null


cookies = (p) ->
    new Cookies dummy_req(p), dummy_res(), Keygrip SS.config.keygrip.keys


decode = (v) ->
    decodeURI(new Buffer(v, 'base64').toString())


dummy_res = () ->
    getHeader: () -> null,
    setHeader: () -> null,
    socket:
        encrypted: false


dummy_req = (cs) ->
    headers:
        cookie: cs


