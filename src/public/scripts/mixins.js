define({
  managesAnimations: function() {
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
  },

  tracksCurrentDesign: function(){
    this.after('initialize', function(){
      this.on(document, 'designModeChange', this.handleDesignModeChange);
    });

    this.oldScrollMode; this.scrollMode; this.oldDesignSizeKey; this.designSizeKey;

    this.handleDesignModeChange = function(ev, data) {
      this.oldScrollMode = data.oldScrollMode;
      this.scrollMode = data.scrollMode;
      this.oldDesignSizeKey = data.oldDesignSizeKey;
      this.designSizeKey = data.designSizeKey;
    };
  },

  usesSassVars: function(){
    var this$ = this;

    this.sassVars = {
      // large design animation variables
      leftColOut: 150,
      headerAnimEnd: 350,

      // navCascadeStart + navCascadeItemDelay*5 + navCascadeDrop 
      // must add up to navCascadeEnd
      navCascadeStart: 150,
      navCascadeItemDelay: 32,
      navCascadeDrop: 20,
      get navCascadeEnd() {
        return this.headerAnimEnd - 20;
      },
  
      get firstPanelUpStart() {
        return this.navCascadeEnd - 165;
      },
      postIntroPause: 120,
      colorChangeLength: 35,
      get firstPanelUpEnd() {
        return this.firstPanelUpStart + 100;
      },

      outerPaddingPx: "25px",
      outerPaddingRem: parseInt(this.outerPaddingPx, 10)/16 + "rem",

      // these values just copied from the computed sass.
      // will need to be cleaned up later, but what matters 
      // for now is getting all the animations out of sass.
      // the startPadding is the rem version of $outerPaddingPx+2px,
      // while the endPadding is simply the rems for $outerPaddingPx.
      logoStartWidth: "10.52632em",
      logoStartPadding: "1.6875rem",
      logoEndWidth: "6.05263em",
      logoEndPadding: "1.5625rem",

      paginatedMarginTop: '5.1875rem',
      rsBodyMaxWidth: '1400px',

      largeDesignMinWidth: 920,
      logoStartColor: "hsl(0, 0%, 95%)",
      sectionColors: ["hsl(14, 68%, 51%)", "hsl(43, 90%, 50%)", "hsl(276, 48%, 35%)", "hsl(140, 74%, 37%)", "hsl(218, 66%, 36%)", "hsl(0, 0%, 10%)"],
      sectionColorsRGBA: ["rgba(215, 85, 45, 1)", "rgba(242, 177, 13, 1)", "rgba(98, 46, 132, 1)", "rgba(25, 164, 71, 1)", "rgba(31, 76, 152, 1)", "rgba(26, 26, 26, 1)"],
      navInactiveTextColors: ["hsl(13, 2%, 16%)", "hsl(42, 0%, 16%)", "hsl(278, 3%, 60%)", "hsl(140, 0%, 20%)", "hsl(214, 4%, 65%)", "hsl(0, 0%, 58%)"]
    };

    this.sassVars.paginatedMarginTopPx = function() {
      return parseFloat(this$.sassVars.paginatedMarginTop) * parseFloat($('html').css('font-size'));
    };

    this.sassVars.currentNavHeight = function() {
      return $('nav').outerHeight();
    };
  }
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
