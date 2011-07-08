# server code

http = require('http')


exports.actions =
  init: (cb) ->
    cb "version: #{SS.version} websockets: okay app: 4"

  sign_in: (user, cb) ->
    @session.setUserId user
    cb user

  send_message: (params, cb) ->
    SS.publish.user params.user, 'user_message', {source: @session.user_id, body: params.message}
    cb true

  broadcast_message: (params, cb) ->
    SS.publish.broadcast 'group_message', {source: @session.user_id, body: params.message}
    cb true


  auth: (params, cb) ->
    @session authenticate 'openid_auth', params, (response) =>
        @session.setUserId(response.user_id) if response.success
        cb(response)

  logout: (cb) ->
    @session.user.logout(cb)

  user_data: (params, cb) ->
    @session.authenticate 'local_auth', params, (response) =>
        if response.success
          @session.setUserId(response.user_id)
          cb {auth:@session.user.loggedIn(), key:@session.user.key()}
        else
          cb {auth:false, key:null}

  secret: (params, cb) ->
    @session.authenticate 'local_auth', params, (response) =>
        @session.setUserId(response.user_id) if response.success
        cb('secret:  i like turtles') if response.success
        cb('no secret for you') if !response.success

  get_profile: (params, cb) ->
    options =
      host: 'tf2apiproxy.appspot.com',
      port: 80,
      path: '/api/v2/public/profile/' + params.id64
    http.get options, (res) ->
        res.setEncoding 'utf8'
        d = ''
        res.on 'data', (c) ->
          console.log c
          d += c
        res.on 'end', () ->
          cb d


  cfg: (cb) ->
    cb( SS.config.local )
