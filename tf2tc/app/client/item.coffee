

exports.page = -> '<div class="page"></div>'


exports.row = -> '<div class="row"></div>'


exports.make = (ns, defn, target, type) ->
    if defn
        v = "<div class='itemw'>
               <div class='item #{type}'>
                 <img src='#{ns.schema_items[defn.defindex].image_url}' />
               </div>
             </div>"
        target.append v
    else
        v = '<div class="itemw"><div class="item" /></div>'
        target.append v
        return

    prop = exports.props ns, defn
    sdefn = ns.schema_items[defn.defindex]
    item = $ 'div.item:last', target
    item.data 'item-defn', defn
    item.data 'schema-defn', sdefn
    item.addClass "qual-border-#{defn.quality or 6} qual-hover-#{defn.quality or 6}"
    item.addClass "untradable" if defn.flag_cannot_trade
    img = $ 'img', item

    ## name tag and/or desc tag icon
    tag = prop.tag()
    img.wrap "<div class='deco tag tag-#{tag}' />" if tag

    ## paint jewel
    jewel = prop.paint()
    img.wrap "<div class='deco jewel jewel-#{jewel}' />" if jewel

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

    ## add some classes to the item wrapper (the parent .itemw) for
    ## filtering.
    c = [ qualityName(ns, defn.quality).toLowerCase() ]
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
            if x
                c.push x.toLowerCase()
    else
        c.push 'allclass'
    $('div.itemw:last', target).addClass c.join(' ')


exports.props = (ns, defn) ->
    selectAttr = (id) ->
        if defn.attributes
            x = (n for n in defn.attributes.attribute)
            try
                (n for n in x when n.defindex==id)[0]
            catch e
                null
    equipped: ->
        (defn.inventory & 0xff0000) != 0

    tag: ->
        if defn.custom_desc and defn.custom_name
            '5020-5044'
        else if defn.custom_name
            '5020'
        else if defn.custom_desc
            '5044'

    paint: ->
        p = selectAttr(142)
        if p then p.float_value else null

    effect: ->
        if defn.defindex==143
            99
        else if defn.defindex==1899
            20
        else
            e = selectAttr(134)
            if e then e.float_value else null

    useCount: ->
        if defn.defindex in (t.defindex for t in ns.schema_tools()) or defn.defindex in (t.defindex for t in ns.schema_actions())
            defn.quantity


qualityName = (ns, id) ->
    keys = (k for k, v of ns.schema.result.qualities when v==id)
    if keys.length
        ns.schema.result.qualityNames[keys[0]] or ''
    else
        'Unknown'
