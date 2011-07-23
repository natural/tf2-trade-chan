steam = require('./steam.coffee')


exports.actions =
    join: (cname, cb) ->
        username = 'new user'
        @getSession (session) ->
            session.channel.subscribe cname
            data =
                msg: "#{username} has joined the channel."
                cname: cname
            SS.publish.channel [cname], 'sys-chan-msg', data

    leave: (cname, cb) ->
        username = 'unknown'
        @getSession (session) ->
            session.channel.unsubscribe cname
            if session.user.loggedIn()
                uid = session.user_id
                steam.actions.profile {id64: uid.split('/').pop()}, (profile) ->
                    username = profile.name
                    data =
                        msg: "#{username} has left the channel."
                        cname: cname
                    SS.publish.channel [cname], 'sys-chan-msg', data
            else
                data =
                    msg: "#{username} has left the channel."
                    cname: cname
                SS.publish.channel [cname], 'sys-chan-msg', data
