##
# app.coffee, our client-side app
#


# this is the namespace for the schema, backpack, and various stuff.
# yes, it's a singleton, but we really don't use it that way.
exports.ns = {}


# this is the framework hook for initializing the app in the browser.
# the routine initializes the app, fetches the schema, and attempts
# an initial authorization.
exports.init = ->
    SS.server.app.init ->
        msg = $('#site .msg').text 'Loading schema...'
        initJQ jQuery
        getSchema exports.ns, ->
            msg.append('done.').delay(2000).slideUp()
            initEvents exports.ns
            login (status) ->
                exports.ns.auth = status.success
                (if status.success then initAuth else initAnon)(exports.ns)


# initialize the app without a user.
initAnon = ->
    $('#login').show()


# initialize the app with a logged in user; show the welcome and
# setup the callbacks for handling the user buttons.
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
                                    # this looks nice, but the similar call
                                    # against the backpack items does not!
                                    $('.chooserw', chshell).isotope()
                                setTimeout later, 500


# initialize jquery with our little plugins.
initJQ = ($) ->
    $.fn.resetQualityClasses = (v) ->
        @.each ->
            for q in [0..20]
                $(@).removeClass("qual-border-#{q} qual-hover-#{q} qual-text-#{q}")
            $(@).addClass(v)


# initialize some fixed, well-known selectors with event handers.
initEvents = (ns) ->
    $('body').bind 'trade-changed', tradeChanged
    $('div.item:not(:empty)').live 'mouseover', namespace:ns, showItemTip
    $('div.item:not(:empty)').live 'mouseout', namespace:ns, hideItemTip

    $('#user a').click ->
        self = $ @
        targ = $ self.attr('data-target')
        togl = ->
            targ.slideToggle()
            v = (self.text().indexOf('Show') > -1)
            s = if v then 'Show' else 'Hide'
            r = if v then 'Hide' else 'Show'
            self.text self.text().replace(s, r)
        if not targ.attr 'data-load'
            targ.attr('data-load', '1').trigger 'lazy-load', togl
        else
            togl()
        false


    $('#channels .button-bar a').click ->
        link = $ @
        name = link.attr 'data-channel-name'
        active = link.hasClass 'on'
        link.toggleClass('on').toggleClass 'off'
        (if active then leaveChannel else joinChannel)(name, link.parent())
        false

    $('#channels .chshell .chsay input[type=text]').live 'keydown', (e) ->
        if e.keyCode == 13
            inp = $ e.currentTarget
            csh = inp.parents '.chshell'
            chn = csh.data 'cname'
            txt = inp.attr 'value'
            if txt
                sayChannel channel:chn, text:txt, ->
                    inp.attr 'value', ''
                e.preventDefault()

    $('#trades .chooser .chooser-group a').live 'click', ->
        link = $ @
        #console.log "chooser click", link, link.parents('.chooser-group')
        key = link.parents('.chooser-group').attr 'data-key'
        console.log 'chooser click', key, link


    SS.events.on 'sys-msg', (m) ->
        getChannelArea(m.channel).trigger "channel-#{m.what}", m

    SS.events.on 'usr-msg', (m) ->
        getChannelArea(m.channel).trigger "channel-#{m.what}", m

    SS.events.on 'trd-msg', (m) ->
        getChannelArea(m.channel).trigger "trade-#{m.action}", m



# create items from a backpack at the given target.
putBackpack = (ns, target, cb) ->
    m = getItemMake()

    unp = (i) -> m ns, ns.backpack_items_unplaced[i], target, 'backpack'
    unp j for j in [0..ns.backpack_items_unplaced.length-1]

    put = (s) -> m ns, ns.backpack_items[s], target, 'backpack'
    put slot for slot in [1..ns.backpack.result.num_backpack_slots]

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


# configure the backpack items at the target for isotope layout,
# filtering, and sorting.
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


# create groups of choosable items at the given target.
putChooser = (ns, target, cb) ->
    grp = ns.schema.ext.groups
    m = getItemMake()

    clone = (id, q) ->
        x = JSON.parse(JSON.stringify(ns.schema_items[id]))
        x.quality = q
        x

    add = (title) ->
        ch = $('#chooser-proto').tmpl title:title
        target.append ch
        $('span', ch).hide()
        $('.chooserw', ch)

    put = (items, t) ->
        m ns, item, t, 'chooser' for item in items

    put (clone(x, 6) for x in grp.offers), add('Offers')
    put (clone(x, 6) for x in grp.commodities), add('Commodities')
    put (clone(x, 6) for x in grp.promos), add('Promos')


    addb = (key, title) ->
        ch = $('#chooser-proto').tmpl title:title
        target.append ch
        $('h3', ch).hide()
        ch.attr('data-key', key)
        $('.chooserw', ch)

    putb = () ->
        null

    putb addb('hats', 'All Hats')
    putb addb('vintage_hats', 'Vintage Hats')
    putb addb('genuine_hats', 'Genuine Hats')
    putb addb('weapons', 'All Weapons')
    putb addb('vintage_weapons', 'Vintage Weapons')
    putb addb('genuine_weapons', 'Genuine Weapons')

    cb()


