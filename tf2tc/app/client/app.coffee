## client code


exports.init = ->
    #SS.socket.on 'disconnect', ->  at_disconnect
    #SS.socket.on 'connect', -> at_connect
    #SS.events.on('user_message', (msg) -> console.log('user message:', msg))
    #SS.events.on('group_message', (msg) -> console.log('group message:', msg))
    SS.server.app.init (msg) ->
        $('#message').text msg
        boot()

boot = ->
    window.oo = SS.client.util
    player_ns = {}
    $('div.item:not(:empty)').live 'mouseover', ns:player_ns, show_tooltip
    $('div.item:not(:empty)').live 'mouseout', ns:player_ns, -> $('#tooltip').hide()


    SS.server.app.login document.cookie, (r) ->
        (if r.success then boot_user else boot_anon)(player_ns)


boot_anon = (ns) ->
    $('#login').show()


boot_user = (ns) ->
    SS.server.app.user_data (data) ->
        $('#logout').prepend("Welcome, #{data.profile.personaname} &nbsp;").show()
        $('#backpack-msg').text 'Loading backpack...'
        SS.server.app.backpack (backpack) ->
            oo.mk_backpack ns, backpack
            $('#backpack-msg').text 'Loading schema...'
            SS.server.app.schema (schema) ->
                oo.mk_schema ns, schema
                put_backpack ns, $('#backpack'), 25, 5, ->
                    $('#backpack-msg').slideUp().text('')
                    put_trades ns, $('#trades'), ->
                        dragdrop_items $('#backpack'), $('#trades')
                        $('#user-container').slideDown()


## TODO: add effects, paint swatch, nametags, desc tags, equipped
## badge, use count badge
put_backpack = (ns, target, page_size, cols, cb) ->
    mk_row = -> '<div class="row"></div>'
    mk_item = (d, t) ->
        if d
            v = "<div class='itemw'>
                   <div class='item'>
                     <img src='#{ns.schema_items[d.defindex].image_url}' />
                   </div>
                 </div>"
        else
            v = '<div class="itemw"><div class="item" /></div>'
        t.append(v)
        if d
            i = $ 'div.item:last', t
            i.data 'itemdef', d
            i.data 'schemadef', ns.schema_items[d.defindex]
            i.addClass "qual-border-#{d.quality} qual-hover-#{d.quality}"
            i.addClass "untradable" if d.flag_cannot_trade
    i = 0
    items = ns.backpack.result.items.item
    slots = ns.backpack.result.num_backpack_slots
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


mk_tooltip_vals = ->
    alt: ''
    ctrl: ''
    killeater: ''
    level: ''
    limiteduse: ''
    name: ''
    negative: ''
    neutral:''
    positive: ''


