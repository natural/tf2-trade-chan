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
    console.log "DISCONNECT user_id=#{session.user_id}"
    dummy = user_id:session.user_id
    SS.server.channels.leaveAll session:dummy, ->
        session.user.logout()
