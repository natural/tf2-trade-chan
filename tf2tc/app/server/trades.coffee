## server-side module for trades
#
utils = require './utils'
steam = require './steam'
ext = require './schema_ext'


exports.actions =
    userTrades: (params, cb) ->
        @getSession (session) ->
            if not session.user.loggedIn()
                cb success:false, trades:null

            usr = if params.user? then params.user else session.user_id
            uid = utils.uidFromOpenId usr
            getUserTrades uid, (trades) ->
                cb success:true, trades:trades

    publish: (params, cb) ->
        @getSession (session) ->
            if not session.user.loggedIn()
                cb success:false, tid:null

            uid = utils.uidFromOpenId session.user_id
            have = if params.have then (p for p in params.have when p) else []
            want = if params.want then (p for p in params.want when p) else []
            text = params.text or ''
            params.tid = "#{params.tid}" if params.tid

            steam.actions.schema (schema) ->
                schema.ext.items = makeSchemaItemMap(schema)

                if not params.tid
                    addTrade schema, uid, have, want, text, (tid) ->
                        sendMessage schema, tid, have, want, text, keys.add
                        cb success:true, tid:tid

                else if params.tid and not have.length
                    deleteTrade schema, uid, params.tid, (trade) ->
                        sendMessage schema, params.tid, trade.have, trade.want, trade.text, keys.del
                        cb success:true, tid:params.tid

                else
                    updateTrade schema, params.tid, have, want, text, () ->
                        sendMessage schema, params.tid, have, want, text, keys.upd
                        cb success:true, tid:params.tid


makeSchemaItemMap = (s) ->
    items = {}
    for item in s.result.items.item
        do (item) -> items[item.defindex] = item
    items


addTrade = (schema, uid, have, want, text, next) ->
    newTradeId uid, (tid) ->
        putTradePayload tid, have, want, text, (okay) ->
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


updateTrade = (schema, tid, have, want, text, next) ->
    getTrades [tid], (trades) ->
        trade = JSON.parse trades[tid]

        ## drain the old buckets
        for item in trade.have
            drainTradeBuckets schema, tid, item, keys.have
        for item in trade.want
            drainTradeBuckets schema, tid, item, keys.want

        putTradePayload tid, have, want, text, (okay) ->
            for item in have
                fillTradeBuckets schema, tid, item, keys.have
            for item in want
                fillTradeBuckets schema, tid, item, keys.want
            next()


sendMessage = (schema, tid, have, want, text, action) ->
    cns = keys.tradeChannels schema, have, want
    msg = tid:tid, have:have, want:want, text:text, action:action
    for cn in cns
        do(cn) ->
            msg.channel = cn
            msg.channels = cns
            SS.publish.channel [cn], 'trd-msg', msg


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


putTradePayload = (tid, have, want, text, next) ->
    k = keys.trade tid
    v = JSON.stringify {have:have, want:want, text:text}
    R.set k, v, () ->
        next true ## set can't fail


fillTradeBuckets = (schema, tid, item, which) ->
    for key in keys.tradeBuckets schema, item, which
        R.lpush key, tid, ->


drainTradeBuckets = (schema, tid, item, which) ->
    for key in keys.tradeBuckets schema, item, which
        R.lrem key, 0, tid, ->


newTradeId = (uid, next) ->
    R.incr keys.tradeCounter, (err, tid) ->
        if not err and tid?
            R.lpush keys.userTrades(uid), tid, (e, v) ->
                if not e and v?
                    next tid


extGroups = ext.direct.allGroups()


extPred =
    commodities: (s, d) -> "#{d.defindex}" in extGroups.commodities
    promos: (s, d) -> "#{d.defindex}" in extGroups.promos
    metal: (s, d) -> "#{d.defindex}" in extGroups.metal
    vintage_weapons: (s, d) -> "#{d.defindex}" in extGroups.vintage_weapons and d.quality == 3
    vintage_hats: (s, d) -> "#{d.defindex}" in extGroups.vintage_hats and d.quality == 3
    genuine_weapons: (s, d) -> "#{d.defindex}" in extGroups.genuine_weapons and d.quality == 1
    genuine_hats: (s, d) -> "#{d.defindex}" in extGroups.genuine_hats and d.quality == 1
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

    tradeBuckets: (sch, def, dir) ->
        quality = if def.quality? then def.quality else def.item_quality
        buckets = {}
        buckets["bucket:#{dir}:#{quality}:#{def.defindex}"] = 1
        for name, pred of extPred
            if pred sch, def
                quality = if def.quality then def.quality else 6
                buckets["bucket:#{dir}:#{quality}:#{name}"] = 1
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