## TODO:  add untradable text
show_tooltip = (e) ->
    tt = $('#tooltip').hide()
    cell = $ e.currentTarget
    ns = e.data.ns
    item = cell.data 'itemdef'
    sdef = cell.data 'schemadef'
    vals = mk_tooltip_vals()
    if !sdef
        return
    type = sdef.item_type_name.replace('TF_Wearable_Hat', 'Wearable Item').replace('TF_LockedCrate', 'Crate')
    vals.level = "Level #{item.level} #{type}" if item.level?
    if item.custom_name
        vals.name =  "\"#{item.custom_name}\""
    else
        vals.name = sdef.item_name # if sdef.proper_name then sdef.name else sdef.item_name
    vals.name = "#{ns.schema_qualities[item.quality]} " + vals.name if item.quality in [3, 5, 11]

    # clear the quality classes and add the correct one
    for q in [0..20]
        do (q) -> $('.name', tt).removeClass("qual-text-#{q}")
    $('.name', tt).addClass("qual-text-#{item.quality}")

    ## clear the crafter value.  nb: crafter isn't set via the 'vals'
    ## object because of the async lookup
    $('.crafter', tt).text ''

    # set the control text
    ctrl_text = ->
        i = JSON.stringify item, null, 2
        s = JSON.stringify sdef, null, 2
        "item: #{i}\n\nschema: #{s}"
    vals.ctrl = "<pre>#{ctrl_text()}</pre>" if e.ctrlKey

    if item.attributes
        for idef in item.attributes.attribute
            do(idef) ->
                adef = ns.schema_attribs[idef.defindex]
                extra = oo.format_schema_attr adef, idef.value
                etype = if adef then adef.effect_type else null
                switch idef.defindex
                    when 134 ## effect name
                        vals[etype] = oo.format_schema_attr adef, oo.item_effects[idef.float_value]
                    when 186 ## gift
                        acc = oo.value_format_map.value_is_account_id idef.value
                        $('.crafter', tt).text "Gift from #{acc}."
                        oo.get_profile acc, (p) ->
                            $('.crafter', tt).text "Gift from #{p.personaname}."
                    when 187 ## crate series
                        vals[etype] = oo.format_schema_attr adef, idef.float_value
                    when 214 ## kill eater
                        vals.killeater = "Kills: #{idef.value}"
                        vals.name = vals.name.replace 'Strange', oo.strange_text(idef.value)
                    when 228 ## craft name
                        acc = oo.value_format_map.value_is_account_id idef.value
                        $('.crafter', tt).text "Crafted by #{acc}."
                        oo.get_profile acc, (p) ->
                            $('.crafter', tt).text "Crafted by #{p.personaname}."
                    when 229 ## craft number
                        vals.name = "#{vals.name} ##{idef.value}"
                    else
                        vals[etype] = extra

    if sdef.attributes
        for atyp in sdef.attributes.attribute
            do(atyp) ->
                adef = ns.schema_attribs[atyp.name]
                text = oo.format_schema_attr adef, atyp.value
                curr = vals[adef.effect_type]
                vals[adef.effect_type] = if curr then curr + '<br>' + text else text

    # reset the item description
    if sdef.item_description
        desc = sdef.item_description
        if desc.indexOf('\n') > -1
            desc = desc.replace(/\n/g, '<br />')
        else
            desc = desc.wordwrap(64)
        vals.alt = if vals.alt then "#{vals.alt} <br> #{desc}" else desc

    # set limited use count
    if item.defindex in (t.defindex for t in ns.schema_tools()) or item.defindex in (t.defindex for t in ns.schema_actions())
        if item.quantity?
            vals.limiteduse = "This is a limited use item.  Uses: #{item.quantity}"

    # set the values
    for k, v of vals
        do(k, v) -> $(".#{k}", tt).html v

    # position and show
    tt.css left: Math.max(0, (cell.offset().left + (cell.width()/2) - (tt.width()/2))), top: cell.offset().top + cell.height()
    tt.show()




put_trades = (ns, target, cb) ->
    for i in [0..4]
        do (i) ->
            $('#trades').append $('#trade-proto').tmpl({index:i+1})
    cb()


## TODO:  disallow moving of items *within* the target
dragdrop_items = (source, target) ->
    sources = -> $('div.item:not(:empty)', source).not('div.untradable')
    targets = -> $('div.item:empty', target).not('div.want')

    drag_options =
        helper: 'clone'
        revert: 'invalid'
        cursor: 'move'
        start: (e, ui) ->
            q = ui.helper.prevObject.data('itemdef').quality
            ui.helper.addClass "qual-background-#{q}"

    move = (src, trg) ->
        if !trg
            return
        srcp = src.parent()
        trgp = trg.parent()
        src.detach()
        trg.detach()
        srcp.append trg.removeClass('outline')
        trgp.append src
        src.unbind('dblclick').dblclick (e) ->
            src.detach()
            trg.detach()
            srcp.append src
            trgp.append trg
            src.unbind('dblclick').dblclick move_to_trade

    move_to_trade = (e) ->
        move $(e.currentTarget), targets().first()

    drop_options =
        accept: 'div.item'
        hoverClass: 'outline'
        drop: (e, ui) ->
            move ui.draggable, $(this)

    sources().draggable drag_options
    sources().dblclick move_to_trade
    targets().droppable drop_options

