## server code
util = require('util')
steam = require('./steam.coffee')


## trade:id:gen

exports.actions =
    init: (cb) ->
        @getSession (session) ->
            session.on 'disconnect', client_disconnect
            client_connect(session)

        cb "framework: #{SS.version}, websockets: okay, application: v07"

    send_message: (params, cb) ->
        SS.publish.user params.user, 'user_message', {source: @session.user_id, body: params.message}
        cb true

    broadcast_message: (params, cb) ->
        SS.publish.broadcast 'group_message', {source: @session.user_id, body: params.message}
        cb true

    login: (params, cb) ->
        @session.authenticate 'local_auth', params, (response) =>
            @session.setUserId(response.user_id) if response.success
            cb(response)

    logout: (cb) ->
        @session.user.logout(cb)

    user_data: (cb) ->
        if @session.user.loggedIn()
            uid = @session.user_id
            steam.actions.profile {id64: uid.split('/').pop()}, (profile) ->
                cb {auth: true, user_id: uid, profile: profile}
        else
            cb {auth: false, user_id: null, profile: {}}

    user_profile: (params, cb) ->
        steam.actions.profile params, cb

    backpack: (cb) ->
        if @session.user.loggedIn()
            uid = @session.user_id
            id64 = uid.split('/').pop()
            steam.actions.items {id64:id64}, cb
        else
            cb {}

    schema: (cb) ->
        steam.actions.schema cb

    trades: (cb) ->
        cb []


client_connect = (s) ->
    util.log "CONNECT user_id=#{s.user_id}"


client_disconnect = (s) ->
    util.log "DISCONNECT user_id=#{s.user_id}"
    s.user.logout()
