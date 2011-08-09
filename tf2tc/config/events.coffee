# Server-side Events
# ------------------
# Uncomment these events to run your own custom code when events are fired

# SS.events.on 'client:init', (session) ->
#  console.log "The client with session_id #{session.id} has initialized!"

#SS.events.on 'client:heartbeat', (session) ->
#  console.log "The client with session_id #{session.id} is still alive!"

#SS.events.on 'client:disconnect', (session) ->
#  console.log "The client with session_id #{session.id} has disconnected"


SS.events.on 'client:disconnect', (session) ->
    # well, this sucks.  session.user_id is gone by the time this
    # function gets called, so we have to peek into redis.
    R.hget "ss:session:#{session.id}", 'user_id', (err, user_id) ->
        if not err
            alternate = user_id:user_id
            SS.server.channels.leaveAll session:alternate, ->
                session.user.logout() if false
            # TODO:  remove trades, too.

