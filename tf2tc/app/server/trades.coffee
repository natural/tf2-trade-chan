## server-side module for trades
#
utils = require './utils'
steam = require './steam'
ext = require './schema_ext'
groups = ext.all().groups


exports.actions =
    match: (params, cb) ->
        session = @session
        if not session.user_id
            cb success:false, matches:null
        localSchema (schema) ->
            getTrade params.tid, (trade) ->
                matchTrade schema, trade, (tids) ->
                    getTrades tids, (matches) ->
                        cb success:true, count:tids.length, matches:matches


    publish: (params, cb) ->
        session = @session
        if not session.user_id
            cb success:false, tid:null

        uid = utils.uidFromOpenId session.user_id
        have = if params.have then (p for p in params.have when p) else []
        want = if params.want then (p for p in params.want when p) else []
        text = params.text or ''
        params.tid = "#{params.tid}" if params.tid

        localSchema (schema) ->
            if not params.tid
                addTrade schema, uid, have, want, text, (tid) ->
                    sendMessage schema, tid, uid, have, want, text, keys.add
                    cb success:true, tid:tid
            else if params.tid and not have.length
                deleteTrade schema, uid, params.tid, (trade) ->
                    sendMessage schema, params.tid, uid, trade.have, trade.want, trade.text, keys.del
                    cb success:true, tid:params.tid
            else
                updateTrade schema, params.tid, uid, have, want, text, () ->
                    sendMessage schema, params.tid, uid, have, want, text, keys.upd
                    cb success:true, tid:params.tid


    userTrades: (params, cb) ->
        session = @session
        if not session.user_id
            cb success:false, trades:null
        usr = if params.user? then params.user else session.user_id
        uid = utils.uidFromOpenId usr
        getUserTrades uid, (trades) ->
            cb success:true, trades:trades


localSchema = (next) ->
    steam.actions.schema (schema) ->
        schema.ext.items = makeSchemaItemMap schema
        next schema


makeSchemaItemMap = (s) ->
    items = {}
    for item in s.result.items.item
        do (item) -> items[item.defindex] = item
    items


addTrade = (schema, uid, have, want, text, next) ->
    newTradeId uid, (tid) ->
        putTradePayload tid, uid, have, want, text, (okay) ->
            for item in have
                fillTradeBuckets schema, tid, item, keys.have
            for item in want
                fillTradeBuckets schema, tid, item, keys.want
            next tid


deleteTrade = (schema, uid, tid, next) ->
    getTrades [tid], (trades) ->
        R.lrem keys.userTrades(uid), 0, tid, () ->
            R.del keys.trade(tid), (err, count) ->
                trade = JSON.parse trades[tid]
                for item in trade.have
                    drainTradeBuckets schema, tid, item, keys.have
                for item in trade.want
                    drainTradeBuckets schema, tid, item, keys.want
                next trade


updateTrade = (schema, tid, uid, have, want, text, next) ->
    getTrades [tid], (trades) ->
        trade = JSON.parse trades[tid]
        ## drain the old buckets
        for item in trade.have
            drainTradeBuckets schema, tid, item, keys.have
        for item in trade.want
            drainTradeBuckets schema, tid, item, keys.want

        putTradePayload tid, uid, have, want, text, (okay) ->
            for item in have
                fillTradeBuckets schema, tid, item, keys.have
            for item in want
                fillTradeBuckets schema, tid, item, keys.want
            next()


sendMessage = (schema, tid, uid, have, want, text, action) ->
    cns = keys.tradeChannels schema, have, want
    msg = tid:tid, have:have, want:want, text:text, action:action, uid:uid
    for cn in cns
        do(cn) ->
            msg.channel = cn
            msg.channels = cns
            SS.publish.channel [cn], 'trd-msg', msg


matchTrade = (schema, trade, next) ->
    multi = R.multi()
    mrange = (k) ->
        console.log 'mrange key:', k
        multi.lrange k, 0, -1

    mrange k for k in keys.tradeBuckets(schema, item, 'have') for item in trade.want
    mrange k for k in keys.tradeBuckets(schema, item, 'want') for item in trade.have
    #mrange k for k in keys.matchWantBuckets(schema, item) for item in trade.want
    #mrange k for k in keys.matchHaveBuckets(schema, item) for item in trade.have
    multi.exec (err, replies) ->
        outs = new SS.shared.set
        outs.update v for v in replies
        next outs.members()


