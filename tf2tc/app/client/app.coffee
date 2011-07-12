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
    $('div.item:not(:empty)').live 'mouseout', ns:player_ns, hide_tooltip


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
                        config_backpack_selections $('#backpack'), $('#trades')
                        $('#user-container').slideDown()


mk_item_props = (ns, defn) ->
    attr_select = (id) ->
        if defn.attributes
            x = (n for n in defn.attributes.attribute)
            try
                (n for n in x when n.defindex==id)[0]
            catch e
                null
    equipped: () ->
        (defn.inventory & 0xff0000) != 0

    tag: () ->
        if defn.custom_desc and defn.custom_name
            '5020-5044'
        else if defn.custom_name
            '5020'
        else if defn.custom_desc
            '5044'

    paint: () ->
        p = attr_select(142)
        if p then p.float_value else null

    effect: () ->
        if defn.defindex==143
            99
        else if defn.defindex==1899
            20
        else
            e = attr_select(134)
            if e then e.float_value else null

    use_count: () ->
        if defn.defindex in (t.defindex for t in ns.schema_tools()) or defn.defindex in (t.defindex for t in ns.schema_actions())
            defn.quantity


put_backpack = (ns, target, page_size, cols, cb) ->
    mk_row = -> '<div class="row"></div>'

    mk_item = (defn, target) ->
        if defn
            v = "<div class='itemw'>
                   <div class='item'>
                     <img src='#{ns.schema_items[defn.defindex].image_url}' />
                   </div>
                 </div>"
            target.append v
        else
            v = '<div class="itemw"><div class="item" /></div>'
            target.append v
            return

        props = mk_item_props ns, defn
        item = $ 'div.item:last', target
        item.data 'item-defn', defn
        item.data 'schema-defn', ns.schema_items[defn.defindex]
        item.addClass "qual-border-#{defn.quality} qual-hover-#{defn.quality}"
        item.addClass "untradable" if defn.flag_cannot_trade
        img = $ 'img', item

        ## name tag and/or desc tag icon
        tag = props.tag()
        img.wrap "<div class='deco tag tag-#{tag}' />" if tag

        ## paint jewel
        jewel = props.paint()
        img.wrap "<div class='deco jewel jewel-#{jewel}' />" if jewel

        ## equipped badge
        equip = props.equipped()
        if equip
            img.wrap '<div class="deco" />'
            img.parent().append '<div class="badge equipped">Equipped</div>'

        ## use count badge
        count = props.use_count()
        if count?
            img.wrap '<div class="deco" />'
            img.parent().append "<div class='badge quantity'>#{count}</div>"

        ## effect bg
        effect = props.effect()
        img.wrap "<div class='deco effect effect-#{effect}' />" if effect

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
    untradable: ''


hide_tooltip = (e) -> $('#tooltip').hide()


show_tooltip = (e) ->
    tt = hide_tooltip()
    cell = $ e.currentTarget
    ns = e.data.ns
    item = cell.data 'item-defn'
    sdef = cell.data 'schema-defn'
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
        $('.name', tt).removeClass("qual-text-#{q}")
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
                    vals[etype] += ('<br>'+extra) if extra

    if sdef.attributes
        skips = ['set_employee_number', 'supply_crate_series']
        for atyp in sdef.attributes.attribute
            adef = ns.schema_attribs[atyp.name]
            if adef and adef.attribute_class not in skips
                text = oo.format_schema_attr adef, atyp.value
                curr = vals[adef.effect_type]
                vals[adef.effect_type] = if curr then curr + '<br>' + text else text

    # reset the item description
    if sdef.item_description
        desc = sdef.item_description
        if desc.indexOf('\n') > -1
            desc = desc.replace(/\n/g, '<br>')
        else
            desc = desc.wordwrap(64)
        vals.alt = if vals.alt then "#{vals.alt} <br> #{desc}" else desc

    # set limited use count
    if item.defindex in (t.defindex for t in ns.schema_tools()) or item.defindex in (t.defindex for t in ns.schema_actions())
        if item.quantity?
            vals.limiteduse = "<br>This is a limited use item.  Uses: #{item.quantity}"

    # set the untradable text
    if item.flag_cannot_trade
        vals.untradable = '<br>( Not Tradable )'

    # set the values
    for k, v of vals
        $(".#{k}", tt).html v

    # position and show
    left = cell.offset().left + (cell.width()/2) - (tt.width()/2)
    top = cell.offset().top + cell.height()
    tt.css {left:Math.max(0, left), top:top}
    tt.show()




put_trades = (ns, target, cb) ->
    for i in [0..2]
        target.append $('#trade-proto').tmpl({index:i+1})
    cb()


config_backpack_selections = (source, target) ->
    sources = -> $('div.item:not(:empty):not(.untradable)', source)
    targets = -> $('div.item.have:empty', target)

    copy = (a, b) ->
        c = a.clone(true, true).unbind()
        t = b.parents '.trade'
        id = a.data('item-defn').id
        b.replaceWith c
        hide_tooltip()
        c.dblclick (e) ->
            hide_tooltip()
            repl = $ '<div class="item" />'
            c.replaceWith repl
            repl.droppable drop_options
            ids = t.data 'ids'
            ids.splice ids.indexOf(id), 1

    copy_to_trade = (e) ->
        s = $ e.currentTarget
        i = s.data('item-defn').id
        avail = (x for x in $('.trade', target) when i not in ($(x).data('ids') or []))
        if avail
            a = $ avail[0]
            t = $ 'div.item.have:empty:first', a
            ids = a.data('ids') or []
            ids.push i
            a.data 'ids', ids
            copy s, t
        ## else alert or message or something

    drag_options =
        helper: 'clone'
        revert: 'invalid'
        cursor: 'move'
        start: (e, ui) ->
            q = ui.helper.prevObject.data('item-defn').quality
            ui.helper.addClass "qual-background-#{q} z-top"

    drop_options =
        accept: 'div.item'
        hoverClass: 'outline'
        drop: (e, ui) ->
            s = ui.helper.prevObject
            t = $(this).parents('.trade')
            ids = t.data('ids') or []
            i = s.data('item-defn').id
            if not (i in ids)
                ids.push i
                t.data 'ids', ids
                copy s, $(this)

    sources().dblclick copy_to_trade
    sources().draggable drag_options
    targets().droppable drop_options
