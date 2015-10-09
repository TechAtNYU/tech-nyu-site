define(function() {
  return function() {
    this.activeStylesheetKeys = {
      LARGE: '01',
      SMALL: '10'
    };

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
    var objectify = function(val){
      var propValStrings;
      if (typeof val === "string") {
        val = val.trim();
        propValStrings = (val.charAt(val.length - 1) === ";" ? val.substring(0, val.length - 1) : val).split(";");

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
    };

    /**
     * takes an object of the form produced by objectify and turns it back
     * into a string of the form objectify would accept. The two functions are
     * inverses (except that stringify never returns an array).
     */
    var stringify = function(val){
      if (brandIsObject(val)) {
        return Object.keys(val).reduce(function(prev, key){
          return prev + key + ':' + val[key] + ';';
        }, '');
      }
      else if (typeof val === "string") {
        return val;
      }
      else {
        throw new Error('Unexpected type!');
      }
    };

    this.animate = function(selectorAttributeOr$Elem, designSize, keyframes, removeOldKeyframes) {
      var $elem, attr, finalKeyframes, newKeyframes, startKeyframes,
          this$ = this, Array$reduce = Array.prototype.reduce, ref$, time, val;

      // Default removeOldKeyframes to false.
      removeOldKeyframes == null && (removeOldKeyframes = false);

      if (designSize === "ALL") {
        this.activeStylesheetKeys.forEach(function(designKey) {
          this$.animate(selectorAttributeOr$Elem, designKey, keyframes);
        });
        return;
      }

      $elem = typeof selectorAttributeOr$Elem === "string" ?
        this.select(selectorAttributeOr$Elem) :
        selectorAttributeOr$Elem;

      attr = 'data-ss-' + this.activeStylesheetKeys[designSize];

      if (removeOldKeyframes) {
        finalKeyframes = {};
        for (time in keyframes) {
          finalKeyframes[Math.round(time)] = stringify(keyframes[time]);
        }

        // On the first loop, find all the attrs to remove, then delete them on
        // the second loop (since idk if we can delete them while we're looping)
        // Below, NodeList isn't a true array, so we need this Array$reduce BS.
        Array$reduce.call($elem.get(0).attributes, function(toRemove, thisAttr) {
          if (/^data-\-?[0-9]+$/.test(thisAttr.name)) {
            toRemove.push(thisAttr.name);
          }
          return toRemove;
        }, []).forEach(function(toRemove) {
          $elem.removeAttr(toRemove);
        });
      }

      else {
        // convert the css strings for each keyframe into objects
        // todo: this could be more performant by not objectifying initial
        // keyframes whose values we aren't modifying with newKeyframes.
        newKeyframes = {};
        for (time in keyframes) {
          newKeyframes[Math.round(time)] = objectify(keyframes[time]);
        }

        startKeyframes = {};
        for (time in ref$ = JSON.parse($elem.attr(attr) || "{}")) {
          startKeyframes[time] = objectify(ref$[time]);
        }

        // then merge those objects ($.extend) and stringify
        // the merged version of each
        finalKeyframes = {};
        for (time in ref$ = $.extend(true, startKeyframes, newKeyframes)) {
          finalKeyframes[time] = stringify(ref$[time]);
        }
      }

      // finally, stringify the whole finalKeyframes object & dump it in the dom.
      return $elem.attr(attr, JSON.stringify(finalKeyframes));
    };
  };
});

/**
 * @param {any} arg The argument to test
 * @return {boolean} Whether the argument's internal [[Class]] attribute is Object.
 */
function brandIsObject(arg) {
  return Object.prototype.toString.call(arg).slice(8, -1) === "Object";
}

function isArray(arg) {
  return Array.isArray(arg);
}
