## client app
#


## this is the namespace for the schema, backpack, and various stuff.
## yes, it's a singleton, but we really don't use it that way.
exports.ns = {}


## this is the framework hook for initializing the app in the browser.
## the routine initializes the app, fetches the schema, and attempts
## an initial authorization.
exports.init = ->
    SS.server.app.init ->
        msg = $('#message').text 'Loading schema...'
        ns = exports.ns
        initJQ jQuery
        initEvents ns
        getSchema ns, ->
            $('body').trigger 'schema-ready'
            msg.append('done.').delay(2000).slideUp()
            SS.server.app.login document.cookie, (status) ->
                ns.auth = status.success
                (if status.success then bootUser else bootAnon)(ns)


bootAnon = ->
    $('#login').show()


bootUser = (ns) ->
    SS.server.app.userProfile (data) ->
        $('#logout').prepend("Welcome, #{data.profile.personaname}.&nbsp;").show()
        $('#user').slideDown()


        $('#backpack').bind 'lazy-load', (e) ->
            userbp = $ this
            bpshell = $ '.bpshell', userbp
            $('#user .bp .msg').text 'Loading...'

            getBackpack data.profile.steamid, ns, (backpack) ->
                putBackpack ns, bpshell, ->
                    layoutBackpack bpshell
                    initBackpackToolbar userbp, bpshell
                    $('#user .bp .msg').text ''


        $('#trades').bind 'lazy-load', (e) ->
                trades = $ this
                ch = $ '.chooser', trades
                chshell = $ '.bpshell', ch
                $('#user .ch .msg').text 'Loading...'

                putChooser ns, chshell, ->
                    layoutChooser chshell
                    $('#user .ch .msg').text ''

                return
                SS.server.trades.userTrades {}, (trades) ->
                    putTrades ns, trades, $('#trades'), ->
                        configBackpack $('#backpack'), $('#trades')


putChooser = (ns, target, cb) ->
    grp = ns.schema.ext.groups
    m = SS.client.item.make

    clone = (id, q) ->
        x = JSON.parse(JSON.stringify(ns.schema_items[id]))
        x.quality = q
        x
    add = (title) ->
        target.append $('#chooser-proto').tmpl title:title
        $('.chooserw:last', target)
    put = (items, t) ->
        for item in items
            m ns, item, t, 'chooser'

    put (clone(x, 6) for x in grp.commodities), add('Commodities')
    put (clone(x, 6) for x in grp.promos), add('Promos')
    put (clone(x, 3) for x in grp.vintage_hats), add('Vintage Hats')
    put (clone(x, 1) for x in grp.genuine_hats), add('Genuine Hats')
    put (clone(x, 3) for x in grp.vintage_weapons), add('Vintage Weapons')
    put (clone(x, 1) for x in grp.genuine_weapons), add('Genuine Weapons')
    cb()




putBackpack = (ns, target, cb) ->
    m = SS.client.item.make
    ts = ns.backpack_items
    mk = (s) -> m(ns, ts[s], target, 'backpack')
    mk(slot) for slot in [1..ns.backpack.result.num_backpack_slots]
    cb()


layoutBackpack = (target) ->
    mn = Number.MIN_VALUE
    cmp = (i, attr, which='item-defn', missing=Number.MAX_VALUE) ->
        d = i.find('.item').data(which)
        if d
            d[attr]
        else
            missing
    target.isotope
        itemSelector: '.itemw'
        layoutMode: 'fitRows'
        animationEngine: if $.browser.mozilla then 'jquery' else 'best-available'
        getSortData:
            quality:    (i) -> cmp i, 'quality'
            date:       (i) -> cmp i, 'id'
            date_desc:  (i) -> cmp i, 'id',             'item-defn', mn
            level:      (i) -> cmp i, 'level'
            level_desc: (i) -> cmp i, 'level',          'item-defn',   mn
            name:       (i) -> cmp i, 'item_name',      'schema-defn', 'ZZZ   '
            name_desc:  (i) -> cmp i, 'item_name',      'schema-defn', '   AAA'
            type:       (i) -> cmp i, 'item_type_name', 'schema-defn'

