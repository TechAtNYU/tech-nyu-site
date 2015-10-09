/**
 * This component detects whether the small or large design is in effect
 * and triggers a tnyu-designModeChange event whenever the design mode 
 * changes. It listens to resize events to detect changes.
 */
define(["flight/component", "mixins"], function(defineComponent, mixins){
  return defineComponent(function(){
    this.oldDesignMode;
    this.designMode;

    function isLarge() {
      var largeMq = "(min-width: 920px) and (min-height:620px) and (max-aspect-ratio: 1530/750)";
      return (!window.matchMedia || window.matchMedia(largeMq).matches);
    };

    this.updateDesignMode = function(){  
      
      
      var newMode = {};
      this.oldDesignMode = this.designMode;
      this.designMode = isLarge() ? 'LARGE' : 'SMALL';

      if (this.oldDesignMode !== this.designMode) {
        newMode.oldDesignMode = this.oldDesignMode;
        newMode.designMode = this.designMode;
        this.trigger('tnyu-designModeChange', newMode);
      }
    };

    return this.after('initialize', function(){
      this.getDesignMode();
      this.on(window, 'resize', this.updateDesignMode);
    });
  });
});
