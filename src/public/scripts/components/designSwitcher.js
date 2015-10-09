define(["flight/component", "mixins"], function(defineComponent, mixins){
  return defineComponent(mixins.usesSassVars, function(){
    this.defaultAttrs({
      sectionsSelector: '.objective'
    });

    // Inititialize this.$sections.
    // The sections' height can determine the design mode.
    this.$sections;

    // Note: code expects that on the first calculation
    // of the design mode, oldDesignSizeKey and oldScrollMode
    // key will be == null. So don't fuck with these defaults.
    this.oldDesignSizeKey;
    this.oldScrollMode;
    this.designSizeKey;
    this.scrollMode;

    this.getDesignSizeKey = function(){
      var largeMq = "(min-width: 920px) and (min-height:620px) and (max-aspect-ratio: 1530/750)";
      return (!matchMedia || window.matchMedia(largeMq).matches) ? 'LARGE' : 'SMALL';
    };

    this.getScrollMode = function(){
      return "scroll";
    };

    this.getDesignMode = function(){
      var newMode = {};
      this.oldScrollMode = this.scrollMode;
      this.oldDesignSizeKey = this.designSizeKey;
      this.designSizeKey = this.getDesignSizeKey();
      this.scrollMode = this.getScrollMode();
      if (this.oldScrollMode !== this.scrollMode || this.oldDesignSizeKey !== this.designSizeKey) {
        newMode.oldScrollMode = this.oldScrollMode;
        newMode.scrollMode = this.scrollMode;
        newMode.oldDesignSizeKey = this.oldDesignSizeKey;
        newMode.designSizeKey = this.designSizeKey;
        return this.trigger('designModeChange', newMode);
      }
    };

    this.after('initialize', function(){
      this.$sections = this.select('sectionsSelector');
      this.getDesignMode();
      this.on(window, 'resize', this.getDesignMode);
      this.on(document, 'sectionContentModified', this.getDesignMode);
    });
  });
});
