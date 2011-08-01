##
# client app
#


## this is the namespace for the schema, backpack, and various stuff.
## yes, it's a singleton, but we really don't use it that way.
exports.ns = {}


## this is the framework hook for initializing the app in the browser.
## the routine initializes the app, fetches the schema, and attempts
## an initial authorization.
exports.init = ->
    SS.server.app.init ->
        msg = $('#site .msg').text 'Loading schema...'
        ns = exports.ns
        initJQ jQuery
        initEvents ns
        getSchema ns, ->
            $('body').trigger 'schema-ready'
            msg.append('done.').delay(2000).slideUp()
            login (status) ->
                ns.auth = status.success
                (if status.success then initAuth else initAnon)(ns)


## initialize the app without a user.
initAnon = ->
    $('#login').show()


## initialize the app with a logged in user; show the welcome and
## setup the callbacks for handling the user buttons.
initAuth = (ns) ->
    getProfile (profile) ->
        $('#logout').prepend("Welcome, #{profile.personaname}.").show()
        $('#user').slideDown()

        $('#backpack').bind 'lazy-load', (e, cb) ->
            userbp = $ @
            bpshell = $ '.bpshell', userbp
            $('#user .bp .msg').text 'Loading...'
            getProfile (profile) ->
                getBackpack profile.steamid, ns, (backpack) ->
                    putBackpack ns, bpshell, ->
                        isoBackpack bpshell, () ->
                            configBackpack $('#backpack'), $('#trades')
                            initBackpackToolbar userbp, bpshell
                            $('#user .bp .msg').text ''
                            cb()
                            bpshell.isotope()

        $('#trades').bind 'lazy-load', (e, cb) ->
                trades = $ @
                ch = $ '.chooser', trades
                chshell = $ '.bpshell', ch
                $('#user .ch .msg').text 'Loading...'
                putChooser ns, chshell, ->
                    isoChooser chshell, ->
                        $('#user .ch .msg').text ''
                        getTrades (trades) ->
                            putTrades ns, trades, $('#trades .tradeshell'), ->
                                configBackpack $('#backpack'), $('#trades')
                                configChooser $('#trades .chooser'), $('#trades')
                                cb()
                                later = ->
                                    $('#trades .tradeshell .haves, #trades .tradeshell .wants').isotope()
                                    ## this looks nice, but the similar call
                                    ## against the backpack items does not!
                                    $('.chooserw', chshell).isotope()
                                setTimeout later, 500


## create groups of choosable items at the given target.
putChooser = (ns, target, cb) ->
    grp = ns.schema.ext.groups
    m = getItemMake()

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

    put (clone(x, 6) for x in grp.offers), add('Offers')
    put (clone(x, 6) for x in grp.commodities), add('Commodities')
    put (clone(x, 6) for x in grp.promos), add('Promos')
    put (clone(x, 3) for x in grp.vintage_hats), add('Vintage Hats')
    put (clone(x, 1) for x in grp.genuine_hats), add('Genuine Hats')
    put (clone(x, 3) for x in grp.vintage_weapons), add('Vintage Weapons')
    put (clone(x, 1) for x in grp.genuine_weapons), add('Genuine Weapons')
    cb()


## create items from a backpack at the given target.
putBackpack = (ns, target, cb) ->
    m = getItemMake()
    ts = ns.backpack_items
    mk = (s) -> m ns, ts[s], target, 'backpack'
    mk slot for slot in [1..ns.backpack.result.num_backpack_slots]
    cb()


isoBackpack = (target, cb) ->
    mn = Number.MIN_VALUE
    cmp = (i, attr, which='item-defn', missing=Number.MAX_VALUE) ->
        d = i.children('.item:first').data(which)
        if d
            d[attr]
        else
            missing
    target.isotope
        itemSelector: '.itemw'
        layoutMode: 'cellsByRow'
        animationEngine: getAniEngine()
        animationOptions:
            duration: 750
        getSortData:
            quality:    (i) -> cmp i, 'quality'
            date:       (i) -> cmp i, 'id'
            date_desc:  (i) -> cmp i, 'id',             'item-defn',   mn
            level:      (i) -> cmp i, 'level'
            level_desc: (i) -> cmp i, 'level',          'item-defn',   mn
            name:       (i) -> cmp i, 'item_name',      'schema-defn', 'ZZZ   '
            name_desc:  (i) -> cmp i, 'item_name',      'schema-defn', '   AAA'
            type:       (i) -> cmp i, 'item_type_name', 'schema-defn'
    cb()



