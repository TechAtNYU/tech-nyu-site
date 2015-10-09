var designMode, oldDesignMode;
define({
  
  tracksCurrentDesign: function(){
    this.after('initialize', function(){
      this.on(document, 'tnyu-designModeChange', this.handleDesignModeChange);
    });

    this.oldDesignMode; this.designMode;

    this.handleDesignModeChange = function(ev, data) {
      this.oldDesignMode = data.oldDesignMode;
      this.designMode = data.designMode;
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
