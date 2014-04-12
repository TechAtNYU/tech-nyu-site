define(["flight/component", "mixins", "jquery"], (defineComponent, mixins, $) ->

  defineComponent(->
    @defaultAttrs(do
      upcoming: \#upcoming
      tagline: \#tagline
      logo: \#logo
      taglineWrapper: \#info
    )

    @setupAnimations = ->
      upcoming = @select('upcoming')
      logo     = @select('logo')
      tagline  = @select('tagline')
      taglineWrapper = @select(\taglineWrapper)

      # variables for the large design
      upcomingHeight = @select('upcoming').outerHeight()
      windowHeight = $(window).outerHeight()
      taglineHeight = tagline.outerHeight()
      bodyMaxWidth = parseInt(@sassVars.rsBodyMaxWidth)
      logoMarginLeft = if $(window).outerWidth() > bodyMaxWidth then -1*($(window).outerWidth() - bodyMaxWidth)/2 else 0;
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
          'top[sqrt]': \0px
          'margin-left[sqrt]': \0px
      })

      @trigger('animationsChange', {keframesOnly: true});

    @animationsProxy = -> $.proxy(@setupAnimations, @)

    @handleDigestDetailsShown = (ev, data) ->
      if @sassVars.largeDesignApplies!
        @select(\tagline).add(@select(\logo)).animate({margin-top: "-=" + data.height}, 140, @animationsProxy)

    @handleDigestDetailsHidden = (ev, data) ->
      if @sassVars.largeDesignApplies!
        @select(\tagline).add(@select(\logo)).animate({margin-top: "+=" + data.height}, 140, @animationsProxy)

    @after('initialize', ->
      @on(window, "resize", @setupAnimations);
      @on(@$node, "digestDetailsShown", @handleDigestDetailsShown);
      @on(@$node, "digestDetailsHidden", @handleDigestDetailsHidden);
      @setupAnimations!
    )
  , mixins.managesAnimations, mixins.usesSassVars)
);