## server-side app module
#

utils = require './utils'
steam = require './steam.coffee'


exports.actions =
    init: (cb) ->
        cb framework:SS.version, websockets:true, application:'v07'

    backpack: (cb) ->
        @getSession (session) ->
            if session.user_id
                uid = session.user_id
                id64 = uid.split('/').pop()
                steam.actions.items id64:id64, cb
            else
                cb {}

    login: (params, cb) ->
        @getSession (session) ->
            session.authenticate 'local_auth', params, (response) =>
                session.setUserId(response.user_id) if response.success
                cb response

    logout: (cb) ->
        @getSession (session) ->
            session.user.logout(cb)
            session.setUserId(null)
            cb()

    readStatus: (params, cb) ->
        steam.actions.status params, cb

    readProfile: (params, cb) ->
        steam.actions.profile params, cb

    readProfileStatus: (params, cb) ->
        steam.actions.profile params, (p) ->
            steam.actions.status params, (s) ->
                p.state = if s and s.state then s.state else null
                p.stateMessage = if s and s.stateMessage then s.stateMessage else null
                cb p

    userProfile: (cb) ->
        @getSession (session) ->
            if session.user_id
                steam.actions.profile id64:utils.getId64(session), (profile) ->
                    cb profile
            else
                cb {}

    id64: (cb) ->
        @getSession (session) ->
            if session.user_id
                cb id64:utils.getId64(session)
            else
                cb {}

    data: (cb) ->
        @getSession (session) ->
            cb list:session.channel.list(), key:session.user.key()
