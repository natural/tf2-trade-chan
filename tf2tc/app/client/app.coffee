# client code


at_disconnect = ->
  $('#message').text('SocketStream server is down :-(')
  console.log('socket down')

at_connect = ->
  $('#message').text('SocketStream server is up :-)')
  console.log('socket up')


SS.socket.on 'disconnect', ->  at_disconnect
SS.socket.on 'connect', -> at_connect

# This method is called automatically when the websocket connection is established. Do not rename/delete
exports.init = ->

  # Make a call to the server to retrieve a message
  SS.server.app.init (response) ->
    $('#message').text 'connected, ' + response
    SS.server.app.user_data document.cookie, (ud) ->
        if !ud.auth
          $('#auth').show()
        else
          $('#user').prepend('Welcome, ' + ud.key).show()

  SS.events.on('user_message', (msg) -> console.log('user message:', msg))
  SS.events.on('group_message', (msg) -> console.log('group message:', msg))


