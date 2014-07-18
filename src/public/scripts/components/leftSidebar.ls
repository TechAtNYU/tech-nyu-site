define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(mixins.tracksCurrentDesign, mixins.managesAnimations, mixins.usesSassVars, ->
    @defaultAttrs(do
      upcoming: \#upcoming
      tagline: \#tagline
      logo: \#logo
      taglineWrapper: \#info
      moreEventsButton: \#more-events
    )

    @setupAnimations = ->
      if @designSizeKey is \LARGE
        $window  = $(window)
        upcoming = @select('upcoming')
        logo     = @select('logo')
        tagline  = @select('tagline')
        taglineWrapper = @select(\taglineWrapper)

        # variables for the large design
        upcomingHeight = upcoming.outerHeight!
        windowHeight = $window.outerHeight!
        windowWidth  = $window.outerWidth!
        taglineHeight = tagline.outerHeight!
        bodyMaxWidth = parseInt(@sassVars.rsBodyMaxWidth)
        logoMarginLeft = (bodyMaxWidth - windowWidth)/2 <? 0;
        logoTop = (windowHeight - upcomingHeight - taglineHeight)/2;

        @animate(\tagline, \LARGE, {
          0: do
            "top[sqrt]": logoTop + 'px'
          10: do
            dummy: true #so skrollr refreshes.
        })

        @animate(\upcoming, \LARGE, {
          0: "bottom[sqrt]: 0px",
          (@sassVars.leftColOut): 'bottom[sqrt]: '+ -1*upcoming.outerHeight! + 'px'
        })

        @animate(\taglineWrapper, \LARGE, {
          0: do
            "left[sqrt]": \0px
            "bottom": upcomingHeight + \px

          (@sassVars.leftColOut): "left[sqrt]: " + -1*taglineWrapper.outerWidth! + 'px'
        })
        
        @animate(\logo, \LARGE, {
          0: do
            'top[sqrt]': logoTop + 'px'
            'margin-left[sqrt]': logoMarginLeft + 'px'
          (@sassVars.navCascadeEnd - 50): do
            'top[sqrt]': \10px
            'margin-left[sqrt]': \0px
        })

        @trigger('animationsChange', {keframesOnly: true});

    @animationsProxy = @~setupAnimations

    @handleDigestDetailsShown = (ev, data) ->
      if @designSizeKey is \LARGE
        @select(\tagline).add(@select(\logo)).animate({margin-top: "-=" + data.height}, 140, @animationsProxy)

    @handleDigestDetailsHidden = (ev, data) ->
      if @designSizeKey is \LARGE
        @select(\tagline).add(@select(\logo)).animate({margin-top: "+=" + data.height}, 140, @animationsProxy)

    @handleMoreEventsButton = (ev, data) ->
      ev.preventDefault!
      $('a[href=#event-calendar]').get(0).click!

    @after('initialize', ->      
      $(document).one('designModeChange', @~setupAnimations) 
      @on(window, "resize", @setupAnimations);
      @on(@$node, "digestDetailsShown", @handleDigestDetailsShown);
      @on(@$node, "digestDetailsHidden", @handleDigestDetailsHidden);
      @on(@select('moreEventsButton'), 'click', @handleMoreEventsButton);
    )
  )
);