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
    SS.server.app.init (details) ->
        initExt jQuery
        msg = $('#site-msg').text 'Loading schema...'
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
        #$('#user').slideDown()

        $('#backpack').bind 'lazy-load', (e, cb) ->
            bm = $('#backpack-msg').text 'Loading...'
            bp = $ @
            sh = $ '.shell', bp
            getBackpack profile.steamid, ns, (backpack) ->
                putBackpack ns, sh, ->
                    bm.text ''
                    isoBackpack sh, ->
                        initBackpackTools bp, sh
                        cb()
                        sh.isotope()

        $('#trades').bind 'lazy-load', (e, cb) ->
            tm = $('#trade-msg').text 'Loading...'
            ch = $ '.chooser', @
            tg = $ '#trades .trades.shell'
            nv = $ '#trades .navigator'
            initTradeEvents ns, tg
            initTradeNav ns, nv, tg
            putChooser ns, ch, ->
                tm.text ''
                getTrades (trades) ->
                    putTrades ns, trades, tg, ->
                        $('.trade:first', tg).show()
                        cb()


# initialize jquery with our little plugins and add our little object
# extensions.
initExt = ($) ->
    $.fn.resetQualityClasses = (v) ->
        @.each ->
            for q of getNS().schema_qualities
                $(@).removeClass "qual-border-#{q} qual-hover-#{q} qual-text-#{q}"
            $(@).addClass v

    $.fn.addTalk = (v) ->
        @.each ->
            if v
                $(@).append v
                @.scrollTop = @.scrollHeight

    $.fn.tradableItems = ->
        $ 'div.item:not(:empty):not(.untradable)', @

    String::slug = ->
        this.replace(/\ /g, '_').toLowerCase()


# initialize some fixed, well-known selectors with event handers.
initEvents = (ns) ->
    $('#main-chat').click ->
        if not $('#channels').is ':visible'
            $('#channels, #user').toggle()
        false

    $('#main-trade').click ->
        if not $('#user').is ':visible'
            $('#channels, #user').toggle()
        false


    # bind the trade changed event to the singular handler
    $(document).bind 'trade-changed', adjustTradeUI

    # bind the display of backpack items to the double-click-copy and
    # drag-copy actions
    $(document).bind 'new-backpack-items', target:'#trades', (event, source) ->
        target = $ event.data.target
        targets = $('div.item.have:empty', target).droppable BCA.dropOpts()
        $(source)
            .tradableItems()
            .bind('dblclick', {target:target, selector:'div.item.have:empty:first'}, BCA.copyToTrade)
            .draggable(BCA.dragOpts())

    # bind the display of trade slots to the double-click-copy and
    # drag-copy actions (from backpack to trade)
    $(document).bind 'new-trade-slots', source:'#backpack', (event, target) ->
        targets = $ 'div.item.have:empty', target
        targets.droppable BCA.dropOpts()
        $(event.data.source)
            .tradableItems()
            .bind('dblclick', {target:target, selector:'div.item.have:empty:first'}, BCA.copyToTrade)
            .draggable(BCA.dragOpts())

    # bind the display of chooser items to the double-click-copy and
    # drag-copy actions (from chooser to trade)
    $(document).bind 'new-chooser-items', target:'#trades', (event, source) ->
        doLater 100, ->
            target = $ event.data.target
            targets = $('div.item.want:empty', target).droppable CCA.dropOpts()
            $(source)
                .tradableItems()
                .bind('dblclick', {target:target, selector:'div.item.want:empty:first'}, CCA.copyToTrade)
                .draggable(CCA.dragOpts())

    # live bind the mouse hover events to the show/hide item tip
    # handlers
    $('div.item:not(:empty)')
        .live('mouseover', namespace:ns, showItemTip)
        .live('mouseout',  namespace:ns, hideItemTip)

    $('div.item')
        .live('mousedown', -> false)

    # bind the logout button to this local helper
    $('#logout a').click ->
        document.cookie = 'session_id='
        document.cookie = 'id64='
        window.location.reload()

    # bind the backpack/trade toggle click events
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

    # bind the channel join/leave toggle click events
    $('#channels .button-bar a').click ->
        link = $ @
        name = link.attr 'data-channel-name'
        active = link.hasClass 'on'
        link.toggleClass('on').toggleClass 'off'
        (if active then leaveChannel else joinChannel)(name, link.parent())
        false

    # live bind the chat text entry fields to the chat channel publish
    # handler
    $('#channels .shell .say input[type=text]').live 'keydown', (e) ->
        if e.keyCode == 13
            inp = $ e.currentTarget
            txt = inp.attr 'value'
            if txt
                csh = inp.parents '.shell'
                chn = csh.data 'cname'
                sayChannel channel:chn, text:txt, ->
                    inp.attr 'value', ''
                e.preventDefault()

    # bind server message events to handlers that re-emit the events
    # to handlers bound to local dom elements.
    SS.events.on 'sys-msg', (m) ->
        getChannelArea(m.channel).trigger "channel-#{m.what}", m
    SS.events.on 'usr-msg', (m) ->
        getChannelArea(m.channel).trigger "channel-#{m.what}", m
    SS.events.on 'trd-msg', (m) ->
        getChannelArea(m.channel).trigger "trade-#{m.action}", m


    $('#test').click (e) ->
        console.log "EVENT 1"
        return false

    $('#test').click ->
        console.log "EVENT 2!"

