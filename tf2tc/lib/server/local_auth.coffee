url = require('url')
Cookies = require('cookies')
Keygrip = require('keygrip')


exports.authenticate = (params, cb) ->
  cookies = new Cookies dummyReq(params), dummyRes(), Keygrip SS.config.keygrip.keys
  id64 = cookies.get "id64", { signed: true, httpOnly: false } # needs date
  if id64
    id64 = decode(id64)
    cb {success: true, user_id: id64, info: {username: 'unknown', id64: id64}}
  else
    cb {success: false}


decode = (v) ->
  decodeURI( new Buffer(v, 'base64').toString() )


dummyRes = () ->
  getHeader: () -> null,
  setHeader: () -> null,
  socket:
    encrypted: false



dummyReq = (cs) ->
  headers:
    cookie: cs


