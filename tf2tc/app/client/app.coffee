## client code


exports.init = ->
    #SS.socket.on 'disconnect', ->  at_disconnect
    #SS.socket.on 'connect', -> at_connect
    #SS.events.on('user_message', (msg) -> console.log('user message:', msg))
    #SS.events.on('group_message', (msg) -> console.log('group message:', msg))

    SS.server.app.init (msg) ->
        $('#message').text msg
        $('div.item:not(:empty)').live 'mouseover', tt_over
        $('div.item:not(:empty)').live 'mouseout', tt_out
        SS.server.app.login document.cookie, (r) ->
            if r.success then init_app() else init_login()


init_login = ->
    $('#auth').show()


init_app = ->
    player_namespace = {}
    SS.player_namespace = player_namespace
    SS.server.app.user_data (data) ->
        $('#user').prepend("Welcome, #{data.profile.personaname} <br>").show()
        $('#backpack-msg').text 'Loading backpack...'
        SS.server.app.backpack (backpack) ->
            $('#backpack-msg').text 'Loading schema...'
            SS.server.app.schema (schema) ->
                set_schema player_namespace, schema
                set_backpack player_namespace, backpack
                draw_backpack player_namespace, $('#backpack'), 25, 5, ->
                    $('#backpack').slideDown()
                    $('#backpack-msg').slideUp().text('')


set_backpack = (ns, bp) ->
    items = {}
    for item in bp.result.items.item
        do (item) -> items[item.inventory & 0xFFFF] = item
    ns.backpack = bp
    ns.backpack_items = items # backpack item mapping by defindex


set_schema = (ns, sch) ->
    items = {}
    for item in sch.result.items.item
        do (item) -> items[item.defindex] = item
    ns.schema = sch
    ns.schema_items = items # schema item mapping by defindex

    attribs = {}
    for attr in sch.result.attributes.attribute
        do (attr) ->
            attribs[attr.name] = attr
            attribs[attr.defindex] = attr
    ns.schema_attribs = attribs

draw_backpack = (ns, target, page_size, cols, cb) ->

    mk_row = ->
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


tt_over = (e) ->
    tt = $('#tooltip').hide()
    cell = $(e.currentTarget)
    item = cell.data 'itemdef'
    sdef = cell.data 'schemadef'

    name = if item.custom_name then "\"#{item.custom_name}\"" else sdef.item_name
    type = sdef.item_type_name.replace('TF_Wearable_Hat', 'Wearable Item').replace('TF_LockedCrate', 'Crate')

    # set the level
    $('.level', tt).text(if item.level? then "Level #{item.level} #{type}" else '')

    # clear the quality classes and add the correct one
    for q in [0..20]
        do (q) -> $('.name', tt).removeClass("qual-text-#{q}")
    $('.name', tt).text(name).addClass("qual-text-#{item.quality}")

    # clear the crafter
    $('.crafter', tt).text('')

    # set the control text
    ctrl_text = ->
        i = JSON.stringify item, null, 2
        s = JSON.stringify sdef, null, 2
        "item: #{i}\n\nschema: #{s}"
    $('.ctrl', tt).html if e.ctrlKey then "<pre>#{ctrl_text()}</pre>" else ''

    # reset each of the extra lines
    for k, v of extra_line_map
        do(k, v) -> $(".#{v}", tt).text ''
    if item.attributes
        for idef in item.attributes.attribute
            do(idef) ->
                adef = SS.player_namespace.schema_attribs[idef.defindex]
                extra = format_schema_attr adef, idef.value
                etype = if adef then effect_type_map[adef.effect_type] else null

                ## 228: handle craft name
                if idef.defindex == 228
                    acc = calcs.value_is_account_id idef.value
                    $('.crafter', tt).text "Crafted by #{acc}"
                    SS.server.app.user_profile {id64:acc}, (p) ->
                        $('.crafter', tt).text "Crafted by #{p.personaname}"

    # reset the item description
    if sdef.item_description
        current = $('.alt', tt).html()
        ddesc = sdef.item_description
        if ddesc.indexOf('\n') > -1
            ddesc = ddesc.replace(/\n/g, '<br />')
        else
            ddesc = ddesc.wordwrap(64)
        $('.alt', tt).html (if current then current + '<br />' else '') + ddesc
    # position and show
    tt.css({left: Math.max(0, (cell.offset().left + (cell.width()/2) - (tt.width()/2))), top: cell.offset().top + cell.height()})
    tt.show()


tt_out = (e) ->
    $('#tooltip').hide()


extra_line_map =
    0: 'alt'
    1: 'positive'
    2: 'negative'


format_schema_attr = (def, val) ->
    line = if (def and def.description_string) then def.description_string.replace(/\n/gi, '<br />') else ''
    ## we only sub one '%s1'; that's the most there is (as of oct 2010)
    #if (line.indexOf('%s1') > -1)
        # line = line.replace('%s1', calcs[def['description_format']](val))
    if line.indexOf('Attrib_') > -1 then '' else line


calcs =
  value_is_additive: (a) -> a
  value_is_particle_index: (a) -> a
  value_is_or: (a) -> a
  value_is_percentage: (v) -> Math.round(v*100 - 100)
  value_is_inverted_percentage: (v) -> Math.round(100 - (v*100))
  value_is_additive_percentage: (v) -> Math.round(100*v)
  value_is_date: (v) -> new Date(v * 1000)
  value_is_account_id: (v) -> '7656' + (v + 1197960265728)


effect_type_map =
  negative: 'negative'
  neutral:'alt'
  positive: 'positive'

