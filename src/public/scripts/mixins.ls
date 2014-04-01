define(
  managesAnimations: !->
    @_activeStylesheetKeys = 
      LARGE: 11

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

    @animate = (attributeKey, designSize, keyframes) ->
      elem = @select(attributeKey);
      attr = 'data-ss-' + @_activeStylesheetKeys[designSize];
      data = JSON.parse(elem.attr(attr) || "{}");

      # convert the css strings for each keyframe into objects
      # todo: this could be more performant by not objectifying initial
      # keyframes whose values we aren't modifying with newKeyframes.
      startKeyframes = {[time, objectify(val)] for time, val of data}
      newKeyframes = {[time, objectify(val)]  for time, val of keyframes};

      # then merge those objects ($.extend) and stringify the merged version of each
      finalKeyframes = {[time, stringify(val)] for time, val of $.extend(true, startKeyframes, newKeyframes)}
      
      # finally, stringify the whole finalKeyframes object and dump it in the dom.
      elem.attr(attr, JSON.stringify(finalKeyframes));

  usesSassVars: !->
    @sassVars = 
      navCascadeStart: 150
      leftColOut: 150
      headerAnimEnd: 350
      navCascadeEnd:~ -> @headerAnimEnd - 20;
)