# create items from a backpack at the given target.
putBackpack = (ns, target, cb) ->
    unplaced = ns.backpack_items_unplaced
    putUnplaced = (i) -> putItem ns, unplaced[i], target, 'backpack'
    if unplaced.length
        putUnplaced j for j in [0..unplaced.length-1]
    inventory = ns.backpack_items
    putInventory = (s) -> putItem ns, inventory[s], target, 'backpack'
    putInventory j for j in [1..ns.backpack.result.num_backpack_slots]
    trigger.newBackpackItems target
    cb()


# configure a select.sort element for calling isotope to sort the
# items within the target.
initSortTool = (c, t) ->
    $('select.sort', c).change ->
        sel = $(':selected', @).attr 'data-sort'
        ord = $(':selected', @).attr 'data-desc'
        t.isotope sortBy:sel, sortAscending:not ord
        false


# configure the filter and sort select elements within the given
# container for backpack interaction.
initBackpackTools = (container, target) ->
    $('.backpack-tools', container).fadeIn()
    $('select.filter', container).change ->
        sel = $(':selected', @).attr 'data-filter'
        if sel and sel.length
            target.isotope filter:sel
        false
    initSortTool container, target


# configure the filter and sort select elements within the given
# container for chooser interaction.
initChooserTools = (container, target) ->
    $('.backpack-tools', container).fadeIn()
    $('span.filter.title').text 'Show:'
    $('select.filter', container)
        .prepend('<option data-filter="" selected="selected"></option>')
    $('select.sort option:not([data-simple])', container).remove()
    initSortTool container, target


# configure the backpack items at the target for isotope layout,
# filtering, and sorting.
isoBackpack = (target, cb) ->
    mn = Number.MIN_VALUE
    cmp = (i, attr, which='item-defn', missing=Number.MAX_VALUE) ->
        d = i.children('.item:first').data(which)
        if d then d[attr] else missing
    target.isotope isoOpts
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
putChooser = (ns, panel, cb) ->
    shell = $ '.shell', panel
    offer = $ '.chooser-offer', panel
    initChooserTools panel, shell
    putItem ns, clone.unique(id), offer, 'chooser' for id, item of ns.schema.ext.offers
    offer.isotope isoOpts()
    shiso = -> shell.isotope isoOpts()
    items = makeChooserItems ns
    trigger.newChooserItems offer
    $('select.filter', panel).change ->
        sel = $(':selected', @).attr 'data-filter'
        if sel and sel.length
            doLater 100, ->
                shell.isotope 'destroy'
                $('.itemw', shell).detach()
                shiso()
                iz = items[sel]()
                if iz.length < 100
                    shell.isotope 'insert', item for item in iz
                else
                    shell.append item for item in iz
                    shell.isotope('reloadItems').isotope()
                trigger.newChooserItems shell
        false
    doLater 500, ->
        shiso()
        offer.isotope()
    cb()


# create and return a new, empty trade element from the prototype.
makeEmptyTrade = () ->
    trade = $('#trade-proto').tmpl prefix:'NEW'
    $('a.trade-submit, a.trade-delete', trade).hide()
    $('.haves, .wants', trade).isotope isoOpts()
    trade


