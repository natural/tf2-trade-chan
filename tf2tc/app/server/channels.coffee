utils = require './utils.coffee'
steam = require './steam.coffee'


exports.actions =
    join: (params, cb) ->
        name = params.name
        @getSession (session) ->
            msg = what:'joined', name:name
            makeProfileMessage session, msg, (res) ->
                session.channel.subscribe name
                R.rpush keys.channelUserList(name), res.who, (err, okay) ->
                    if okay and not err
                        R.rpush keys.userChannels(res.id64), name
                        SS.publish.channel [name], 'sys-chan-msg', res
                        cb()

    leave: (params, cb) ->
        name = params.name
        @getSession (session) ->
            msg = what:'left', name:name
            makeProfileMessage session, msg, (res) ->
                session.channel.unsubscribe name
                R.lrem keys.channelUserList(name), 0, res.who, (err, okay) ->
                    R.lrem keys.userChannels(res.id64), 0, name
                    SS.publish.channel [name], 'sys-chan-msg', res
                    cb()

    leaveAll: (params, cb) ->
        id64 = utils.getId64 params.session
        if id64
            R.lrange "channels:#{id64}", 0, -1, (err, vals) ->
                for name in vals
                    exports.actions.leave name
        cb()

    list: (params, cb) ->
        R.lrange keys.channelUserList(params.name), 0, -1, (err, val) ->
            cb val

    say: (params, cb) ->
        @getSession (session) ->
            msg = what:'said', name:params.name, text:params.text
            makeProfileMessage session, msg, (res) ->
                SS.publish.channel [params.name], 'user-chan-msg', res
                cb()


keys =
    userChannels: (id64) ->
        "channels:#{id64}"

    channelUserList: (c) ->
        "cusers:#{c}"


## we can't call SS.server.app.userProfile directly because that gets
## some session wiring crossed, giving us the wrong profile as the
## source of the message.
makeProfileMessage = (session, data, cb) ->
    if session.user.loggedIn() and session.user_id
        id64 = utils.getId64 session
        if id64
            steam.actions.profile {id64: id64}, (profile) ->
                username = profile.personaname
                if username
                    data.id64 = id64
                    data.who = username
                    cb data
