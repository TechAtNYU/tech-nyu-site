define(["flight/component", "mixins/tracksCurrentDesign", "mixins/managesAnimations", "mixins/usesSassVars"], function(defineComponent, tracksCurrentDesign, managesAnimations, usesSassVars){
  return defineComponent(tracksCurrentDesign, managesAnimations, usesSassVars, function(){
    this.defaultAttrs({
      dummyMobileFirstNavLink: 'li:first-child',
      li: 'li',
      list: 'ol',
      calendarLi: '.calendar'
    });

    this.$logo = $('#logo');
    this.transitionPoints = [];

    this.prepSmallNav = function(){
      // make the dropdown by cloning the main nav, horiz nav bar, then...
      this.$dropdown = this.select('list').clone();

      // manipulate its id/class for css.
      this.$dropdown.attr('id', 'nav-dropdown').removeClass('optionList');

      // replace calendar svg with the text contents from it's aria-label.
      // Since Safari doesn't expose .innerHtml on svg elems, we can't do this
      // with a simple $().replace(), unfortunately.
      var $svg = this.$dropdown.find('svg');
      $svg.before($svg.attr('aria-label')).remove();

      // sub in shortNames if available.
      swapLabels(this.$dropdown, 'short');

      // finally, add it to the page and trigger event.
      this.$dropdown.addClass('hidden').appendTo('body');
      this.trigger('smallNavReady');
    };

    this.showDropdown = function(){
      this.$dropdown.removeClass('hidden');
    };

    this.hideDropdown = function(){
      this.$dropdown.addClass('hidden');
    };

    this.setAnimations = function(ev, data) {
      var transitionPoints = data.transitionPoints;
      this.transitionPoints = transitionPoints;

      var smallKeyframes = {},
          largeKeyframes = {},
          smallLogoKeyframes = {},
          largeLogoKeyframes = {},
          largeNavLIKeyframes = {},
          smallNavListKeyframes = {},
          smallCalendarLIKeyframes = {},
          navHeight = this.sassVars.currentNavHeight(),
          lastIndex = transitionPoints.length - 1,
          sassVars = this.sassVars,
          calendarSlideDistance;

      // set this out here, while we have this bound correctly.
      var calendarSlideDistance =
          (this.select('list').width() - this.select('calendarLi').width());

      // animations for the nav bar on the intro screen (large design only)
      largeKeyframes[sassVars.navCascadeEnd] = {
        'top': "0px",
        'background-color': "rgba(0,0,0,0)",
        'box-shadow[sqrt]': "hsla(0, 0%, 25%, 0.7) 0px 0px 0px 0px"
      };

      largeKeyframes[sassVars.headerAnimEnd] = {
        'background-color': sassVars.sectionColorsRGBA[0],
        'box-shadow[sqrt]': "hsla(0, 0%, 25%, 0.6) 0px 0px 2px 1px"
      };

      largeLogoKeyframes[0] = {"fill[sqrt]": sassVars.logoStartColor};
      largeLogoKeyframes[sassVars.navCascadeEnd] = {
        "fill[sqrt]": sassVars.navInactiveTextColors[0]
      };

      // animations for the small design only.
      // By the end of the first transition point, animate the logo and the whole
      // large design nav bar off the screen top so the dropdown takes their place.
      smallLogoKeyframes[transitionPoints[0][0]] =
      smallNavListKeyframes[transitionPoints[0][0]] = {
        'transform': 'translateY(0px)'
      };
      smallLogoKeyframes[transitionPoints[0][1]] =
      smallNavListKeyframes[transitionPoints[0][1]] = {
        'transform': 'translateY(' + (-1 * navHeight) + 'px)'
      };

      // Add the cascade effect to the nav items on the
      // intro screen. Only applies on the large design.
      Array.apply(null, Array(lastIndex + 1)).forEach(function(_, i) {
        var dropStartTime = sassVars.navCascadeStart + i*sassVars.navCascadeItemDelay
          , dropEndTime   = dropStartTime + sassVars.navCascadeDrop
          , holdTime      = dropEndTime + 20 //time post landing before colorFlip
          , colorFlipTime = dropEndTime + sassVars.navCascadeItemDelay;
        
        var preDropPosition = {
          "margin-top[sqrt]": "-80px"
        };

        var droppedPosition = {
          "margin-top[sqrt]": "0px",
          "background-color": sassVars.sectionColorsRGBA[i]
        };

        var holdPosition = { 
          dummy: true 
        };

        var colorFlip = {
          "background-color": sassVars.sectionColorsRGBA[0]
        };

        // on most nav items, we flip their color to the starting color after
        // they've fallen. But, for the last nav item only, we must flip its 
        // color as it falls down, since we can't flip it as the next one falls 
        // (there is nothing next).
        if(i === lastIndex) {
          preDropPosition["background-color"] = sassVars.sectionColorsRGBA[i];
          droppedPosition["background-color"] = sassVars.sectionColorsRGBA[0];
        }

        largeNavLIKeyframes[i] = {};
        largeNavLIKeyframes[i][dropStartTime] = preDropPosition;
        largeNavLIKeyframes[i][dropEndTime] = droppedPosition;
        largeNavLIKeyframes[i][holdTime] = holdPosition;

        if(i !== lastIndex) {
          largeNavLIKeyframes[i][colorFlipTime] = colorFlip;
        }
        

        // Pause on the final color at headerAnimEnd, but then, immediately
        // switch the li to transparent, so that we can change the whole
        // navbar's bg color visually without having to set each li's color.
        largeNavLIKeyframes[i][sassVars.headerAnimEnd] = colorFlip;
        largeNavLIKeyframes[i][sassVars.headerAnimEnd+1] = {
          "background-color": sassVars.sectionColorsRGBA[0].replace(/1\)$/, "0)") // replace alpha.
        };
      });
      

      // add animations for each section.
      transitionPoints.forEach(function(keyframePair, i) {
        var start = keyframePair[0]
          , end = keyframePair[1];

        smallKeyframes[start] = "dummy: true";
        smallKeyframes[end] = {
          "background-color": sassVars.sectionColorsRGBA[i],
          "color": sassVars.navInactiveTextColors[i],
          "fill": sassVars.navInactiveTextColors[i]
        };

        // skipping the first section for these animations b/c
        // they're special cased above for small and large designs
        if(i !== 0) {
          // change the large nav bar color and the logo color
          largeKeyframes[end - sassVars.colorChangeLength] = "dummy: true";
          largeKeyframes[end] = {
            "background-color": sassVars.sectionColorsRGBA[i],
            "color": sassVars.navInactiveTextColors[i],
            "fill": sassVars.navInactiveTextColors[i]
          };
          largeLogoKeyframes[end - sassVars.colorChangeLength] = "dummy: true;";
          largeLogoKeyframes[end] = {
            "fill": sassVars.navInactiveTextColors[i]
          };

          // in the small design, we have to not only animate
          // the color, but also the naviation text
          smallNavListKeyframes[start] = {'dummy': 'true'};
          smallNavListKeyframes[end] = {
            'transform': 'translateY(' + (i + 1) * -1 * navHeight + 'px)'
          };
        }

        // configure the special left-sliding animation for the calendar icon
        if (i !== lastIndex) {
          smallCalendarLIKeyframes[start] = {
            'transform': 'translate(0px,' + i * navHeight + 'px)'
          };
          smallCalendarLIKeyframes[end] = {
            'transform': 'translate(0px,' + (i + 1) * navHeight + 'px)'
          };
        }
        else {
          smallCalendarLIKeyframes[start - 1] = "dummy:true;";
          smallCalendarLIKeyframes[start] = {
            'transform': 'translate(0px, ' + i * navHeight + 'px)'
          }
          smallCalendarLIKeyframes[end] = {
            'transform': 'translate(' + -1 * calendarSlideDistance + ', ' + (i + 1) * navHeight + 'px)'
          };
        }
      });

      // we use true as the fourth arg here to replace old animations,
      // since all of these ones depend on the section tranistion points.
      this.animate(this.$node, 'LARGE', largeKeyframes, true);
      this.animate(this.$logo.find('svg'), 'LARGE', largeLogoKeyframes, true);
      this.animate(this.$node, 'SMALL', smallKeyframes, true);
      this.animate(this.$logo, 'SMALL', smallLogoKeyframes, true);
      this.animate(this.select('list'), 'SMALL', smallNavListKeyframes, true);
      this.animate(this.select('calendarLi'), 'SMALL', smallCalendarLIKeyframes, true);

      var self = this;
      this.select('li').each(function(i) {
        self.animate($(this), 'LARGE', largeNavLIKeyframes[i], true);
      });

      this.trigger('animationsChange', { keframesOnly: true });
    };

    this.handleNavClick = function(ev, data){
      // only do something special for the small design. And, if we're
      // dealing with the calendar, only show the dropdown if we're on the
      // calendar screen (i.e. let the calendar shortcut take the user straight
      // to the calendar screen).
      var $targetLi = $(ev.currentTarget).parent();
      if (this.currDesignMode !== 'LARGE' && (!$targetLi.hasClass('calendar') || $targetLi.hasClass('active') || ev.target.attributes.id === 'logo')) {
        this.showDropdown();
        return false;
      }
      // else, just return nothing which let's the click proceed normally.
    };

    this.setNavText = function(){
      if (this.oldDesignMode !== this.currDesignMode) {
        return swapLabels(this.select('list'), this.currDesignMode === 'LARGE' ? 'orig' : 'short');
      }
    };


    function swapLabels($list, newLabels){
      var attr= 'data-' + newLabels + 'name';
      return $list.find('li[' + attr + ']').each(function(){
        return $(this).find('a').html(this.getAttribute(attr));
      });
    }

    this.after('initialize', function(){
      this.prepSmallNav();
      this.on(document, 'designModeChange', this.setNavText);
      this.on(window, 'sectionsTransitionPointsChange', this.setAnimations);
      this.on(this.select('li').find('a').add('#logo'), 'click', this.handleNavClick);
      this.on(document, 'click', this.hideDropdown);
    });
  });
});