# create and display an element for the trade at the target.
putTrade = (ns, tid, trade, target, hidden=false) ->
    trade = JSON.parse trade
    target.append $('#trade-proto').tmpl(tid:"##{tid}").attr('data-tid', tid)
    last = $ '.trade:last', target
    if trade.text
        $('pre.notes', last).text trade.text
        $('div.notes textarea', last).val trade.text

    $('a.trade-submit', last).hide()
    empties = (null for i in [0..7])

    targ = $ '.haves', last
    $('.itemw', targ).detach()
    for have in trade.have.concat(empties)[0..7]
        putItem ns, have, targ, 'have backpack'

    targ = $ '.wants', last
    $('.itemw', targ).detach()
    for want in trade.want.concat(empties)[0..7]
        putItem ns, want, targ, 'want chooser'
    $('.haves, .wants', last).isotope isoOpts()
    if hidden
        last.hide()

    trigger.tradeAdded tid
    trigger.newTradeSlots target
    #trigger.newChooserItems target
    #doLater 500, -> trigger.tradeChanged last


# create and display elements for the given trades at the target.
putTrades = (ns, trades, target, cb) ->
    some = ->
        try
            (x for x of trades.trades).length > 0
        catch e
            false
    if some()
        putTrade ns, tid, trd, target, true for tid, trd of trades.trades
    else
        target.append makeEmptyTrade()
        trigger.newTradeSlots target
        #trigger.newChooserItems target

    doLater 500, ->
        $('.haves', target).isotope()
        $('.wants', target).isotope()
    cb() if cb


# update the trade element based on changes to its content.
adjustTradeUI = (e, tc) ->
    existing = $(tc).attr 'data-tid'
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

    if $('.item.have:empty', tc).length == 0
       $('.haves', tc).isotope 'insert', makeItem(getNS(), null, 'have')
       trigger.newTradeSlots tc

    if $('.item.want:empty', tc).length == 0
       $('.wants', tc).isotope 'insert', makeItem(getNS(), null, 'want chooser')
       #trigger.newChooserItems tc


# live bind the trade manipulation buttons to handlers for submit,
# delete, update, etc.
initTradeEvents = (ns, target) ->
    $('a.trade-delete', target).live 'click', (e) ->
        p = parentTrade e
        tid = p.attr('data-tid')
        deleteTrade tid, (status) ->
            p.children('div').slideUp()
            $('h1:first .main', p).text ''
            $('h1:first .status', p).text(if tid then 'Closed!' else 'Cleared!')
                .fadeIn()
                .delay(1500)
                .fadeOut () ->
                    n = makeEmptyTrade()
                    p.replaceWith n
                    trigger.newTradeSlots n
                    #trigger.newChooserItems n
                    $('#trades .shell .haves, #trades .shell .wants').isotope()
                    if tid
                        trigger.tradeDeleted tid
        false

    $('a.trade-submit', target).live 'click', (e) ->
        p = parentTrade e
        tid = p.attr 'data-tid'
        have = ($(i).data('item-defn') for i in $('div.backpack', p))
        want = ($(i).data('item-defn') for i in $('div.chooser', p))
        text = $('div.notes textarea', p).val()
        if have and have.length
            publishTrade have:have, want:want, tid:tid, text:text, (status) ->
                if status.success
                    p.attr('data-tid', status.tid)
                    $('h1:first .main', p).text("Trade ##{status.tid}")
                    $('h1:first .status', p)
                        .text(if tid then 'Updated!' else 'Submitted!')
                        .delay(2500)
                        .fadeOut()
                    $('a.trade-submit', p).slideUp()
                    $('a.trade-delete', p).text('Close')
                    if not tid
                        trigger.tradeAdded status.tid
                # else show some error -- trade not submitted
        false

    $('a.trade-notes', target).live 'click', (e) ->
        p = parentTrade(e)
        if $('div.notes', p).is(':visible')
            # done editing
            txt = $('div.notes textarea', p).val()
            $('pre.notes', p).text(txt)
        else
            txt = $('pre.notes', p).text()
            $('div.notes textarea', p).val(txt)
        $('div.notes, pre.notes', p).slideToggle()
        false

    $('div.item.chooser', target).live 'click', (e) ->
        item = $ e.currentTarget
        defn = item.data 'item-defn'
        qval = item.data 'disp-qual'
        qseq = ns.schema.ext.quals[defn.defindex]
        i = qseq.indexOf (if qval? then qval else defn.quality)
        q = defn.quality = qseq[(i+1) % qseq.length]
        item
            .data('disp-qual', q)
            .resetQualityClasses("qual-border-#{q} qual-hover-#{q}")
            .trigger('mouseout')
            .trigger('mouseover')
        trigger.tradeChanged parentTrade(e)
        false


