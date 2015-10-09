define(["flight/component", "mixins/managesAnimations", "mixins/usesSassVars"], function(defineComponent, managesAnimations, usesSassVars) {

  return defineComponent(managesAnimations, usesSassVars, function(){
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
      this.setupAnimations();
    });
  });
});
