## server-side module for trades
#
utils = require('./utils')

exports.actions =

    ## pass in params.user to retrieve trades for a specific user; if
    ## params.user not given, callback receives trades for current
    ## session user.
    userTrades: (params, cb) ->
        @getSession (session) ->
            if not session.user.loggedIn()
                cb {success:false, trades:null}
            uid = uidFromOpenID (if params.user? then params.user else session.user_id)
            getTradeUids uid, (ids) ->
                getTrades (keys.trade(i) for i in ids), (trades) ->
                    cb {success:true, trades:trades}


    publish: (params, cb) ->
        @getSession (session) ->
            if not @session.user.loggedIn()
                cb {success:false, tradeID:null}

            have = params.have
            want = params.want
            uid = uidFromOpenID @session.user_id

            ## generate trade id
            nextTradeID uid, (tradeID) ->
                utils.log "TRADE ID #{tradeID} FOR USER #{uid}"

                ## set the payload
                setTradePayload tradeID, params, () ->

                    ## for each have.defindex, place the trade id into each defindex:quality bucket
                    ks = keys.tradeBuckets have, tradeID
                    fillTradeBuckets ks, (status) ->
                        utils.log "ADD #{tradeID} TRADE TO BUCKETS #{ks} STATUS #{status}"

                        ## for each have.defindex, publish the trade to each ???:quality channel
                        cb {success:true, tradeID:tradeID}


keys =
    ## this key is used to generate trade ids.
    global_trade: 'g:trade_counter'

    ## given a user id, this creates a key for holding the list of
    ## trades associated with the user.
    userTrades: (uid) ->
        "u:trades:#{uid}"

    ## given a list of items and their trade id, this creates an array
    ## of keys to various buckets (def + qual).  the array is mixed
    ## with the trade id so it can be easily passed to R.mset.
    tradeBuckets: (items, tradeID) ->
        bs = []
        for defn in items
            q = if defn.quality? then defn.quality else defn.item_quality
            bs.push "b:#{defn.defindex}:#{q}", tradeID
        bs

    ## given a trade id, this creates a key for it.
    trade: (tid) ->
        "t:#{tid}"


dekey =
    trade: (key) ->
        key.split(':').pop()


uidFromOpenID = (openid) ->
    openid.split('/').pop()


setTradePayload = (tid, data, next) ->
    k = keys.trade tid
    v = JSON.stringify data
    R.set k, v, () ->
        next true ## set can't fail


fillTradeBuckets = (keyvals, next) ->
    R.mset keyvals, () ->
        next true ## mset can't fail


nextTradeID = (uid, next) ->
    R.incr keys.global_trade, (err, tid) ->
        if not err and tid?
            ## need to add hook to session disconnect to remove
            ## the user trade key "tid:#{uid}"

            ## push the tradeID to the user.trades key
            R.lpush keys.userTrades(uid), tid, (e, v) ->
                if not e and v?
                    next tid


getTradeUids = (uid, next) ->
    k = keys.userTrades uid
    R.lrange k, 0, -1, (err, val) ->
        next val


getTrades = (ids, next) ->
    R.mget ids, (err, vals) ->
        trades = {}
        for id in ids
            v = vals[ids.indexOf(id)]
            trades[id.split(':').pop()] = v if v
        next trades