isoChooser = (target, cb) ->
    for grp in $('.chooserw', target)
        $(grp).isotope
            itemSelector: '.itemw'
            layoutMode: 'fitRows'
            animationEngine: getAniEngine()
            animationOptions:
                duration: 750
    cb()


initBackpackToolbar = (container, target) ->
    $('.bptools', container).fadeIn()

    $('.bpfilters', container).change ->
        sel = $(':selected', @).attr 'data-filter'
        if sel and sel.length
            target.isotope filter:sel
        false

    $('.bpsorts', container).change ->
        sel = $(':selected', @).attr 'data-sort'
        ord = $(':selected', @).attr 'data-desc'
        target.isotope sortBy:sel, sortAscending:not ord
        false


putTrades = (ns, trades, target, cb) ->
    initTradeEvents ns, target

    if trades and trades.success
        m = getItemMake()
        for tid, trd of trades.trades
            trd = JSON.parse(trd)
            target.append $('#trade-proto').tmpl(tid:"##{tid}").data('trade-id', tid)
            last = $('.trade:last', target)
            if trd.text
                $('.trade-show-notes', last).text trd.text
                $('.trade-edit-notes textarea', last).val trd.text

            $('a.trade-submit', last).hide()
            empties = (null for i in [0..7])

            targ = $('.haves', last)
            $('.itemw', targ).detach()
            for have in trd.have.concat(empties)[0..7]
                m ns, have, targ, 'have backpack'

            targ = $('.wants', last)
            $('.itemw', targ).detach()
            for want in trd.want.concat(empties)[0..7]
                m ns, want, targ, 'want chooser'

            $('.haves, .wants', last).isotope
                itemSelector: '.itemw'
                layoutMode: 'fitRows'
                animationEngine: getAniEngine()

    target.append makeEmptyTrade()
    cb()


makeEmptyTrade = () ->
    trade = $('#trade-proto').tmpl({prefix:'NEW'})
    $('a.trade-submit, a.trade-delete', trade).hide()
    $('.haves, .wants', trade).isotope
        itemSelector: '.itemw'
        layoutMode: 'fitRows'
        animationEngine: getAniEngine()
    trade


configChooser = (source, target) ->
    sources = -> $('div.item:not(:empty):not(.untradable)', source)
    targets = -> $('div.item.want:empty', target)
    existing = -> $('div.item.want:not(:empty)', target)

    copy = (a, b) ->
        c = a.clone(true, true).unbind()
        t = b.parents '.trade'
        id = a.data('item-defn').id
        r = b.clone(false, false)
        b.replaceWith c
        hideItemTip()
        $('body').trigger 'trade-changed', t
        c.dblclick (e) ->
            hideItemTip()
            c.replaceWith r
            r.droppable dropOpts
            $('body').trigger 'trade-changed', t

    removeFromTrade = (e) ->
        hideItemTip()
        s = $ e.currentTarget
        s.replaceWith SS.client.item.empty('want chooser')
        s.droppable dropOpts
        $('body').trigger 'trade-changed', s.parents('.trade')

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
        appendTo: 'body'
        zIndex: 9002
        start: (e, ui) ->
            q = ui.helper.prevObject.data('item-defn').quality
            ui.helper.addClass "qual-background-#{q} ztop"

    dropOpts =
        accept: 'div.item.chooser'
        hoverClass: 'outline'
        drop: (e, ui) ->
            s = ui.helper.prevObject
            copy s, $(@)

    sources().unbind('dblclick').dblclick copyToTrade
    sources().draggable dragOpts
    existing().unbind('dblclick').dblclick removeFromTrade
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
        hideItemTip()
        $('body').trigger 'trade-changed', t
        c.dblclick (e) ->
            hideItemTip()
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
        appendTo: 'body'
        cursor: 'move'
        helper: 'clone'
        revert: 'invalid'
        zIndex: 9002
        start: (e, ui) ->
            q = ui.helper.prevObject.data('item-defn').quality
            ui.helper.addClass "qual-background-#{q} ztop"

    dropOpts =
        accept: 'div.item.backpack'
        hoverClass: 'outline'
        drop: (e, ui) ->
            s = ui.helper.prevObject
            t = $(@).parents('.trade')
            ids = t.data('ids') or []
            i = s.data('item-defn').id
            if not (i in ids)
                ids.push i
                t.data 'ids', ids
                copy s, $(@)

    sources().unbind('dblclick').dblclick copyToTrade
    sources().draggable dragOpts
    targets().droppable dropOpts


