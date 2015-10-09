define(["flight/component", "mixins", "skrollr-menu"], function(defineComponent, mixins, skrollrMenu){
  return defineComponent(mixins.tracksCurrentDesign, function() {
    this.defaultAttrs({
      navList: 'nav ol',
      upcoming: '#upcoming',
      taglineWrapper: '#info',
      nav: 'nav',
      skrollrBody: '#skrollr-body',
      dropdownNav: '#nav-dropdown',
      eventsTriggeringRefresh: ''
    });
    /*
    this.transitionPoints;
    this.dropdownNav;
    this.s;

    this.configureSkrollr = function() {
      var this$ = this;

      // We need to change which nav li has the .active class on scroll, but no
      // way to do that except as a skrollr listener, since real scroll events
      // are never fired on mobile devices (and wouldn't have the right data
      // anyway). this listener will depend on some globals, which we set above.
      this.s.on('render', function(data) {
        var colorToInherit = this$.navList.css('color');
        var transitionsWithEnd = this$.transitionPoints.concat([[Infinity, Infinity]]);
        var scrollTop = data.curTop;
        var activeIndex = 0, section;

        for(var i = 0, len = transitionsWithEnd.length; i < len; ++i) {
          section = transitionsWithEnd[i];
          if (scrollTop < section[0]) {
            activeIndex = i - 1;
            if (activeIndex < 0) {
              activeIndex = undefined;
            }
            break;
          }
        }

        if (activeIndex !== undefined) {
          this$.navList.find('li').removeClass('active').eq(activeIndex).addClass('active');
          return this$.dropdownNav.find('li').removeClass('active').eq(activeIndex).addClass('active');
        }
      });

      skrollrMenu.init(this.s, {
        handleLink: function(linkElm) {
          if (this$.transitionPoints) {
            return this$.transitionPoints[$(linkElm).attr('data-transitionpoint')][1];
          }
        }
      });

      return this.s.refresh();
    };

    this.moveElementsForMobileSkrollr = function() {
      if (this.oldDesignSizeKey !== this.designSizeKey) {
        if (this.designSizeKey === 'LARGE') {
          this.select('taglineWrapper').insertBefore(this.select('nav'));
          this.select('upcoming').insertAfter(this.select('nav'));
        }
        else {
          this.select('taglineWrapper')
            .add(this.select('upcoming'))
            .prependTo(this.select('skrollrBody'));
        }

        if(this.s) {
          this.s.refresh();
        }
      }
    };

    this.after('handleDesignModeChange', this.moveElementsForMobileSkrollr);

    return this.after('initialize', function(){
      var this$ = this;
      this.navList = this.select('navList');
      this.s = this.attr.skrollrInstance;

      $(document).on(this.attr.eventsTriggeringRefresh, function(){
        return this$.s.refresh();
      });

      return $(document).on('sectionsTransitionPointsChange', function(ev, data){
        var transitionPoints = data.transitionPoints;
        this$.transitionPoints = transitionPoints;

        if (this$.dropdownNav) {
          return $(document).trigger('readyForSkrollr');
        }
      }).on('smallNavReady', function(ev, data){
        this$.dropdownNav = this$.select('dropdownNav');

        if (this$.transitionPoints) {
          return $(document).trigger('readyForSkrollr');
        }
      }).one('readyForSkrollr', this.configureSkrollr.bind(this));
    });*/
  });
});
