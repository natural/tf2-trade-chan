exports.hide = (e) ->
    $('#tooltip').hide()


exports.show = (e) ->
    tt = exports.hide()
    cell = $ e.currentTarget
    ns = e.data.ns
    item = cell.data 'item-defn'
    sdef = cell.data 'schema-defn'
    vals = make_tooltip_vals()
    if !sdef
        return
    type = sdef.item_type_name.replace('TF_Wearable_Hat', 'Wearable Item').replace('TF_LockedCrate', 'Crate')
    vals.level = "Level #{item.level} #{type}" if item.level?
    if item.custom_name
        vals.name =  "\"#{item.custom_name}\""
    else
        vals.name = sdef.item_name # if sdef.proper_name then sdef.name else sdef.item_name
    vals.name = "#{ns.schema_qualities[item.quality]} " + vals.name if item.quality in [3, 5, 11]

    # clear the quality classes and add the correct one
    for q in [0..20]
        $('.name', tt).removeClass("qual-text-#{q}")
    $('.name', tt).addClass("qual-text-#{item.quality}")

    ## clear the crafter value.  nb: crafter isn't set via the 'vals'
    ## object because of the async lookup
    $('.crafter', tt).text ''

    # set the control text
    ctrl_text = ->
        i = JSON.stringify item, null, 2
        s = JSON.stringify sdef, null, 2
        "item: #{i}\n\nschema: #{s}"
    vals.ctrl = "<pre>#{ctrl_text()}</pre>" if e.ctrlKey

    if item.attributes
        for idef in item.attributes.attribute
            adef = ns.schema_attribs[idef.defindex]
            extra = oo.format_schema_attr adef, idef.value
            etype = if adef then adef.effect_type else null

            switch idef.defindex
                when 134 ## effect name
                    vals[etype] = oo.format_schema_attr adef, oo.item_effects[idef.float_value]

                when 186 ## gift
                    acc = oo.value_format_map.value_is_account_id idef.value
                    $('.crafter', tt).text "Gift from #{acc}."
                    oo.get_profile acc, (p) ->
                        $('.crafter', tt).text "Gift from #{p.personaname}."

                when 187 ## crate series
                    vals[etype] = oo.format_schema_attr adef, idef.float_value

                when 214 ## kill eater
                    vals.killeater = "Kills: #{idef.value}"
                    vals.name = vals.name.replace 'Strange', oo.strange_text(idef.value)

                when 228 ## craft name
                    acc = oo.value_format_map.value_is_account_id idef.value
                    $('.crafter', tt).text "Crafted by #{acc}."
                    oo.get_profile acc, (p) ->
                        $('.crafter', tt).text "Crafted by #{p.personaname}."

                when 229 ## craft number
                    vals.name = "#{vals.name} ##{idef.value}"

                else
                    vals[etype] += ('<br>'+extra) if extra

    if sdef.attributes
        skips = ['set_employee_number', 'supply_crate_series']
        for atyp in sdef.attributes.attribute
            adef = ns.schema_attribs[atyp.name]
            if adef and adef.attribute_class not in skips
                text = oo.format_schema_attr adef, atyp.value
                curr = vals[adef.effect_type]
                vals[adef.effect_type] = if curr then curr + '<br>' + text else text

    # reset the item description
    if sdef.item_description
        desc = sdef.item_description
        if desc.indexOf('\n') > -1
            desc = desc.replace(/\n/g, '<br>')
        else
            desc = desc.wordwrap(64)
        vals.alt = if vals.alt then "#{vals.alt} <br> #{desc}" else desc

    # set limited use count
    if item.defindex in (t.defindex for t in ns.schema_tools()) or item.defindex in (t.defindex for t in ns.schema_actions())
        if item.quantity?
            vals.limiteduse = "<br>This is a limited use item.  Uses: #{item.quantity}"

    # set the untradable text
    if item.flag_cannot_trade
        vals.untradable = '<br>( Not Tradable )'

    # set the values
    for k, v of vals
        $(".#{k}", tt).html v

    # position and show
    left = cell.offset().left + (cell.width()/2) - (tt.width()/2)
    top = cell.offset().top + cell.height()
    tt.css {left:Math.max(0, left), top:top}
    tt.show()



make_tooltip_vals = ->
    alt: ''
    ctrl: ''
    killeater: ''
    level: ''
    limiteduse: ''
    name: ''
    negative: ''
    neutral:''
    positive: ''
    untradable: ''
