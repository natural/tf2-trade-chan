## client code


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
    SS.client.globals = {}

    SS.events.on('user_message', (msg) -> console.log('user message:', msg))
    SS.events.on('group_message', (msg) -> console.log('group message:', msg))
    SS.server.app.init (response) ->
        $('#message').text 'connected, ' + response

        SS.server.app.login document.cookie, (response) ->
            if !response.success
                $('#auth').show()
            else
                SS.server.app.user_data (data) ->
                    $('#user').prepend('Welcome, ' + data.profile.personaname + '<br>').show()
                    $('#backpack-msg').text('Loading backpack...')

                    SS.server.app.backpack (backpack) ->
                        $('#backpack-msg').text('Loading schema...')
                        SS.server.app.schema (schema) ->
                            ## $('#backpack').text('') #"Backpack ( #{JSON.stringify(backpack).length} ) and schema ( #{JSON.stringify(schema).length} ) loaded.")
                            set_schema SS.client.globals, schema
                            set_backpack SS.client.globals, backpack
                            draw_backpack SS.client.globals, $('#backpack'), () ->
                                $('#backpack').slideDown()
                                $('#backpack-msg').slideUp().text('')


set_backpack = (ns, backpack) ->
    backpack_items = {}
    for bitem in backpack.result.items.item
        do (bitem) ->
            pos = bitem.inventory & 0xFFFF
            backpack_items[pos] = bitem
    ns.backpack = backpack
    ns.backpack_items = backpack_items


set_schema = (ns, schema) ->
    schema_items = {}
    for sitem in schema.result.items.item
        do (sitem) ->
            schema_items[sitem.defindex] = sitem
    ns.schema = schema
    ns.schema_items = schema_items


draw_backpack = (ns, target, cb) ->
    schema_items = ns.schema_items
    backpack_items = ns.backpack_items

    mkrow = () ->
        '<div class="row"></div>'

    mkitem = (d, t) ->
        if d
            v = "<div class='item'><img src='#{schema_items[d.defindex].image_url}' /> </div>"
        else
            v = "<div class='item'></div>"
        t.append(v)
        if d
            i = $('div.item:last', t)
            i.data('itemdef', d)
             .data('schemadef', schema_items[d.defindex])
             .addClass("qual-border-#{d.quality} qual-background-#{d.quality}")

    items = ns.backpack.result.items.item
    slots = ns.backpack.result.num_backpack_slots
    page_size = 25 # 50 # or 25
    pages = slots / page_size
    i = 0
    cols = 5 # 10 # or 5

    target.append(mkrow())
    row = $('div.row:last', target)
    for slot in [1..slots]
        do (slot) ->
            item = backpack_items[slot]
            mkitem(item, row)
            i += 1
            if !(i % cols) and slot < slots
                if !(i % page_size)
                    row.addClass 'bot'
                target.append(mkrow())
                row = $('div.row:last', target)

    cb()