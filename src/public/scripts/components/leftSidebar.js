define(["flight/component", "mixins"], function(defineComponent, mixins){

  return defineComponent(mixins.tracksCurrentDesign, mixins.managesAnimations, mixins.usesSassVars, function(){
    this.defaultAttrs({
      upcoming: '#upcoming',
      tagline: '#tagline',
      logo: '#logo',
      taglineWrapper: '#info',
      moreEventsButton: '#more-events'
    });

    this.setupAnimations = function(){
      var $window, upcoming, logo, tagline, taglineWrapper, upcomingHeight,
        windowHeight, windowWidth, taglineHeight, bodyMaxWidth, logoMarginLeft,
        ref$, logoTop, upcomingAnims = {}, taglineWrapperAnims = {}, logoAnims = {};

      if (this.designSizeKey === 'LARGE' || !this.designSizeKey) {
        $window  = $(window);
        upcoming = this.select('upcoming');
        logo     = this.select('logo');
        tagline  = this.select('tagline');
        taglineWrapper = this.select('taglineWrapper');

        // variables for the large design
        windowWidth    = $window.outerWidth();
        windowHeight   = $window.outerHeight();
        taglineHeight  = tagline.outerHeight();
        upcomingHeight = upcoming.outerHeight();
        bodyMaxWidth   = parseInt(this.sassVars.rsBodyMaxWidth);
        logoMarginLeft = (ref$ = (bodyMaxWidth - windowWidth) / 2) < 0 ? ref$ : 0;
        logoTop = (windowHeight - upcomingHeight - taglineHeight) / 2;


        this.animate('tagline', 'LARGE', {
          0:  { "top[sqrt]": logoTop + 'px'},
          10: { dummy: true /* so skrollr refreshes */}
        });


        upcomingAnims[0] = {
          "bottom[sqrt]": "0px"
        };
        upcomingAnims[this.sassVars.leftColOut] = {
          "bottom[sqrt]": -1 * upcomingHeight + 'px'
        };
        this.animate('upcoming', 'LARGE', upcomingAnims);


        taglineWrapperAnims[0] = {
          "left[sqrt]": '0px',
          "bottom": upcomingHeight + 'px'
        };
        taglineWrapperAnims[this.sassVars.leftColOut] = {
          "left[sqrt]": -1 * taglineWrapper.outerWidth() + 'px'
        }
        this.animate('taglineWrapper', 'LARGE', taglineWrapperAnims);

        logoAnims[0] = {
          "top[sqrt]": logoTop + 'px',
          "margin-left[sqrt]": logoMarginLeft + 'px',
          "width[cubedroot]": this.sassVars.logoStartWidth,
          "padding-left": this.sassVars.logoStartPadding,
          "padding-right": this.sassVars.logoStartPadding
        };
        logoAnims[this.sassVars.navCascadeEnd - 50] = {
          "top[sqrt]": '10px',
          "margin-left[sqrt]": '0px',
          "width[cubedroot]": this.sassVars.logoEndWidth,
          "padding-left": this.sassVars.logoEndPadding,
          "padding-right": this.sassVars.logoEndPadding
        };
        this.animate('logo', 'LARGE', logoAnims);

        this.trigger('animationsChange', { keframesOnly: true });
      }
    };

    this.handleDigestDetailsShown = function(ev, data) {
      if (this.designSizeKey === 'LARGE') {
        this.select('tagline').add(this.select('logo')).animate({
          marginTop: "-=" + data.height
        }, 140);
      }
    };

    this.handleDigestDetailsHidden = function(ev, data) {
      if (this.designSizeKey === 'LARGE') {
        this.select('tagline').add(this.select('logo')).animate({
          marginTop: "+=" + data.height
        }, 140);
      }
    };

    this.handleMoreEventsButton = function(ev, data){
      ev.preventDefault();
      return $('a[href=#event-calendar]').get(0).click();
    };

    return this.after('initialize', function(){
      $(document).one('designModeChange', this.setupAnimations.bind(this));
      this.on(window, "resize", this.setupAnimations);
      this.on(this.$node, "digestDetailsShown", this.handleDigestDetailsShown);
      this.on(this.$node, "digestDetailsHidden", this.handleDigestDetailsHidden);
      this.on(this.select('moreEventsButton'), 'click', this.handleMoreEventsButton);
    });
  });
});
