define(["flight/component", "mixins/tracksCurrentDesign", "mixins/managesAnimations", "mixins/usesSassVars"], function(defineComponent, tracksCurrentDesign, managesAnimations, usesSassVars) {

  return defineComponent(tracksCurrentDesign, managesAnimations, usesSassVars, function(){
    this.defaultAttrs({
      isHomeSection: false
    });

    this.$window = $(window);
    this.$content = $('#content');
    this.$info = $('#info');

    this.setImage = function(ev, data){
      var imgURI = (this.currDesignMode === 'SMALL' || this.$window.width() > 1270) ?
        this.$node.attr('data-wide') :
        this.$node.attr('data-narrow');

      this.$node.css('background-image', 'url(' + imgURI + ')');
    };

    this.positionIntroScreenBg = function(ev, data){
      if (this.currDesignMode === 'LARGE') {
        this.$node.insertAfter(this.$content);
      } 
      else {
        this.$node.insertBefore(this.$info);
      }
    };

    // We'll only run this if this component
    // represents the intro screen's background image.
    this.animateIntroScreenBg = function() {
      var bgKeyframes = {};
      bgKeyframes[0] = { "right[linear]": "0%", "top[linear]": "0%"};
      bgKeyframes[this.sassVars.navCascadeEnd + 50] = {
        "right[linear]": "-100%", "top[linear]": "100%"
      };

      this.animate(this.$node, 'LARGE', bgKeyframes);
      this.trigger('animationsChange', { keframesOnly: true });
    }

    this.after('initialize', function() {
      this.setImage();
      this.on(window, "resize", this.setImage);

      if(this.attr.isHomeSection) {
        this.positionIntroScreenBg();
        this.animateIntroScreenBg();
        this.on(document, 'designModeChange', this.positionIntroScreenBg);
      }
    });
  });
});