getTrade = (tid, next) ->
    R.get keys.trade(tid), (err, val) ->
        next JSON.parse(val)


getUserTrades = (uid, next) ->
    k = keys.userTrades uid
    R.lrange k, 0, -1, (err, ids) ->
        getTrades ids, (trades) ->
            next trades


getTrades = (tids, next) ->
    ks = (keys.trade(i) for i in tids)
    R.mget ks, (err, vals) ->
        trades = {}
        for id in tids
            v = vals[tids.indexOf(id)]
            trades[id.split(':').pop()] = v if v
        next trades


putTradePayload = (tid, uid, have, want, text, next) ->
    k = keys.trade tid
    v = JSON.stringify {have:have, want:want, text:text, tid:tid, uid:uid}
    R.set k, v, ->
        next true ## set can't fail


fillTradeBuckets = (schema, tid, item, which) ->
    for key in keys.tradeBuckets schema, item, which, channels=true
        R.lpush key, tid, ->


drainTradeBuckets = (schema, tid, item, which) ->
    for key in keys.tradeBuckets schema, item, which, channels=true
        R.lrem key, 0, tid, ->


newTradeId = (uid, next) ->
    R.incr keys.tradeCounter, (err, tid) ->
        if not err and tid?
            R.lpush keys.userTrades(uid), tid, (e, v) ->
                if not e and v?
                    next tid


extPred =
    commodities: (s, d) -> "#{d.defindex}" in groups.commodities
    promos: (s, d) -> "#{d.defindex}" in groups.promos
    metal: (s, d) -> "#{d.defindex}" in groups.metal
    vintage_weapons: (s, d) -> "#{d.defindex}" in groups.vintage_weapons and d.quality == 3
    vintage_hats: (s, d) -> "#{d.defindex}" in groups.vintage_hats and d.quality == 3
    genuine_weapons: (s, d) -> "#{d.defindex}" in groups.genuine_weapons and d.quality == 1
    genuine_hats: (s, d) -> "#{d.defindex}" in groups.genuine_hats and d.quality == 1
    unusual_hats: (s, d) ->
        try
            s.ext.items[d.defindex].item_class == 'tf_wearable' and d.quality == 5
        catch e
            false


keys =
    add: 'add'
    del: 'del'
    upd: 'upd'

    have: 'have'
    want: 'want'

    trade: (tid) ->
        "trade:#{tid}"

    otherBuckets: (schema, item, direction) ->
        quality = if item.quality? then item.quality else item.item_quality
        buckets = {}
        d = "#{item.defindex}"
        console.log quality, d
        if quality == 3 and d in groups.offers
            buckets["bucket:#{direction}:3:-2"] = 1
        if quality == 3 and d in groups.vintage_hats
            buckets["bucket:#{direction}:3:-2"] = 1
        if quality == 5 and d in groups.offers
            buckets["bucket:#{direction}:5:-2"] = 1
            buckets["bucket:#{direction}:5:-2"] = 1


    matchWantBuckets: (schema, item) ->
        d = "#{item.defindex}"
        b = {}
        q = if item.quality? then item.quality else item.item_quality
        if d in groups.promos
            b["bucket:have:#{q}:#{d}"] = 1
        if d in groups.offers
            b["bucket:have:#{q}:#{d}"] = 1
        (name for name of b)

    matchHaveBuckets: (schema, item) ->
        []

    tradeBuckets: (schema, item, direction, channels=false) ->
        quality = if item.quality? then item.quality else item.item_quality
        buckets = {}
        buckets["bucket:#{direction}:#{quality}:#{item.defindex}"] = 1

        for name, pred of extPred
            if pred schema, item
                quality = if item.quality then item.quality else 6
                buckets["bucket:#{direction}:#{quality}:#{name}"] = 1
                if channels
                    buckets["channel:trades:#{name}"] = 1
        (name for name of buckets)

    tradeChannels: (sch, have, want) ->
        channels = blat:1
        for def in have.concat want
            for name, pred of extPred
                if pred sch, def
                    channels[name] = 1
        (name for name of channels)

    tradeCounter: 'tf2tc:sys:gtc'

    userTrades: (uid) ->
        "user:#{uid}:trades"
