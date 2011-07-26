steam = require('./steam.coffee')


exports.actions =
    join: (cname, cb) ->
        @getSession (session) ->
            SS.server.app.userProfile (profile) ->
                key = keys.channelUserList cname
                username = getProfileName profile
                R.rpush key, username, (err, okay) ->
                    if okay and not err
                        data = who: username, what: 'joined', cname: cname
                        session.channel.subscribe cname
                        SS.publish.channel [cname], 'sys-chan-msg', data



    leave: (cname, cb) ->
        @getSession (session) ->
            SS.server.app.userProfile (profile) ->
                username = getProfileName profile
                key = keys.channelUserList cname
                R.lrem key, 0, username, (err, okay) ->
                    data = who: username, what: 'left', cname: cname
                    session.channel.unsubscribe cname
                    SS.publish.channel [cname], 'sys-chan-msg', data

    list: (cname, cb) ->
        key = keys.channelUserList cname
        R.lrange key, 0, -1, (err, val) ->
            cb val

    say: (params, cb) ->
        cname = params.cname
        text = params.text
        @getSession (session) ->
            SS.server.app.userProfile (profile) ->
                username = getProfileName profile
                data = who: username, what: 'said', cname: cname, text: text
                SS.publish.channel [cname], 'user-chan-msg', data
                cb()


getProfileName = (info) ->
    if info.personaname then info.personaname else 'anon'


keys =
    channelUserList: (c) ->
        "cusers:#{c}"
