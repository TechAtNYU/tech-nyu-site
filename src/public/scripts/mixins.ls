define(
  managesAnimations: !->
    @activeStylesheetKeys = 
      LARGE: 101
      SMALL: 110

    # takes an (array of) css property-value strings and turns them into an object, i.e.
    # "top:20px;bottom:200px;" => {'top': '20px', 'bottom':'200px'}. Similarly, 
    # ["top:20px", "bottom:200px"] => {'top':'20px', 'bottom':'20px'}. Any semicolons are
    # stripped. If you pass in an object, it'll assume the values are already in the correct
    # form (i.e. without trailing semicolons) and simply return the object.
    objectify = (val) ->
      if typeof val == "string"
        ret = {}
        val .= trim!
        propValStrings = (if val.charAt(val.length-1) == ";" then val.substring(0, val.length-1) else val).split(";")

        for propValString in propValStrings
          [property, value] = propValString.split(':')
          ret[property] = value;

        ret

      else if typeof! val == "Array"
        val.reduce(((previous, current) -> $.extend(previous, objectify(current))), {})

      else if typeof! val == "Object"
        val
      else
        throw new Error('Unexpected type!')

    # takes an object of the form produced by objectify and turns it back into
    # a string of the form objectify would accept. The two functions are inverses.
    stringify = (val) ->
      if typeof! val == "Object"
        Object.keys(val).reduce(((prev, key) -> prev + key + ':' + val[key] + ';'), '');
      else if typeof val == "string"
        val
      else
        throw new Error('Unexpected type!')

    @animate = (attributeKey, designSize, keyframes, removeOldKeyframes = false) ->

      if(designSize == "ALL")
        for designKey in @activeStylesheetKeys
          @animate(attributeKey, designKey, keyframes)
        return

      $elem = if typeof attributeKey == "string" then @select(attributeKey) else attributeKey;
      attr = 'data-ss-' + @activeStylesheetKeys[designSize];

      if removeOldKeyframes
        finalKeyframes = {[time, stringify(val)] for time, val of keyframes}
        attrArray = [thisAttr.name for thisAttr in $elem.get(0).attributes when /data-[0-9]+/.test(thisAttr.name)]
        for thisAttr in attrArray
          $elem.removeAttr(thisAttr)

      else
        # convert the css strings for each keyframe into objects
        # todo: this could be more performant by not objectifying initial
        # keyframes whose values we aren't modifying with newKeyframes.
        newKeyframes   = {[time, objectify(val)]  for time, val of keyframes}
        startKeyframes = {[time, objectify(val)] for time, val of JSON.parse($elem.attr(attr) || "{}")}

        # then merge those objects ($.extend) and stringify the merged version of each
        finalKeyframes = {[time, stringify(val)] for time, val of $.extend(true, startKeyframes, newKeyframes)}

      # finally, stringify the whole finalKeyframes object and dump it in the dom.
      $elem.attr(attr, JSON.stringify(finalKeyframes));

  usesSassVars: !->
    @sassVars = 
      # large design variables
      navCascadeStart: 150
      leftColOut: 150
      headerAnimEnd: 350
      navCascadeEnd:~ -> @headerAnimEnd - 20
      firstPanelUpStart:~ -> @navCascadeEnd - 165 
      interPanelDistance: 100 
      firstPanelExtraPause: 120
      onPanelPause: 85
      firstPanelUpEnd:~ -> @firstPanelUpStart + @interPanelDistance
      largeDesignSectionMarginTop: \5.1875rem

      rsBodyMaxWidth: \1400px
      largeDesignMinWidth: 920
      largeDesignApplies: -> !matchMedia || window.matchMedia("(min-width: 920px) and (min-height:620px) and (max-aspect-ratio: 1500/750)").matches
)