# configure the chooser groups at the target for isotope layout.
isoChooser = (target, cb) ->
    for grp in $('.chooserw', target)
        $(grp).isotope
            itemSelector: '.itemw'
            layoutMode: 'fitRows'
            animationEngine: getAniEngine()
            animationOptions:
                duration: 750
    cb()


makeEmptyTrade = () ->
    trade = $('#trade-proto').tmpl({prefix:'NEW'})
    $('a.trade-submit, a.trade-delete', trade).hide()
    $('.haves, .wants', trade).isotope
        itemSelector: '.itemw'
        layoutMode: 'fitRows'
        animationEngine: getAniEngine()
    trade


putTrades = (ns, trades, target, cb) ->
    initTradeEvents ns, target

    if trades and trades.success
        m = getItemMake()
        for tid, trd of trades.trades
            trd = JSON.parse trd
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
        # else alert or message or something

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
        # else alert or message or something

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
    existing = $(tc).data 'trade-id'
    have = $ 'div.item.backpack:not(:empty)', tc
    if have.length
        $('a.trade-submit', tc).text(if existing then 'Update' else 'Submit').slideDown()
    else
        $('a.trade-submit', tc).slideUp()
    want = $ 'div.item.chooser:not(:empty)', tc
    if want.length or have.length
        $('a.trade-delete', tc).text(if existing then 'Close' else 'Clear').slideDown()
    else
        $('a.trade-delete', tc).slideUp()




initTradeEvents = (ns, target) ->
    parentTrade = (ev) ->
        $(ev.currentTarget).parents 'div.trade'

    $('a.trade-delete', target).live 'click', (e) ->
        p = parentTrade e
        tid = p.data('trade-id')
        deleteTrade tid, (status) ->
            p.children('div').slideUp()
            $('h1:first .main', p).text ''
            $('h1:first .status', p).text(if tid then 'Closed!' else 'Cleared!').fadeIn().delay(2000).fadeOut 'fast', () ->
                p.replaceWith makeEmptyTrade()
                configBackpack $('#backpack'), $('#trades')
                configChooser $('#chooser'), $('#trades')
                $('#trades .tradeshell .haves, #trades .tradeshell .wants').isotope()
        false

    $('a.trade-submit', target).live 'click', (e) ->
        p = parentTrade e
        tid = p.data 'trade-id'
        have = ($(i).data('item-defn') for i in $('div.backpack', p))
        want = ($(i).data('item-defn') for i in $('div.chooser', p))
        text = $('.trade-edit-notes textarea', p).val()
        if have and have.length
            publishTrade have:have, want:want, tid:tid, text:text, (status) ->
                p.data('trade-id', status.tid) if status.success
                $('h1:first .main', p).text("Trade ##{status.tid}")
                $('h1:first .status', p).text(if tid then 'Updated!' else 'Submitted!').delay(5000).fadeOut()
                $('a.trade-submit', p).slideUp()
                $('a.trade-delete', p).text('Close')
        false

    $('a.trade-notes', target).live 'click', (e) ->
        p = parentTrade(e)
        if $('.trade-edit-notes', p).is(':visible')
            # done editing
            txt = $('.trade-edit-notes textarea', p).val()
            $('.trade-show-notes', p).text(txt)
        else
            txt = $('.trade-show-notes', p).text()
            $('.trade-edit-notes textarea', p).val(txt)
        $('.trade-edit-notes, .trade-show-notes', p).slideToggle()
        false

    $('div.item.chooser', target).live 'click', (e) ->
        item = $ e.currentTarget
        id = item.data('item-defn').defindex
        qualseq = ns.schema.ext.quals[id]
        qualc = item.data 'qual'
        if qualc?
            i = qualseq.indexOf qualc
        else
            i = 1
        j = qualseq[(i+1) % qualseq.length]
        item.data 'qual', j
        item.resetQualityClasses "qual-border-#{j} qual-hover-#{j}"
        item.data('item-defn').quality = j
        item.trigger('mouseout').trigger 'mouseover'




leaveChannel = (channel, context) ->
    area = $(".chshell.cname-#{channel}", context)
    area.slideUp -> area.detach()
    SS.server.channels.leave channel:channel