tradeChanged = (e, tc) ->
    have = $ 'div.item.backpack:not(:empty)', tc
    if have.length
        $('a.trade-submit', tc).slideDown()
    else
        $('a.trade-submit', tc).slideUp()
    want = $ 'div.item.chooser:not(:empty)', tc
    if want.length or have.length
        $('a.trade-delete', tc).slideDown()
    else
        $('a.trade-delete', tc).slideUp()


getSchema = (ns, cb) ->
    if ns.schema?
        cb ns.schema
    else
        $.getJSON '/schema', (s) ->
            cb makeSchema(ns, s)


getProfile = (id64, cb) ->
    $.getJSON "/profile/#{id64}", cb


getBackpack = (id64, ns, cb) ->
    if ns.backpack?
        cb ns.backpack
    else
        $.getJSON "/items/#{id64}", (b) ->
            cb makeBackpack(ns, b)


initJQ = ($) ->
    $.fn.resetQualityClasses = (v) ->
        @.each ->
            for q in [0..20]
                $(@).removeClass("qual-border-#{q} qual-hover-#{q} qual-text-#{q}")
            $(@).addClass(v)

initTradeEvents = (ns, target) ->
    parentTrade = (ev) ->
        $(ev.currentTarget).parents('div.trade')

    $('a.trade-delete', target).live 'click', (e) ->
        p = parentTrade(e)
        tid = p.data('trade-id')
        deleteTrade tid, (status) ->
            p.children('div').slideUp()
            $('h1:first .main', p).text('')
            $('h1:first .status', p).text('Deleted!').fadeIn().delay(2000).fadeOut 'fast', () ->
                p.replaceWith makeEmptyTrade()
                configBackpack $('#backpack'), $('#trades')
                configChooser $('#chooser'), $('#trades')
                $('#trades .tradeshell .haves, #trades .tradeshell .wants').isotope()
        false

    $('a.trade-submit', target).live 'click', (e) ->
        p = parentTrade(e)
        tid = p.data('trade-id')
        have = ($(i).data('item-defn') for i in $('div.backpack', p))
        want = ($(i).data('item-defn') for i in $('div.chooser', p))
        text = $('.trade-edit-notes textarea', p).val()
        if have and have.length
            publishTrade have:have, want:want, tid:tid, text:text, (status) ->
                p.data('trade-id', status.tid) if status.success
                $('h1:first .main', p).text("Trade ##{status.tid}")
                $('h1:first .status', p).text(if tid then 'Updated!' else 'Submitted!').delay(5000).fadeOut()
                $('a.trade-submit', p).slideUp()
        false

    $('a.trade-notes', target).live 'click', (e) ->
        p = parentTrade(e)
        if $('.trade-edit-notes', p).is(':visible')
            ## done editing
            txt = $('.trade-edit-notes textarea', p).val()
            $('.trade-show-notes', p).text(txt)
        else
            txt = $('.trade-show-notes', p).text()
            $('.trade-edit-notes textarea', p).val(txt)
        $('.trade-edit-notes, .trade-show-notes', p).slideToggle()
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