layoutChooser = (target) ->
    for grp in $('.chooserw', target)
        $(grp).isotope
            itemSelector: '.itemw'
            layoutMode: 'fitRows'
            animationEngine: if $.browser.mozilla then 'jquery' else 'best-available'
    f = -> $('.chooserw', target).isotope()
    setTimeout f, 100


initBackpackToolbar = (container, target) ->
    $('.bptools', container).fadeIn()

    $('.bpfilters', container).change ->
        sel = $(':selected', this).attr 'data-filter'
        if sel and sel.length
            target.isotope filter:sel
        false

    $('.bpsorts', container).change ->
        sel = $(':selected', this).attr 'data-sort'
        ord = $(':selected', this).attr 'data-desc'
        target.isotope sortBy:sel, sortAscending:not ord
        false






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
        SS.client.itemtip.hide()
        $('body').trigger 'trade-changed', t
        c.dblclick (e) ->
            SS.client.itemtip.hide()
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
            ui.helper.addClass "qual-background-#{q} ztop"

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
        SS.client.itemtip.hide()
        $('body').trigger 'trade-changed', t
        c.dblclick (e) ->
            SS.client.itemtip.hide()
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
            ui.helper.addClass "qual-background-#{q} ztop"

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


exports.getSchema = getSchema = (ns, cb) ->
    if ns.schema?
        cb ns.schema
    else
        $.getJSON '/schema', (s) ->
            SS.client.util.makeSchema ns, s
            cb ns.schema

getProfile = (id64, cb) ->
    $.getJSON "/profile/#{id64}", cb


getBackpack = (id64, ns, cb) ->
    if ns.backpack?
        cb ns.backpack
    else
        $.getJSON "/items/#{id64}", (b) ->
            SS.client.util.makeBackpack ns, b
            cb ns.backpack


initJQ = ($) ->
    $.fn.resetQualityClasses = (v) ->
        this.each ->
            for q in [0..20]
                $(this).removeClass("qual-border-#{q} qual-hover-#{q} qual-text-#{q}")
            $(this).addClass(v)


initEvents = (ns) ->
    $('body').bind 'trade-changed', tradeChanged
    $('div.item:not(:empty)').live 'mouseover', {namespace:ns}, SS.client.itemtip.show
    $('div.item:not(:empty)').live 'mouseout', {namespace:ns}, SS.client.itemtip.hide

    $('#user a').click ->
        self = $(this)
        target = $ self.attr('data-target')
        if not target.attr 'data-load'
            target.attr('data-load', true).trigger 'lazy-load'
        target.slideToggle ->
            v = target.is ':visible'
            s = if v then 'Show' else 'Hide'
            r = if v then 'Hide' else 'Show'
            self.text( self.text().replace s, r )
        false


    $('#channels .button-bar a').click ->
        link = $ this
        cname = link.attr('data-channel-name')
        active = link.hasClass('channel-on')
        link.toggleClass('channel-on').toggleClass('channel-off')
        (if active then leaveChannel else joinChannel)(cname)

    SS.events.on 'sys-chan-msg', (msg) ->
        console.log 'System Message:', msg, arguments
        $("#channels .chshell.cname-#{msg.cname} .chtalk").append "<i>#{msg.msg}</i><br>"


leaveChannel = (name) ->
    area = $ "#channels .chscroll .chshell.cname-#{name}"
    area.slideUp -> area.detach()
    SS.server.channels.leave name


joinChannel = (name) ->
    target = $ '#channels .chscroll'
    target.append $('#channel-proto').tmpl {name:name, title:name}
    newarea = $ "#channels .chscroll .chshell:last"
    newarea.addClass("cname-#{name}").slideDown()
    SS.server.channels.join name