joinChannel = (channel, context) ->
    chan = $('#channel-proto').tmpl name:channel, title:channel
    context.append chan

    chan.addClass "cname-#{channel}"
    chan.data 'cname', channel
    chan.slideDown()

    talk = $ '.chtalk', chan

    addTalk = (v) ->
        if v
            talk.append v
            talk[0].scrollTop = talk[0].scrollHeight

    addStatus = (player) ->
        readProfileStatus player, (profile) ->
            p = $('#channel-player').tmpl()
            $('.chshell .chusers', context).append p
            $('a', p).attr 'href', "http://steamcommunity.com/profiles/#{player}"
            p.addClass("id64-#{player}")

            name = $('.name', p)
            name.text profile.personaname
            name.addClass "#{profile.state}"
            name.fadeIn()

            img = $('img.avatar', p)
            img.addClass "#{profile.state}"
            img.attr 'src', profile.avatar
            img.fadeIn()

    delStatus = (player) ->
        $(".id64-#{player}:nth(0)").fadeOut().detach()

    addTrade = (trade) ->
        m = getItemMake()
        ns = exports.ns
        target = $('.chtrade', chan)
        tid = trade.tid
        ## need different prototype, no buttons, appropriate notes.
        target.append $('#trade-proto').tmpl(tid:"##{tid}").data('trade-id', tid)
        last = $('.trade:last', target)
        last.addClass "trade-#{tid}"
        if trade.text
            $('.trade-show-notes', last).text trade.text
            $('.trade-edit-notes textarea', last).val trade.text

        $('a.trade-submit', last).hide()
        empties = (null for i in [0..7])

        targ = $('.haves', last)
        $('.itemw', targ).detach()
        for have in trade.have.concat(empties)[0..7]
            m ns, have, targ, 'have backpack'

        targ = $('.wants', last)
        $('.itemw', targ).detach()
        for want in trade.want.concat(empties)[0..7]
            m ns, want, targ, 'want chooser'

        $('.haves, .wants', last).isotope
            itemSelector: '.itemw'
            layoutMode: 'fitRows'
            animationEngine: getAniEngine()

    delTrade = (tid) ->
        $(".trade-#{tid}", chan).fadeOut().delay(2000).detach()

    chan.bind 'channel-joined', (e, m) ->
        addTalk makeSysMsg(m)
        addStatus m.id64

    chan.bind 'channel-left', (e, m) ->
        addTalk makeSysMsg(m)
        delStatus m.id64

    chan.bind 'channel-said', (e, m) ->
        addTalk makeUserMsg(m)

    chan.bind 'trade-add', (e, m) ->
        #console.log 'trade added:', m, ' this channel is', channel
        addTrade m

    chan.bind 'trade-del', (e, m) ->
        #console.log 'trade deleted:', m, ' this channel is', channel
        delTrade m.tid

    chan.bind 'trade-upd', (e, m) ->
        console.log 'trade updated:', m, ' this channel is', channel

    SS.server.channels.listUsers channel:channel, (players) ->
        for player in players
            do (player) ->
                addStatus player
        # do this after adding the current players so that we don't
        # also add the current player (that's handled by the system
        # message event when the join is done).
        SS.server.channels.join channel:channel

    getAndShowTrades = () ->
        SS.server.channels.listTrades channel:channel, (trades) ->
            for trade in (trades or [])
                do (trade) ->
                    addTrade JSON.parse(trade)

    which = if exports.ns.auth then '.chsay' else '.chanon'
    $(which, chan).fadeIn()
    setTimeout getAndShowTrades, 1000


getChannelArea = (name) ->
    $ "#channels .chshell.cname-#{name}"


getTalkArea = (name) ->
    $ '.chtalk', getChannelArea(name)


onTalk = (fmt) ->
    (msg) ->
        console.log 'onTalk:', msg
        talk = getTalkArea msg.channel
        if talk and talk[0]
            val = fmt(msg)
            if val
                talk.append val
                talk[0].scrollTop = talk[0].scrollHeight


makeSysMsg = (m) ->
    t = new Date().toLocaleTimeString()
    "<span class='timestamp'>#{t}</span> <span class='sys'>system: #{m.who} has #{m.what} the channel.</span><br>"


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
    "<span class='timestamp'>#{t}</span> <span class='trade #{m.action}'>trade id: #{m.tid}</span><br>"


getAniEngine = ->
    if $.browser.mozilla then 'jquery' else 'best-available'


# local wrappers around the server and other client apis.

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

getSchema = (ns, cb) ->
    if ns.schema?
        cb ns.schema
    else
        $.getJSON '/schema', (s) ->
            cb makeSchema(ns, s)


readProfileStatus = (id64, cb) ->
    SS.server.app.readProfile id64:id64, (p) ->
        SS.server.app.readStatus id64:id64, (s) ->
            p.state = if s and s.state then s.state else null
            p.stateMessage = s.stateMessage
            cb p


getBackpack = (id64, ns, cb) ->
    if ns.backpack?
        cb ns.backpack
    else
        $.getJSON "/items/#{id64}", (b) ->
            cb makeBackpack(ns, b)


#getProfile = (id64, cb) ->
#    $.getJSON "/profile/#{id64}", cb
