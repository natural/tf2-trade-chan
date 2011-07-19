## client app

## TODO:  add better feedback during auth load.

exports.init = ->
    SS.server.app.init (msg) ->
        $('#message').text msg
        boot()

boot = ->
    window.oo = SS.client.util
    window.playerNS = playerNS = {}
    jQuery.fn.resetQualityClasses = (v) ->
        this.each () ->
            for q in [0..20]
                $(this).removeClass("qual-border-#{q} qual-hover-#{q} qual-text-#{q}")
            $(this).addClass(v)

    $('div.item:not(:empty)').live 'mouseover', {ns:playerNS}, SS.client.tooltip.show
    $('div.item:not(:empty)').live 'mouseout', {ns:playerNS}, SS.client.tooltip.hide
    SS.server.app.login document.cookie, (r) ->
        (if r.success then bootUser else bootAnon)(playerNS)


bootAnon = (ns) ->
    $('#login').show()


bootUser = (ns) ->
    SS.server.app.userProfile (data) ->
        $('#logout').prepend("Welcome, #{data.profile.personaname}.&nbsp;").show()
        $('#backpack-msg').text 'Loading backpack...'
        $('body').bind 'trade-changed', tradeChanged
        SS.server.app.backpack (backpack) ->
            oo.makeBackpack ns, backpack
            $('#backpack-msg').text 'Loading schema...'
            SS.server.app.schema (schema) ->
                oo.makeSchema ns, schema
                putBackpack ns, $('#backpack'), 25, 5, ->
                    $('#backpack-msg').slideUp().text('')
                    SS.server.trades.userTrades {}, (trades) ->
                        putTrades ns, trades, $('#trades'), ->
                            configBackpack $('#backpack'), $('#trades')
                            $('#user-container').slideDown()
                        putChooser ns, $('#chooser'), ->
                            configChooser $('#chooser'), $('#trades')
                            $('#chooser-container').slideDown()


putChooser = (ns, target, cb) ->
    grp = ns.schema.ext.groups
    clone = (id, q) ->
        x = JSON.parse(JSON.stringify(ns.schema_items[id]))
        x.quality = q
        x
    add = (title) ->
        target.append $('#chooser-proto').tmpl({title:title})
        $('.chooser-group:last', target)
    put = (items) ->
        i = 0
        target.append makeItemRow()
        row = $ 'div.row:last', target
        cols = 5
        page_size = 25
        for item in items
            makeItem ns, item, row, 'chooser'
            i += 1
            if !(i % cols) and i < items.length
                target.append makeItemRow()
                row = $ 'div.row:last', target

    put (clone(x, 6) for x in grp.commodities), add('Commodities')
    put (clone(x, 6) for x in grp.promos), add('Promos')
    put (clone(x, 3) for x in grp.vintage_hats), add('Vintage Hats')
    put (clone(x, 1) for x in grp.genuine_hats), add('Genuine Hats')
    put (clone(x, 3) for x in grp.vintage_weapons), add('Vintage Weapons')
    put (clone(x, 1) for x in grp.genuine_weapons), add('Genuine Weapons')
    cb()


makeItemProps = (ns, defn) ->
    selectAttr = (id) ->
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
        p = selectAttr(142)
        if p then p.float_value else null

    effect: () ->
        if defn.defindex==143
            99
        else if defn.defindex==1899
            20
        else
            e = selectAttr(134)
            if e then e.float_value else null

    useCount: () ->
        if defn.defindex in (t.defindex for t in ns.schema_tools()) or defn.defindex in (t.defindex for t in ns.schema_actions())
            defn.quantity

makeItemRow = -> '<div class="row"></div>'


makeItem = (ns, defn, target, type) ->
    if defn
        v = "<div class='itemw'>
               <div class='item #{type}'>
                 <img src='#{ns.schema_items[defn.defindex].image_url}' />
               </div>
             </div>"
        target.append v
    else
        v = '<div class="itemw"><div class="item" /></div>'
        target.append v
        return

    props = makeItemProps ns, defn
    item = $ 'div.item:last', target
    item.data 'item-defn', defn
    item.data 'schema-defn', ns.schema_items[defn.defindex]
    item.addClass "qual-border-#{defn.quality or 6} qual-hover-#{defn.quality or 6}"
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
    count = props.useCount()
    if count?
        img.wrap '<div class="deco" />'
        img.parent().append "<div class='badge quantity'>#{count}</div>"

    ## effect bg
    effect = props.effect()
    img.wrap "<div class='deco effect effect-#{effect}' />" if effect