# initialize the trade navigator with bindings to handlers to show
# existing trades and a single new trade element.  also binds the
# document to the trade-added and trade-deleted events so the
# navigator can update its elements.
initTradeNav = (ns, nav, context) ->
    $('a.new', nav).click (e) ->
        par = $ '.trade:visible', context
        if par.attr('data-tid')
            $('.trade', context).slideUp ->
                existing = $(".trade:not([data-tid])", context)
                if existing.length
                    existing.first().slideDown()
                else
                    putTrades ns, null, context
        false

    $('a.show', nav).live 'click', (e) ->
        tid = $(e.currentTarget).attr 'data-tid'
        par = $ '.trade:visible', context
        if par.attr('data-tid') != tid
            par.slideUp ->
                trd = $ ".trade[data-tid=#{tid}]"
                trd.slideDown ->
                    $('.haves, .wants', trd).isotope isoOpts()
        false

    $(document).bind 'trade-added', (e, tid) ->
        nav.append "<a href='#' class='small-button show' data-tid='#{tid}'>#{tid}</a>"

    $(document).bind 'trade-deleted', (e, tid) ->
        $("a.show[data-tid=#{tid}]").fadeOut().detach()


leaveChannel = (channel, context) ->
    $(".shell.cname-#{channel}", context).slideUp(-> $(@).detach())
    SS.server.channels.leave channel:channel


joinChannel = (channel, context) ->
    chan = $('#channel-proto')
               .tmpl(name:channel, title:channel)
               .appendTo(context)
               .addClass("cname-#{channel}")
               .data('cname', channel)
               .slideDown()

    talk = $ '.talk', chan

    addStatus = (player) ->
        readProfileStatus player, (profile) ->
            p = $('#channel-player').tmpl().addClass("id64-#{player}")
            $('.shell .users', context).append p
            $('a', p).attr 'href', "http://steamcommunity.com/profiles/#{player}"

            name = $('.name', p)
                .text(profile.personaname)
                .addClass("#{profile.state}")
                .fadeIn()

            img = $('img.avatar', p)
                .addClass("#{profile.state}")
                .attr('src', profile.avatar)
                .fadeIn()

    delStatus = (player) ->
        $(".id64-#{player}:nth(0)").fadeOut().detach()

    addTrade = (trade) ->
        ns = getNS()
        target = $('.trades', chan)
        tid = trade.tid
        target.prepend $('#channel-trade').tmpl(tid:"##{tid}").attr('data-tid', tid)
        last = $('.trade:first', target)
        last.addClass "trade-#{tid}"
        if trade.text
            $('pre.notes', last).text trade.text[0..256]

        targ = $('.haves', last)
        putItem ns, have, targ, 'have backpack' for have in trade.have

        targ = $('.wants', last)
        putItem ns, want, targ, 'want chooser' for want in trade.want

        $('.haves, .wants', last).isotope isoOpts(layoutMode:'fitRows')
        last.slideDown ->
            doLater 500, -> $('.haves, .wants', last).isotope()

        readProfileStatus trade.uid, (s) ->
            $('h1 .who', last).text s.personaname


    delTrade = (tid) ->
        $(".trade-#{tid}", chan).fadeOut().delay(2000).detach()

    updTrade = (trade) ->
        delTrade trade.tid
        addTrade trade

    chan.bind 'channel-joined', (e, m) ->
        talk.addTalk makeSysMsg(m)
        addStatus m.id64

    chan.bind 'channel-left', (e, m) ->
        talk.addTalk makeSysMsg(m)
        delStatus m.id64

    chan.bind 'channel-said', (e, m) ->
        talk.addTalk makeUserMsg(m)

    chan.bind 'trade-add', (e, m) ->
        #console.log 'trade added:', m, ' this channel is', channel
        addTrade m

    chan.bind 'trade-del', (e, m) ->
        #console.log 'trade deleted:', m, ' this channel is', channel
        delTrade m.tid

    chan.bind 'trade-upd', (e, m) ->
        #console.log 'trade updated:', m, ' this channel is', channel
        updTrade m

    SS.server.channels.listUsers channel:channel, (players) ->
        for player in players
            do (player) ->
                addStatus player
        # do this after adding the current players so that we don't
        # also add the current player (that's handled by the system
        # message event when the join is done).
        SS.server.channels.join channel:channel

    doLater 1000, ->
        SS.server.channels.listTrades channel:channel, (trades) ->
            for trade in (trades or [])
                do (trade) ->
                    addTrade JSON.parse(trade)

    which = if getNS().auth then '.say' else '.anon'
    $(which, chan).fadeIn ->
        $('input', @).focus() #.width $(@).parent().width()


