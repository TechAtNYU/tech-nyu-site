define(["flight/component", "mixins"], function(defineComponent, mixins){

  return defineComponent(mixins.tracksCurrentDesign, mixins.managesAnimations, mixins.usesSassVars, function(){
    this.defaultAttrs({
      sectionsSelector: '.objective'
    });

    this.handleResize = function(){
      this.setSectionAnimations(this.designSizeKey);
    };

    this.getAnimatedOffsetTopForSection = function(i){
      var translateY = this.s.isMobile() ? -1 * this.s.getScrollTop() : 0;

      // + -2*translateY below adjusts for mobile once skrollr's been
      // initialized. In that case, rather than having a positive value for
      // how far we've scrolled down, we have a negative translate value of
      // the same magnitue saying how far the browser should pull the
      // element up, and our pageYOffset (i.e. scrollTop) is zero.
      return this.$sections.eq(i).offset().top + -2 * translateY;
    };

    this.setSectionAnimations = function(designKey){
      var self = this,
          sectionCount = this.$sections.length,
          navHeight = this.sassVars.currentNavHeight(),
          scrollTop = this.$window.scrollTop(),
          wouldBeOffsetTop, firstSectionMarginTop;

      // We'll populate this with scroll offsets representing when each
      // section is coming on screen, when it's fully on screen, etc. This
      // value will be sent as event data, which other components can
      // listen for (e.g. the nav component, for animating colors).
      var sectionTransitionPoints = [];

      // Set the margin on the first section.
      // If we're on a large design, we need to give it a margin top that
      // pushes it past the intro animation, to the point that "would be" it's
      // offset top if the intro screen really took up the height that skrollr
      // acts that it does.
      if(designKey === 'LARGE') {
        wouldBeOffsetTop =
          (this.sassVars.firstPanelUpEnd +
          this.sassVars.paginatedMarginTopPx() +
          this.sassVars.firstPanelExtraPause);

        firstSectionMarginTop = wouldBeOffsetTop + 'px';
      }

      // But on the small design, we need to remove any margin that may have
      // been set from prior mode switches.
      else {
        firstSectionMarginTop = '';
      }

      this.$sections.eq(0).css('margin-top', firstSectionMarginTop);

      this.$sections.each(function(i){
        var sectionOffset = self.getAnimatedOffsetTopForSection(i);
        var sectionAtTop = sectionOffset - navHeight;
        sectionTransitionPoints.push([sectionAtTop - 40, sectionAtTop + 1]);
        self.animate($(this), 'LARGE', {
          0: "position:static;"
        }, true);
      });

      this.trigger('sectionsTransitionPointsChange', {
        transitionPoints: sectionTransitionPoints
      });

      return this.trigger('animationsChange', {
        keframesOnly: true
      });
    };

    return this.after('initialize', function(){
      var this$ = this;
      this.$sections = this.select('sectionsSelector');
      this.s = this.attr.skrollrInstance;
      this.$window = $(window);
      $(document).one('designModeChange', function(){
        return this$.setSectionAnimations(this$.designSizeKey);
      });
      this.on(window, "resize", this.handleResize);
      return this.on(document, 'sectionContentModified', this.handleResize);
    });
  });
});
