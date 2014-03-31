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
          if val[*-1] == ';' then val else val + ';'

        else if typeof! val == "Array"
          val.reduce(((previous, current) -> previous + process(current)), '')
        
        else if typeof! val == "Object"
          Object.keys(val).reduce(((prev, key) -> prev + key + ':' + val[key] + ';'), '');

      keyframes = {[time, process(val)]  for time, val of keyframes};
      elem.attr(attr, JSON.stringify($.extend(data, keyframes)));

  usesSassVars: !->
    @sassVars = 
      navCascadeStart: 150
      leftColOut: 150
      headerAnimEnd: 350
      navCascadeEnd:~ -> @headerAnimEnd - 20;
)