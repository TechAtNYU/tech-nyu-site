define(["flight/component", "mixins"], function(defineComponent, mixins){

  return defineComponent(mixins.tracksCurrentDesign, mixins.managesAnimations, mixins.usesSassVars, function(){
    this.defaultAttrs({
      isHomeSection: false
    });

    this.$window = $(window);
    this.$content = $('#content');
    this.$info = $('#info');

    this.setImage = function(ev, data){
      var imgURI = (this.designSizeKey === 'SMALL' || this.$window.width() > 1270) ?
        this.$node.attr('data-wide') :
        this.$node.attr('data-narrow');

      this.$node.css('background-image', 'url(' + imgURI + ')');
    };

    this.position = function(ev, data){
      if (this.attr.isHomeSection) {
        if (this.designSizeKey === 'LARGE') {
          return this.$node.insertAfter(this.$content);
        } else {
          return this.$node.insertBefore(this.$info);
        }
      }
    };

    // We'll only run this if this component
    // represents the intro screen's background image.
    this.animateIntroScreenBgImage = function() {
      var bgKeyframes = {};
      if(this.attr.isHomeSection) {
        bgKeyframes[0] = { "right[linear]": "0%", "top[linear]": "0%"};
        bgKeyframes[this.sassVars.navCascadeEnd + 50] = {
          "right[linear]": "-100%", "top[linear]": "100%"
        };

        this.animate(this.$node, 'LARGE', bgKeyframes);
        this.trigger('animationsChange', { keframesOnly: true });
      }
    }

    this.after('handleDesignModeChange', this.position);
    this.after('initialize', function() {
      this.animateIntroScreenBgImage();
      $(document).one('designModeChange', this.setImage.bind(this));
      this.on(window, "resize", this.setImage);
    });
  });
});
