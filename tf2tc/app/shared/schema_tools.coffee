

exports.invert = invert = (obj) ->
    m = {}
    for k, v of obj
        do(k, v) -> m[v] = k
    m


exports.mapObj = mapObj = (obj, f) ->
    m = {}
    for k, v of obj
        do(k, v) -> m[k] = f(k, v)
    m

exports.mapSeq = mapSeq = (seq, f) ->
    m = {}
    for k in seq
        do(k) -> m[k] = f(k)
    m


exports.groupMaps = groupMaps = (items) ->
    weap = 'weapon'
    hat = 'hat'
    wear = 'tf_wearable'
    select = (pred) -> k for k, i of items when pred(k, i)

    groups =
        commodities : [
            'Commodities'
            select (a, b) -> a in ['5000', '5001', '5002', '5021']
        ]
        hats : [
            'Hats'
            select (a, b) -> b.item_class == wear and b._t == tradableFlags.always
        ]
        metal : [
            'Metal'
            select (a, b) -> b.item_type_name == 'Craft Item' and b.craft_class == 'craft_bar'
        ]
        offers : [
            'Offers'
            select (a, b) -> (a < 0) and b.item_class == 'Offer'
        ]
        promos : [
            'Promos'
            select (a, b) -> a in ['126', '143', '162', '161', '160']
        ]
        tools : [
            'Tools'
            select (a, b) -> b.item_class == 'tool' and b._t == tradableFlags.always
        ]
        tradables : [
            'Tradable Items'
            select (a, b) -> b._t == tradableFlags.always
        ]
        untradables : [
            'Untradable Items'
            select (a, b) -> b._t == tradableFlags.never
        ]
        weapons : [
            'Weapons'
            select (a, b) -> b.craft_class == weap and b._t == tradableFlags.always
        ]
        genuine : [
            'Genuine Items'
            select (a, b) -> basicQualities.genuine in b._q
        ]
        genuine_hats : [
            'Genuine Hats'
            select (a, b) -> basicQualities.genuine in b._q and b.item_class == wear
        ]
        genuine_weapons : [
            'Genuine Weapons'
            select (a, b) -> basicQualities.genuine in b._q and b.craft_class == weap
        ]
        #strange : ['Strange Items']
        #strange_hats : ['Strange Hats']
        strange_weapons : [
            'Strange Weapons'
            select (a, b) -> basicQualities.strange in b._q and b.craft_class == weap
        ]
        unusual : [
            'Unusual Items'
            select (a, b) -> basicQualities.unusual in b._q
        ]
        unusual_hats : [
            'Unusual Hats'
            select (a, b) -> basicQualities.unusual in b._q and b.item_class == wear
        ]
        unusual_weapons : [
            'Unusual Weapons'
            select (a, b) -> basicQualities.unusual in b._q and b.craft_class == weap
        ]
        vintage : [
            'Vintage Items'
            select (a, b) -> basicQualities.vintage in b._q
        ]
        vintage_hats : [
            'Vintage Hats'
            select (a, b) -> basicQualities.vintage in b._q and b.craft_class == hat
        ]
        vintage_weapons : [
            'Vintage Weapons'
            select (a, b) -> basicQualities.vintage in b._q and b.craft_class == weap
        ]

    titles: mapObj(groups, (k, v) -> groups[k][0])
    selectors: mapObj(groups, (k, v) -> groups[k][1])


exports.qualityMaps = qualityMaps = (schema) ->
    nameToKey = schema.result.qualities
    nameToTitle = schema.result.qualityNames
    keyToName = invert nameToKey

    nameToKey: nameToKey
    nameToTitle: nameToTitle
    keyToName: keyToName
    keyToTitle: mapObj(keyToName, (k, v) -> nameToTitle[v])



exports.basicQualities = basicQualities =
    genuine:  1
    vintage:  3
    unusual:  5
    common:   6
    strange: 11


exports.tradableFlags = tradableFlags =
    never: 0
    always: 1
    gift: -1