putBackpack = (ns, target, page_size, cols, cb) ->
    i = 0
    items = ns.backpack.result.items.item
    slots = ns.backpack.result.num_backpack_slots
    target.append makeItemRow()
    row = $ 'div.row:last', target
    for slot in [1..slots]
        item = ns.backpack_items[slot]
        makeItem ns, item, row, 'backpack'
        i += 1
        if !(i % cols) and slot < slots
            row.addClass 'bot' if !(i % page_size)
            target.append makeItemRow()
            row = $ 'div.row:last', target
    cb()


putTrades = (ns, trades, target, cb) ->
    $('a.clear-trade', target).live 'click', (e) ->
        p = $(e.currentTarget).parents('div.trade')
        j = p.data('tno')
        p.replaceWith $('#trade-proto').tmpl({index:j}).data('tno', j)
        configBackpack $('#backpack'), $('#trades')
        configChooser $('#chooser'), $('#trades')
        false
    $('a.set-trade', target).live 'click', (e) ->
        p = $(e.currentTarget).parents('div.trade')
        have = ($(i).data('item-defn') for i in $('div.backpack', p))
        want = ($(i).data('item-defn') for i in $('div.chooser', p))
        if have and have.length
            SS.server.trades.publish {have:have, want:want}, (status) ->
                console.log 'publishing status:', status
        false
    $('div.item.chooser', target).live 'click', (e) ->
        item = $(e.currentTarget)
        id = item.data('item-defn').defindex
        qualseq = ns.schema.ext.quals[id]
        qualc = item.data('qual')
        if qualc?
            i = qualseq.indexOf(qualc)
        else
            i = 1
        j = qualseq[(i+1) % qualseq.length]
        item.data('qual', j)
        item.resetQualityClasses("qual-border-#{j} qual-hover-#{j}")
        item.data('item-defn').quality = j
        item.trigger('mouseout').trigger('mouseover')

    for i in [0..3]
        j = i + 1
        target.append $('#trade-proto').tmpl({index:j}).data('tno', j)
    cb()


configChooser = (source, target) ->
    sources = -> $('div.item:not(:empty):not(.untradable)', source)
    targets = -> $('div.item.want:empty', target)

    copy = (a, b) ->
        c = a.clone(true, true).unbind()
        t = b.parents '.trade'
        id = a.data('item-defn').id
        r = b.clone(false, false)
        b.replaceWith c
        SS.client.tooltip.hide()
        $('body').trigger 'trade-changed', t
        c.dblclick (e) ->
            SS.client.tooltip.hide()
            c.replaceWith r
            r.droppable dropOpts
            $('body').trigger 'trade-changed', t

    copyToTrade = (e) ->
        s = $ e.currentTarget
        avail = (x for x in $('.trade', target))
        if avail
            a = $ avail[0]
            t = $ 'div.item.want:empty:first', a
            copy s, t
        ## else alert or message or something

    dragOpts =
        helper: 'clone'
        revert: 'invalid'
        cursor: 'move'
        start: (e, ui) ->
            q = ui.helper.prevObject.data('item-defn').quality
            ui.helper.addClass "qual-background-#{q} z-top"

    dropOpts =
        accept: 'div.item.chooser'
        hoverClass: 'outline'
        drop: (e, ui) ->
            s = ui.helper.prevObject
            copy s, $(this)

    sources().unbind('dblclick').dblclick copyToTrade
    sources().draggable dragOpts
    targets().droppable dropOpts



configBackpack = (source, target) ->
    sources = -> $('div.item:not(:empty):not(.untradable)', source)
    targets = -> $('div.item.have:empty', target)

    copy = (a, b) ->
        c = a.clone(true, true).unbind()
        t = b.parents '.trade'
        id = a.data('item-defn').id
        r = b.clone(false, false)
        b.replaceWith c
        SS.client.tooltip.hide()
        $('body').trigger 'trade-changed', t
        c.dblclick (e) ->
            SS.client.tooltip.hide()
            c.replaceWith r
            r.droppable dropOpts
            ids = t.data 'ids'
            ids.splice ids.indexOf(id), 1
            $('body').trigger 'trade-changed', t

    copyToTrade = (e) ->
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

    dragOpts =
        helper: 'clone'
        revert: 'invalid'
        cursor: 'move'
        start: (e, ui) ->
            q = ui.helper.prevObject.data('item-defn').quality
            ui.helper.addClass "qual-background-#{q} z-top"

    dropOpts =
        accept: 'div.item.backpack'
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

    sources().unbind('dblclick').dblclick copyToTrade
    sources().draggable dragOpts
    targets().droppable dropOpts


tradeChanged = (e, tc) ->
    have = $ 'div.item.backpack:not(:empty)', tc
    if have.length
        $('a.set-trade', tc).slideDown()
    else
        $('a.set-trade', tc).slideUp()
    want = $ 'div.item.chooser:not(:empty)', tc
    if want.length or have.length
        $('a.clear-trade', tc).slideDown()
    else
        $('a.clear-trade', tc).slideUp()
