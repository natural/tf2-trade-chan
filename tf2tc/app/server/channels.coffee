## server-side chat interface
#

utils = require './utils.coffee'
steam = require './steam.coffee'


exports.actions =
    join: (params, cb) ->
        @getSession (session) ->
            if not session.user.loggedIn() or not session.user_id
                return
            channel = params.channel
            profileMessage utils.getId64(session), what:'joined', channel:channel, (msg) ->
                session.channel.subscribe channel
                R.rpush keys.userList(channel), msg.id64, (err, okay) ->
                    if okay and not err
                        R.rpush keys.currentChannels(msg.id64), channel
                        SS.publish.channel [channel], keys.sysMsg, msg
                        cb()

    leave: (params, cb) ->
        @getSession (session) ->
            if not session.user.loggedIn() or not session.user_id
                return
            channel = params.channel
            profileMessage utils.getId64(session), what:'left', channel:channel, (msg) ->
                session.channel.unsubscribe channel
                R.lrem keys.userList(channel), 0, msg.id64, (err, okay) ->
                    R.lrem keys.currentChannels(msg.id64), 0, channel
                    SS.publish.channel [channel], keys.sysMsg, msg
                    cb()

    leaveAll: (params, cb) ->
        id64 = utils.getId64 params.session
        if not id64
            return
        profileMessage id64, what:'left', (res) ->
            R.lrange "channels:#{id64}", 0, -1, (err, channels) ->
                for channel in channels
                    do(channel) ->
                        msg = channel:channel, id64:id64, who:res.who, what:'left'
                        R.lrem keys.userList(channel), 0, id64, (err, okay) ->
                            R.lrem keys.currentChannels(id64), 0, channel, () ->
                                SS.publish.channel [channel], keys.sysMsg, msg
        cb()

    list: (params, cb) ->
        R.lrange keys.userList(params.channel), 0, -1, (err, val) ->
            cb val

    say: (params, cb) ->
        @getSession (session) ->
            if not session.user.loggedIn() or not session.user_id
                return
            msg = what:'said', channel:params.channel, text:params.text
            profileMessage utils.getId64(session), msg, (res) ->
                SS.publish.channel [params.channel], keys.usrMsg, res
                cb()


keys =
    sysMsg: 'sys-msg'
    usrMsg: 'usr-msg'

    currentChannels: (id64) ->
        "channels:#{id64}"

    userList: (c) ->
        "channel:users:#{c}"


# we can't call SS.server.app.userProfile directly because that gets
# some session wiring crossed, giving us the wrong profile as the
# source of the message.
profileMessage = (id64, proto, cb) ->
    steam.actions.profile id64:id64, (profile) ->
        usr = profile.personaname
        if usr
            proto.id64 = id64
            proto.who = usr
            cb proto
