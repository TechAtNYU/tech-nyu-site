define(function() {
  return function() {

    /**
     * This function stores the provided animation instructions for a set of elements (and
     * specified for one or more design modes) in the DOM as a blob of JSON that lives as a
     * data- attribute on each provided element. It doesn't actually do anything with those
     * attributes, though; another component must activate those instructions for skrollr.
     * 
     * @param {string|jQuery} attributeOr$Elems - jQueried collection of elements, or a string 
     *   that'll be used to look up a selector from the component's attributes (attributes as 
     *   in https://github.com/flightjs/flight/blob/master/doc/base_api.md#this.attributes)
     *   which will then be used to find a collection of elements under the component's node.
     *
     * @param {string|string[]} designModes - Which design mode or modes (as in, the mode 
     *   names emitted by the designModeChange event) should the provided keyframes apply to.
     *
     * @param {object} keyframes - Keyframes for the animations. The key should be the point
     *   at which the keyframe kicks in (usually an integer scroll position, though skrollr
     *   allows other types), and the value should be a string or object (in the form
     *   accepted by stringify) of animation instructions to apply at that keyframe.
     *
     * @param {boolean} removeExistingKeyframes - Whether to remove any existing animations for
     *   this element at the provided design modes. Defaults to false.
     */
    this.setAnimations = function(attributeOr$Elems, designModes, keyframes, removeExistingKeyframes) {
      // Default removeExistingKeyframes to false while casting it.
      removeExistingKeyframes = Boolean(removeExistingKeyframes);

      // Ensure designModes is an array for consistency
      // and convert to lowercase (as in conventional in attribute names)
      designModes = (designModes.length ? designModes : [designModes]).map(function(it) { 
        return it.toLowerCase(); 
      });

      // Find the targeted elements
      var $elems = typeof attributeOr$Elems === "string" ? 
        this.select(attributeOr$Elems) :
        attributeOr$Elems;

      // proces our keyframes upfront, so we don't have to do it in a loop below.
      // Stringify always helps since we ultimately want strings, and objectify is 
      // needed if we're keeping the old keyframes (since we need the keyframes as 
      // an object to merge in w/ the element's existing ones).
      var time, timeRounded;
      var stringifiedKeyframes = {};
      var objectifiedKeyframes = {};
      for (time in keyframes) {
        timeRounded = Math.round(time);
        stringifiedKeyframes[timeRounded] = stringify(keyframes[time]);
        if(!removeExistingKeyframes) {
          objectifiedKeyframes[timeRounded] = objectify(keyframes[time]);
        }
      }

      $elems.each(function() {
        var elm = this;
        designModes.forEach(function(modeName) {
          // attribute name that holds the animations for this mode.
          var attr = 'data-animations-mode-' + modeName
            , existingKeyframes, finalKeyframes;

          // Get a merged version of the final keyframes, with the CSS
          // properties stringified. If we're removingExistingKeyframes,
          // then this is simply stringifiedKeyframes. 
          if(removeExistingKeyframes) {
            finalKeyframes = stringifiedKeyframes;
          }

          // But, if we aren't we have to do a bit of merging. We do this 
          // by finding all the new keyframes for which an existing keyframe 
          // also exists; objectifying the existing keyframe's animations 
          // instructions; merging it with the objectified new instructions;
          // and stringifying the result.
          else {
            existingKeyframes = JSON.parse(elm.getAttribute(attr) || "{}");
            finalKeyframes = existingKeyframes;

            for(timeRounded in objectifiedKeyframes) {
              if(timeRounded in existingKeyframes) {
                finalKeyframes[time] = stringify($.extend(
                  objectify(existingKeyframes[timeRounded]), objectifiedKeyframes[timeRounded]
                ));
              }
              else {
                finalKeyframes[timeRounded] = stringifiedKeyframes[timeRounded];
              }
            }
          }

          elm.setAttribute(attr, JSON.stringify(finalKeyframes))
        });
      });
    }
  }
});

/**
 * Takes some CSS declarations (see the first argument) and and turns them
 * into an object, like: {'top': '20px', 'bottom':'200px'}. Any semicolons
 * are stripped. If you pass in an object, it'll assume the values are
 * already in the correct form (i.e. without trailing semicolons) and simply
 * return the object as is.
 *
 * @param {string|string[]|Object} [val] One or more CSS declarations as a
 * string (e.g. "top:20px; bottom:10x") or an array of strings (e.g.
 * ["top:2px", "bottom:1px"]). It can also take an object like {top: "2px"}.
 *
 * @returns {object} The declarations from value in a key-value object.
 */
function objectify(val) {
  var propValStrings;
  if (typeof val === "string") {
    val = val.trim();
    propValStrings = (
      val.charAt(val.length - 1) === ";" ? val.substring(0, val.length - 1) : val
    ).split(";");

    return propValStrings.reduce(function(prev, propValString) {
      var ref$ = propValString.split(':');
      var property = ref$[0], value = ref$[1];

      prev[property] = value;
      return prev;
    }, {});
  }

  else if (isArray(val)) {
    return val.reduce(function(previous, current){
      return $.extend(previous, objectify(current));
    }, {});
  }

  else if (brandIsObject(val)) {
    return val;
  }

  else {
    throw new Error('Unexpected type!');
  }
}

/**
 * takes an object of the form produced by objectify and turns it back
 * into a string of the form objectify would accept. The two functions are
 * inverses (except that stringify never returns an array).
 */
function stringify(val) {
  if (brandIsObject(val)) {
    return Object.keys(val).reduce(function(prev, key){
      return prev + key + ':' + val[key] + ';';
    }, '');
  }
  else if (typeof val === "string") {
    // add a semicolon onto the end to make sure we can append 
    // more properties later without corruption
    if(val.charAt(val.length - 1) != ';') {
      val += ';';
    }
    return val;
  }
  else {
    throw new Error('Unexpected type!');
  }
}