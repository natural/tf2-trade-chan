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

            if not params.tid
                addTrade uid, have, want, text, (tid) ->
                    sendMessage tid, have, want, text, keys.add
                    cb success:true, tid:tid

            else if params.tid and not have.length
                deleteTrade uid, params.tid, (trade) ->
                    sendMessage params.tid, [], [], '', keys.del
                    cb success:true, tid:params.tid

            else
                updateTrade params.tid, have, want, text, () ->
                    sendMessage params.tid, have, want, text, keys.upd
                    cb success:true, tid:params.tid


addTrade = (uid, have, want, text, next) ->
    steam.actions.schema (schema) ->
        newTradeId uid, (tid) ->
            putTradePayload tid, have, want, text, (okay) ->
                for item in have
                    fillTradeBuckets tid, item, keys.have, schema
                for item in want
                    fillTradeBuckets tid, item, keys.want, schema
                next tid


deleteTrade = (uid, tid, next) ->
    steam.actions.schema (schema) ->
        getTrades [tid], (trades) ->
            R.lrem keys.userTrades(uid), 0, tid, () ->
                R.del keys.trade(tid), (err, count) ->
                    trade = JSON.parse trades[tid]
                    for item in trade.have
                        drainTradeBuckets tid, item, keys.have, schema
                    for item in trade.want
                        drainTradeBuckets tid, item, keys.want, schema
                    next()


updateTrade = (tid, have, want, text, next) ->
    steam.actions.schema (schema) ->
        getTrades [tid], (trades) ->
            trade = JSON.parse trades[tid]

            ## drain the old buckets
            for item in trade.have
                drainTradeBuckets tid, item, keys.have, schema
            for item in trade.want
                drainTradeBuckets tid, item, keys.want, schema

            putTradePayload tid, have, want, text, (okay) ->
                for item in have
                    fillTradeBuckets tid, item, keys.have, schema
                for item in want
                    fillTradeBuckets tid, item, keys.want, schema
                next()


sendMessage = (tid, have, want, text, action) ->
    cns = keys.tradeChannels have, want
    msg = tid:tid, have:have, want:want, text:text, action:action
    for cn in cns
        msg.name = cn
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


fillTradeBuckets = (tid, item, which, schema) ->
    for key in keys.tradeBuckets item, which, schema
        R.lpush key, tid, ->


drainTradeBuckets = (tid, item, which, schema) ->
    for key in keys.tradeBuckets item, which, schema
        R.lrem key, 0, tid, ->


newTradeId = (uid, next) ->
    R.incr keys.tradeCounter, (err, tid) ->
        if not err and tid?
            R.lpush keys.userTrades(uid), tid, (e, v) ->
                if not e and v?
                    next tid


extGroups = ext.actions.allGroups()


keys =
    add: 'add'
    del: 'del'
    upd: 'upd'

    have: 'have'
    want: 'want'

    trade: (tid) ->
        "trade:#{tid}"

    tradeBuckets: (def, dir, schema) ->
        quality = if def.quality? then def.quality else def.item_quality
        buckets = ["bucket:#{dir}:#{quality}:#{def.defindex}"]
        for name, seq of extGroups
            if "#{def.defindex}" in seq
                quality = if def.quality then def.quality else 6
                buckets.push "bucket:#{dir}:#{quality}:#{name}"
        buckets

    tradeChannels: (have, want) ->
        channels = ['blat']
        for name, seq of extGroups
            ## this test is too simple for the 'have' items; must
            ## check quality and type for inclusion into the various
            ## channels.  same is true of tradeBuckets function above.
            for def in have
                if "#{def.defindex}" in seq
                    channels.push name
            for def in want
                if "#{def.defindex}" in seq
                    channels.push name
        channels

    tradeCounter: 'tf2tc:sys:gtc'

    userTrades: (uid) ->
        "user:#{uid}:trades"
