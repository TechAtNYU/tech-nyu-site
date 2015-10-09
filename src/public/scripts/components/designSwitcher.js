define(["flight/component", "mixins/tracksCurrentDesign", "mixins/usesSassVars"], function(defineComponent, tracksCurrentDesign, usesSassVars){
  return defineComponent(tracksCurrentDesign, usesSassVars, function(){
    this.defaultAttrs({
      sectionsSelector: '.objective'
    });

    // Inititialize this.$sections.
    // The sections' height can determine the design mode.
    this.$sections;

    this.getCurrDesignMode = function(){
      var largeMq = "(min-width: 920px) and (min-height:620px) and (max-aspect-ratio: 1530/750)";
      return (!matchMedia || window.matchMedia(largeMq).matches) ? 'LARGE' : 'SMALL';
    };

    this.getDesignMode = function(){
      var newMode = {};
      this.oldDesignMode = this.currDesignMode;
      this.currDesignMode = this.getCurrDesignMode();

      if (this.oldDesignMode !== this.currDesignMode) {
        newMode.oldDesignMode = this.oldDesignMode;
        newMode.currDesignMode = this.currDesignMode;
        return this.trigger('designModeChange', newMode);
      }
    };

    this.after('initialize', function() {
      this.$sections = this.select('sectionsSelector');
      this.getDesignMode();
      this.on(window, 'resize', this.getDesignMode);
      this.on(document, 'sectionContentModified', this.getDesignMode);
    });
  });
});