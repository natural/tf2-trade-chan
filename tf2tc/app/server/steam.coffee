## steam apis
#

http = require 'http'
libxmljs = require 'libxmljs'
request = require 'request'
ext = require './schema_ext'
utils = require './utils'


exports.actions =
    schema: (cb) ->
        o = urls.schema SS.config.local.steam_api_key
        get o, schemaTweak, cb

    items: (params, cb) ->
        o = urls.items params.id64, SS.config.local.steam_api_key
        get o, JSON.parse, cb

    profile: (params, cb) ->
        o = urls.profile params.id64, SS.config.local.steam_api_key
        get o, JSON.parse, extractProfile(params.id64, cb)

    status: (params, cb) ->
        o = urls.status params.id64
        get o, statusKeys, cb

    news: (cb) ->
        o = urls.news 5, 256
        get o, JSON.parse, (d) ->
            news = d.appnews.newsitems.newsitem
            cb news


req = (opts, cb) ->
    request {uri:opts.uri, timeout:opts.timeout}, cb


get = (opts, parse, cb) ->
    R.get opts.uri, (err, val) ->
        if val
            utils.log "steam data cache hit #{opts.uri}"
            cb(if parse then parse val else val)
        else
            utils.log "steam data cache miss #{opts.uri}"
            req opts, (err, res, body) ->
                if not err and res.statusCode == 200
                    R.setex opts.uri, opts.ttl, body, (e, x) ->
                        cb(if parse then parse body else body)
                else
                    cb null


extractProfile = (id64, next) ->
    (payload) ->
        try
            profile = payload.response.players.player[0]
            profile.steamid = id64
            next profile
        catch err
            null


schemaTweak = (payload) ->
    schema = JSON.parse payload
    schema.ext = ext.all()
    ks = (Number(k) for k, j of imgFixes)
    for k, n of schema.result.items.item
        if n.defindex in ks
            n.image_url = imgFixes[n.defindex]
    schema


urls =
    schema: (key) ->
        timeout: 1000*5
        ttl: 60*60
        uri: "http://api.steampowered.com/ITFItems_440/GetSchema/v0001/?format=json&language=en&key=#{key}"

    items: (id64, key) ->
        timeout: 1000*5
        ttl: 60*5
        uri: "http://api.steampowered.com/ITFItems_440/GetPlayerItems/v0001/?key=#{key}&SteamID=#{id64}"

    profile: (id64, key) ->
        timeout: 1000*5
        ttl: 60*10
        uri: "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0001/?key=#{key}&steamids=#{id64}"

    status: (id64) ->
        timeout: 1000*5
        ttl: 60*5
        uri: "http://steamcommunity.com/profiles/#{id64}/?xml=1"

    news: (count, max) ->
        path: "http://api.steampowered.com/ISteamNews/GetNewsForApp/v0001/?appid=440&count=#{count}&maxlength=#{max}&format=json"
        timeout: 1000*5
        ttl: 60*15


statusKeys = (v) ->
    d =
        name:''
        state:''
        avatarFull:''
        avatarIcon:''
        avatarMedium:''
        stateMessage:''
    try
        x = libxmljs.parseXmlString(v)
        d.name = x.get('//steamID').text()
        d.state = x.get('//onlineState').text()
        d.avatarFull = x.get('//avatarFull').text()
        d.avatarIcon = x.get('//avatarIcon').text()
        d.avatarMedium = x.get('//avatarMedium').text()
        d.stateMessage = x.get('//stateMessage').text()
    catch e
        null
    d


imgFixes =
    5027: '/images/paints/TF_Tool_PaintCan_1.png'      # Indubitably Green
    5028: '/images/paints/TF_Tool_PaintCan_2.png'      # Zephaniah's Greed
    5029: '/images/paints/TF_Tool_PaintCan_3.png'      # Noble Hatter's Violet
    5030: '/images/paints/TF_Tool_PaintCan_4.png'      # Color No. 216-190-216
    5031: '/images/paints/TF_Tool_PaintCan_5.png'      # A Deep Commitment to Purple
    5032: '/images/paints/TF_Tool_PaintCan_6.png'      # Mann Co. Orange
    5033: '/images/paints/TF_Tool_PaintCan_7.png'      # Muskelmannbraun
    5034: '/images/paints/TF_Tool_PaintCan_8.png'      # Peculiarly Drab Tincture
    5035: '/images/paints/TF_Tool_PaintCan_9.png'      # Radigan Conagher Brown
    5036: '/images/paints/TF_Tool_PaintCan_10.png'     # Ye Olde Rustic Colour
    5037: '/images/paints/TF_Tool_PaintCan_11.png'     # Australium Gold
    5038: '/images/paints/TF_Tool_PaintCan_12.png'     # Aged Moustache Grey
    5039: '/images/paints/TF_Tool_PaintCan_13.png'     # An Extraordinary Abundance of Tinge
    5040: '/images/paints/TF_Tool_PaintCan_14.png'     # A Distinctive Lack of Hue
    5051: '/images/paints/TF_Tool_PaintCan_15.png'     # Pink as Hell
    5052: '/images/paints/TF_Tool_PaintCan_16.png'     # A Color Similar to Slate
    5053: '/images/paints/TF_Tool_PaintCan_17.png'     # Drably Olive
    5054: '/images/paints/TF_Tool_PaintCan_18.png'     # The Bitter Taste of Defeat and Lime
    5055: '/images/paints/TF_Tool_PaintCan_19.png'     # The Color of a Gentlemann's Business Pants
    5056: '/images/paints/TF_Tool_PaintCan_20.png'     # Dark Salmon Injustice
    5060: '/images/paints/TF_Tool_PaintCan_5060.png'   # operators overalls
    5061: '/images/paints/TF_Tool_PaintCan_5061.png'   # waterlogged lab coat
    5062: '/images/paints/TF_Tool_PaintCan_5062.png'   # balaclavas are forever
    5063: '/images/paints/TF_Tool_PaintCan_5063.png'   # air of debonair
    5064: '/images/paints/TF_Tool_PaintCan_5064.png'   # value of teamwork
    5065: '/images/paints/TF_Tool_PaintCan_5065.png'   # cream spirit