getChannelArea = (name) -> $ "#channels .shell.cname-#{name}"


getTalkArea = (name) -> $ '.talk', getChannelArea(name)


makeSysMsg = (m) ->
    t = new Date().toLocaleTimeString()
    "<span class='timestamp'>#{t}</span> <span class='sys'>#{m.who} has #{m.what} the channel.</span><br>"


makeUserMsg = (m) ->
    t = new Date().toLocaleTimeString()
    x = $("<span>#{m.text}</span>").text()
    "<span class='timestamp'>#{t}</span> <span class='user'>#{m.who}</span>#{x}<br>"


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


# local wrappers around the server and other client apis.

login = (cb) ->
    SS.server.app.login document.cookie, cb

sayChannel = (p, cb) ->
    SS.server.channels.say p, cb

getProfile = (cb) ->
    SS.server.app.id64 (res) ->
        if res.id64
            $.getJSON "/profile/#{res.id64}", cb

getTrades = (cb) ->
    SS.server.trades.userTrades {}, cb

getItemMake = ->
    SS.client.item.make

putItem = (ns, defn, target, type) ->
    SS.client.item.put ns, defn, target, type

makeItem = (ns, defn, type) ->
    SS.client.item.make ns, defn, type

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
    SS.client.util.readProfileStatus id64, cb

getBackpack = (id64, ns, cb) ->
    if ns.backpack?
        cb ns.backpack
    else
        $.getJSON "/items/#{id64}", (b) ->
            cb makeBackpack(ns, b)


# local utils

isoOpts = (o) ->
    getAniEngine = ->
        if $.browser.mozilla then 'jquery' else 'best-available'
    opts =
        itemSelector: '.itemw'
        layoutMode: 'masonry'
        animationEngine: getAniEngine()
        animationOptions:
            duration: 750
    opts[k] = v for k, v of o
    opts

clone = (o) -> JSON.parse JSON.stringify(o)

clone.defn = (id) -> clone getNS().schema_items[id]
clone.genuine = (id) -> clone.qual id, 1
clone.strange = (id) -> clone.qual id, 11
clone.unique = (id) -> clone.qual id, 6
clone.unusual = (id) -> clone.qual id, 5
clone.vintage = (id) -> clone.qual id, 3
clone.qual = (id, q) ->
    x = clone.defn id
    x.quality = q
    x

getNS = -> exports.ns

parentTrade = (ev) -> $(ev.currentTarget).parents 'div.trade'

doLater = (s, f) -> setTimeout f, s


# copy actions


BCA = # backpack copy actions
    copy: (a, b) ->
        c = a.clone(true, true).unbind()
        t = b.parents '.trade'
        id = a.data('item-defn').id
        r = b.clone(false, false)
        b.replaceWith c
        hideItemTip()
        trigger.tradeChanged t
        c.dblclick (e) ->
            hideItemTip()
            c.replaceWith r
            r.droppable BCA.dropOpts()
            ids = t.data 'ids'
            ids.splice ids.indexOf(id), 1
            trigger.tradeChanged t

    copyToTrade: (e) ->
        s = $ e.currentTarget
        i = s.data('item-defn').id
        avail = (x for x in $('.trade:visible', e.data.target) when i not in ($(x).data('ids') or []))
        if avail
            a = $ avail[0]
            t = $ e.data.selector, a
            ids = a.data('ids') or []
            ids.push i
            a.data 'ids', ids
            BCA.copy s, t
            # else alert or message or something

    dragOpts: ->
        appendTo: 'body'
        cursor: 'move'
        helper: 'clone'
        revert: 'invalid'
        zIndex: 9002
        start: (e, ui) ->
            q = ui.helper.prevObject.data('item-defn').quality
            ui.helper.addClass "qual-background-#{q} ztop"

    dropOpts: ->
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
                BCA.copy s, $(@)


