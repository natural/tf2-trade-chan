## client code


at_disconnect = ->
    $('#message').text('SocketStream server is down :-(')
    console.log('socket down')

at_connect = ->
    $('#message').text('SocketStream server is up :-)')
    console.log('socket up')




exports.init = ->
    player_namespace = {}

    SS.socket.on 'disconnect', ->  at_disconnect
    SS.socket.on 'connect', -> at_connect
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
                    $('#backpack-msg').text 'Loading backpack...'

                    SS.server.app.backpack (backpack) ->
                        $('#backpack-msg').text 'Loading schema...'
                        SS.server.app.schema (schema) ->
                            set_schema player_namespace, schema
                            set_backpack player_namespace, backpack
                            draw_backpack player_namespace, $('#backpack'), () ->
                                $('#backpack').slideDown()
                                $('#backpack-msg').slideUp().text('')


set_backpack = (ns, bp) ->
    items = {}
    for item in bp.result.items.item
        do (item) -> items[item.inventory & 0xFFFF] = item
    ns.backpack = bp
    ns.backpack_items = items


set_schema = (ns, sch) ->
    items = {}
    for item in sch.result.items.item
        do (item) -> items[item.defindex] = item
    ns.schema = sch
    ns.schema_items = items


draw_backpack = (ns, target, cb) ->

    mk_row = () ->
        '<div class="row"></div>'

    mk_item = (d, t) ->
        if d
            v = "<div class='item'><img src='#{ns.schema_items[d.defindex].image_url}' /> </div>"
        else
            v = "<div class='item'></div>"
        t.append(v)
        if d
            i = $ 'div.item:last', t
            i.data 'itemdef', d
            i.data 'schemadef', ns.schema_items[d.defindex]
            i.addClass "qual-border-#{d.quality} qual-background-#{d.quality}"

    items = ns.backpack.result.items.item
    slots = ns.backpack.result.num_backpack_slots
    page_size = 25 # 50 # or 25
    pages = slots / page_size
    i = 0
    cols = 5 # 10 # or 5

    target.append mk_row()
    row = $ 'div.row:last', target
    for slot in [1..slots]
        do (slot) ->
            item = ns.backpack_items[slot]
            mk_item item, row
            i += 1
            if !(i % cols) and slot < slots
                if !(i % page_size)
                    row.addClass 'bot'
                target.append mk_row()
                row = $ 'div.row:last', target

    cb()