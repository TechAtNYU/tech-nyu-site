define(
  managesAnimations: !->
    @_activeStylesheetKeys = 
      LARGE: 11

    @animate = (attributeKey, designSize, keyframes) ->
      elem = @select(attributeKey);
      attr = 'data-ss-' + @_activeStylesheetKeys[designSize];
      data = JSON.parse(elem.attr(attr) || "{}");

      process = (val) ->
        if typeof val == "string"
          ret = {}
          splitArr = val.split(':')

          for property, thisIndex in splitArr by 2
            value = splitArr[thisIndex+1]
            ret[property] = if value.charAt(value[*-1]) != ";" then value + ';' else value;

          ret

        else if typeof! val == "Array"
          val.reduce(((previous, current) -> $.extend(previous, process(current))), {})
        
        else if typeof! val == "Object"
          val

      keyframes = {[time, process(val)]  for time, val of keyframes};
      # to do: merge each keyframe, don't overwrite it (causing breakage).
      #Object.keys(val).reduce(((prev, key) -> prev + key + ':' + val[key] + ';'), '');
      elem.attr(attr, JSON.stringify($.extend(true, data, keyframes)));

  usesSassVars: !->
    @sassVars = 
      navCascadeStart: 150
      leftColOut: 150
      headerAnimEnd: 350
      navCascadeEnd:~ -> @headerAnimEnd - 20;
)