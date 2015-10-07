define(["flight/component", "mixins"], function(defineComponent, mixins){

  return defineComponent(mixins.tracksCurrentDesign, mixins.managesAnimations, mixins.usesSassVars, function(){
    this.setupAnimations = function() {
      var bgKeyframes = {};
      bgKeyframes[this.sassVars.firstPanelUpStart] = {
        "opacity": 1
      };
      bgKeyframes[this.sassVars.firstPanelUpEnd] = {
        "opacity": 0
      };

      this.animate(this.$node, 'LARGE', bgKeyframes);
      this.trigger('animationsChange', { keframesOnly: true });
    }

    this.after('initialize', function() {
      $(document).one('designModeChange', this.setupAnimations.bind(this));
    });
  });
});