CCA =  # chooser copy actions
    copy: (a, b) ->
        c = a.clone(true, true).unbind()
        t = b.parents '.trade'
        try
            id = a.data('item-defn').id
        catch err
            console.log "ERR:", err, a, a.data('item-defn')
            return
        r = b.clone(false, false)
        c.data 'item-defn', clone(a.data('item-defn'))
        b.replaceWith c
        hideItemTip()
        trigger.tradeChanged t
        c.dblclick (e) ->
            hideItemTip()
            c.replaceWith r
            r.droppable CCA.dropOpts()
            trigger.tradeChanged t

    copyToTrade: (e) ->
        e.stopImmediatePropagation()
        s = $ e.currentTarget
        avail = (x for x in $('.trade:visible', e.data.target))
        if avail and avail.length
            a = $ avail[0]
            t = $ 'div.item.want:empty:first', a
            if s.parents('.trade').length
                console.log 'CCA copy:',s, t, e
                #s.detach()
                #trigger.tradeChannged s.parents('.trade')
            else
                CCA.copy s, t
        # else alert or message or something

    dragOpts: ->
        helper: 'clone'
        revert: 'invalid'
        cursor: 'move'
        appendTo: 'body'
        zIndex: 9002
        start: (e, ui) ->
            q = ui.helper.prevObject.data('item-defn').quality
            ui.helper.addClass "qual-background-#{q} ztop"

    dropOpts: ->
        accept: 'div.item.chooser'
        hoverClass: 'outline'
        drop: (e, ui) ->
            s = ui.helper.prevObject
            CCA.copy s, $(@)


trigger =
    newBackpackItems: (s) -> $(document).trigger 'new-backpack-items', s
    newChooserItems:  (s) -> $(document).trigger 'new-chooser-items', s
    newTradeSlots:    (s) -> $(document).trigger 'new-trade-slots', s
    tradeChanged:     (s) -> $(document).trigger 'trade-changed', s
    tradeAdded:       (s) -> $(document).trigger 'trade-added', s
    tradeDeleted:     (s) -> $(document).trigger 'trade-deleted', s


makeChooserItems = (ns) ->
    g = ns.schema.ext.groups
    c = 'chooser'
    m = makeItem

    items =
        '*'                 : -> m ns, clone.unique(i), c for i in g.tradables when i > 0
        '.commodity'        : -> m ns, clone.unique(i), c for i in g.commodities
        '.promo'            : -> m ns, clone.unique(i), c for i in g.promos
        '.wearable'         : -> m ns, clone.unique(i), c for i in g.hats
        '.weapon'           : -> m ns, clone.unique(i), c for i in g.weapons

        '.vintage'          : -> m ns, clone.vintage(i), c for i in g.vintage_weapons.concat g.vintage_hats
        '.vintage.weapon'   : -> m ns, clone.vintage(i), c for i in g.vintage_weapons
        '.vintage.wearable' : -> m ns, clone.vintage(i), c for i in g.vintage_hats

        '.unusual'          : -> m ns, clone.unusual(i), c for i in g.unusual_hats.concat g.unusual_weapons
        '.unusual.weapon'   : -> m ns, clone.unusual(i), c for i in g.unusual_weapons
        '.unusual.wearable' : -> m ns, clone.unusual(i), c for i in g.unusual_hats

        '.genuine'          : -> m ns, clone.genuine(i), c for i in g.genuine_weapons.concat g.genuine_hats
        '.genuine.weapon'   : -> m ns, clone.genuine(i), c for i in g.genuine_weapons
        '.genuine.wearable' : -> m ns, clone.genuine(i), c for i in g.genuine_hats

        '.strange.weapon'   : -> m ns, clone.strange(i), c for i in g.strange_weapons

        byClass     : (n) -> i for i in items['*']() when i.hasClass(n)
        '.scout'    : -> items.byClass 'scout'
        '.soldier'  : -> items.byClass 'soldier'
        '.pyro'     : -> items.byClass 'pyro'
        '.demoman'  : -> items.byClass 'demoman'
        '.heavy'    : -> items.byClass 'heavy'
        '.engineer' : -> items.byClass 'engineer'
        '.medic'    : -> items.byClass 'medic'
        '.sniper'   : -> items.byClass 'sniper'
        '.spy'      : -> items.byClass 'spy'
        '.allclass' : -> items.byClass 'allclass'
    items