initEvents = (ns) ->
    $('body').bind 'trade-changed', tradeChanged
    $('div.item:not(:empty)').live 'mouseover', {namespace:ns}, showItemTip
    $('div.item:not(:empty)').live 'mouseout', {namespace:ns}, hideItemTip

    $('#user a').click ->
        self = $ @
        target = $ self.attr('data-target')

        changeText = ->
            v = (self.text().indexOf('Show') > -1)
            s = if v then 'Show' else 'Hide'
            r = if v then 'Hide' else 'Show'
            self.text self.text().replace(s, r)

        if not target.attr 'data-load'
            target.attr('data-load', true).trigger 'lazy-load', () ->
                target.slideDown()
                changeText()
        else
            target.slideToggle()
            changeText()
        false


    $('#channels .button-bar a').click ->
        link = $ @
        name = link.attr('data-channel-name')
        active = link.hasClass('on')
        link.toggleClass('on').toggleClass('off')
        (if active then leaveChannel else joinChannel)(name, link.parent())
        false

    $('#channels .chshell .chsay input[type=text]').live 'keydown', (e) ->
        if e.keyCode == 13
            inp = $(e.currentTarget)
            csh = inp.parents('.chshell')
            name = csh.data('cname')
            text = inp.attr('value')
            if text
                sayChannel {name:name, text:text}, () ->
                    inp.attr 'value', ''
                e.preventDefault()

    SS.events.on 'sys-msg', onTalk makeSysMsg
    SS.events.on 'usr-msg', onTalk makeUserMsg
    SS.events.on 'trd-msg', onTalk makeTradeMsg


onTalk = (fmt) ->
    (msg) ->
        console.log 'onTalk:', msg
        talk = talkArea msg.name
        if talk and talk[0]
            val = fmt(msg)
            if val
                talk.append val
                talk[0].scrollTop = talk[0].scrollHeight


talkArea = (name) ->
    $ "#channels .chshell.cname-#{name} .chtalk"


leaveChannel = (name, context) ->
    area = $(".chshell.cname-#{name}", context)
    area.slideUp -> area.detach()
    SS.server.channels.leave name:name


joinChannel = (name, context) ->
    context.append $('#channel-proto').tmpl {name:name, title:name}
    newarea = $ '.chshell', context
    newarea.addClass("cname-#{name}").data('cname', name).slideDown()
    SS.server.channels.join name:name
    SS.server.channels.list {name:name}, (names) ->
        for n in names
            $('.chshell .chusers', context).append "IMG: #{n}<br>"


makeSysMsg = (m) ->
    t = new Date().toLocaleTimeString()
    "<span class='timestamp'>#{t}</span> <span class='sys'>system: </span>#{m.who} has #{m.what} the channel.<br>"


makeUserMsg = (m) ->
    t = new Date().toLocaleTimeString()
    x = $("<span>#{m.text}</span>").text()
    "<span class='timestamp'>#{t}</span> <span class='user'>#{m.who}: </span>#{x}<br>"


makeTradeMsg = (m) ->
    console.log "make trade msg:", m
    if m.action == 'add'
        console.log "add trade:", m
    else if m.action == 'del'
        console.log "del trade:", m
    else if m.action == 'upd'
        console.log "upd trade:", m
    t = new Date().toLocaleTimeString()
    "<span class='timestamp'>#{t}</span> <span class='trade'>trade: </span>?<br>"



___makeTradeMsg = (m) ->
    p = $('#trade-message').tmpl m
    p = putTradeUser p, m
    putTradeItem p, m


putTradeUser = (proto, msg) ->
    proto


putTradeItems = (proto, msg) ->
    proto


remTradeMsg = (m) ->
    null


getAniEngine = ->
    if $.browser.mozilla then 'jquery' else 'best-available'


## local wrappers around the server and other client apis.

login = (cb) ->
    SS.server.app.login document.cookie, cb

sayChannel = (p, cb) ->
    SS.server.channels.say p, cb

getProfile = (cb) ->
    SS.server.app.userProfile cb

getTrades = (cb) ->
    SS.server.trades.userTrades {}, cb

getItemMake = ->
    SS.client.item.make

publishTrade = (p, cb) ->
    SS.server.trades.publish p, cb

hideItemTip = (e) ->
    SS.client.itemtip.hide e

showItemTip = (e) ->
    SS.client.itemtip.show e

makeSchema = (ns, s) ->
    SS.client.util.makeSchema ns, s
    ns.schema

makeBackpack = (ns, b) ->
    SS.client.util.makeBackpack ns, b
    ns.backpack

deleteTrade = (tid, cb) ->
    if tid
        SS.server.trades.publish tid:tid, cb
    else
        cb()

