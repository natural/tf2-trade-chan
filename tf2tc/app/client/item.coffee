##
# item maker:
#
# this module exports a the function "make" to construct html
# representations of tf2 game items.  it does so by creating a
# container div, .itemw, and then nesting further divs and images
# inside of it.


exports.empty = (type) ->
    "<div class='itemw'><div class='item #{type}' /></div>"


exports.put = (ns, defn, target, type) ->
    x = exports.make ns, defn, type
    target.append x
    x


exports.make = (ns, defn, type) ->
    if not defn
        return $ exports.empty(type)

    itemw = $ "
    <div class='itemw'>
        <div class='item #{type}'>
            <img src='#{ns.schema_items[defn.defindex].image_url}' />
        </div>
    </div>"

    prop = exports.props ns, defn
    sdefn = ns.schema_items[defn.defindex]

    item = $ 'div.item', itemw
    item.data 'item-defn', defn
    item.data 'schema-defn', sdefn
    item.addClass "qual-border-#{defn.quality or 6} qual-hover-#{defn.quality or 6}"
    item.addClass "untradable" if defn.flag_cannot_trade
    img = $ 'img', item

    ## add text for offer items
    offer = prop.offer()
    img.before "<div class='deco title'>#{defn.name}</div>" if offer

    ## add text for new items
    unplaced = prop.unplaced()
    img.before '<div class="deco title">New</div>' if unplaced

    ## name tag and/or desc tag icon
    tag = prop.tag()
    img.wrap "<div class='deco tag tag-#{tag}' />" if tag

    ## paint jewel
    jewel = prop.paint()
    img.wrap "<div class='deco jewel jewel-#{jewel}' />" if jewel

    ## craft number
    craft = prop.lowCraft()
    if craft
        img.wrap '<div class="deco" />'
        img.parent().append "<div class='badge craft'>#{craft}</div>"

    ## equipped badge
    equip = prop.equipped()
    if equip
        img.wrap '<div class="deco" />'
        img.parent().append '<div class="badge equipped">Equipped</div>'

    ## use count badge
    count = prop.useCount()
    if count?
        img.wrap '<div class="deco" />'
        img.parent().append "<div class='badge quantity'>#{count}</div>"

    ## effect bg
    effect = prop.effect()
    img.wrap "<div class='deco effect effect-#{effect}' />" if effect

    ## add some classes to the item wrapper for filtering.
    c = [qualityName(ns, defn.quality).toLowerCase()]
    if sdefn.item_class.match(/wear/)
        c.push 'wearable'
    else if sdefn.item_class.match(/weapon/)
        c.push 'weapon'
    if "#{defn.defindex}" in ns.schema.ext.groups.promos
        c.push 'promo'
    if "#{defn.defindex}" in ns.schema.ext.groups.commodities
        c.push 'commodity'
    if sdefn.used_by_classes
        for x in sdefn.used_by_classes.class
            c.push x.toLowerCase() if x
    else
        c.push 'allclass'
    itemw.addClass c.join(' ')
    itemw



exports.props = (ns, defn) ->
    attrById = (id) ->
        if defn.attributes
            x = (n for n in defn.attributes.attribute)
            try
                (n for n in x when n.defindex==id)[0]
            catch e
                null

    attrByClass = (sdefn, name) ->
        if sdefn.attributes
            x = (n for n in sdefn.attributes.attribute)
            try
                (n for n in x when n.class==name)[0]
            catch e
                null

    equipped: ->
        (defn.inventory & 0xff0000) != 0

    unplaced: ->
        defn.inventory == 0

    tag: ->
        if defn.custom_desc and defn.custom_name
            '5020-5044'
        else if defn.custom_name
            '5020'
        else if defn.custom_desc
            '5044'

    paint: ->
        p = attrById 142
        if p then p.float_value else null

    paintName: ->
        if not cache.tools
            cache.tools = ns.schema_tools()
        n = attrById 142
        ## this doesn't cover team paints.  wha?
        if n
            av = n.float_value
            for t in cache.tools
                a = attrByClass t, 'set_item_tint_rgb'
                if a and a.value == av
                    return t.item_name
    effect: ->
        if defn.defindex==143
            99
        else if defn.defindex==1899
            20
        else
            e = attrById 134
            if e then e.float_value else null

    useCount: ->
        if defn.defindex in (t.defindex for t in ns.schema_tools()) or defn.defindex in (t.defindex for t in ns.schema_actions())
            defn.quantity

    offer: ->
        defn.defindex < 0

    lowCraft: ->
        e = attrById 229
        if (e and e.value < 101) then e.value else null


qualityName = (ns, id) ->
    keys = (k for k, v of ns.schema.result.qualities when v==id)
    if keys.length
        ns.schema.result.qualityNames[keys[0]] or ''
    else
        'Unknown'


cache =
    tools: null

