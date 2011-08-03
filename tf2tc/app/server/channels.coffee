utils = require './utils.coffee'
steam = require './steam.coffee'


exports.actions =
    join: (params, cb) ->
        channel = params.channel
        @getSession (session) ->
            msg = what:'joined', channel:channel
            makeProfileMessage session, msg, (res) ->
                session.channel.subscribe channel
                R.rpush keys.channelUserList(channel), res.id64, (err, okay) ->
                    if okay and not err
                        R.rpush keys.userChannels(res.id64), channel
                        SS.publish.channel [channel], keys.sysMsg, res
                        cb()

    leave: (params, cb) ->
        channel = params.channel
        @getSession (session) ->
            msg = what:'left', channel:channel
            makeProfileMessage session, msg, (res) ->
                session.channel.unsubscribe channel
                R.lrem keys.channelUserList(channel), 0, res.id64, (err, okay) ->
                    R.lrem keys.userChannels(res.id64), 0, channel
                    SS.publish.channel [channel], keys.sysMsg, res
                    cb()

    leaveAll: (params, cb) ->
        id64 = utils.getId64 params.session
        if id64
            R.lrange "channels:#{id64}", 0, -1, (err, channels) ->
                for channel in channels
                    exports.actions.leave channel:channel
        cb()

    list: (params, cb) ->
        R.lrange keys.channelUserList(params.channel), 0, -1, (err, val) ->
            cb val

    say: (params, cb) ->
        @getSession (session) ->
            msg = what:'said', channel:params.channel, text:params.text
            makeProfileMessage session, msg, (res) ->
                SS.publish.channel [params.channel], keys.usrMsg, res
                cb()


keys =
    sysMsg: 'sys-msg'
    usrMsg: 'usr-msg'

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
            steam.actions.profile id64:id64, (profile) ->
                username = profile.personaname
                if username
                    data.id64 = id64
                    data.who = username
                    cb data
