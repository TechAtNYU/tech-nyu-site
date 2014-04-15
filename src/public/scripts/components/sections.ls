define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(->
    @defaultAttrs(do
      sectionsSelector: '.objective'
    )

    @animationMode

    @getAnimatedOffsetTopForSection = (i, designKey, animationMode) ->
      | animationMode == 'paginated' =>
          if designKey == \SMALL 
            "NOT SUPPORTED. SEE @determineAnimationMode"
          if designKey == \LARGE
            @sassVars.firstPanelUpStart + 
            (if i!=0 then @sassVars.firstPanelExtraPause else 0) + 
            i*(@sassVars.interPanelDistance + @sassVars.onPanelPause)
      | otherwise =>
            @$sections.eq(i).offset!.top

    @determineAnimationMode = ->
      self = @
      if !@sassVars.largeDesignApplies!
        "scroll" 
      else
        mode = "paginated"
        @$sections.each((i) ->
          $section = $(@)
          if ($section.outerHeight! + self.getPaginatedMarginTop! - $('nav').height!) > $(window).outerHeight!
            mode := "scroll"
            false
        )
        mode

    # The top margin that each section would have were we to 
    # be in the paginated design. Useful for seeing whether 
    # sections would fit on screen in that design, and simulating
    # the position of the first screen in the scrolling esign
    @getPaginatedMarginTop = ->
      parseFloat(@sassVars.largeDesignSectionMarginTop)*parseFloat($('html').css('font-size'))

    @setSectionAnimations = ->
      # figure out whether we're dealing with
      # scrolling or paginated sections
      oldMode = @animationMode
      newMode = @determineAnimationMode!
      @animationMode = newMode

      # if we were and still are paginated,
      # we can leave the animations exactly as is
      if(oldMode == newMode == "paginated")
        return

      self = @
      sectionCount = @$sections.length                
      currDesignKey = if @sassVars.largeDesignApplies! then \LARGE else \SMALL

      # we'll populate this with scroll offsets defining
      # when each section is coming on screen, when it's
      # fully on screen, etc. Will be thrown as event data,
      # which other components can catch (e.g. the nav
      # component, for animating colors).
      sectionTransitionPoints = []

      # if we're on a large design but scrolling, we need to push the first section past
      # the intro animation, but then we need to pull it back up if we switch back to
      # paginated mode or to the small designs.
      if(newMode == "scroll" and currDesignKey == \LARGE)
          wouldBeOffsetTop = 
            (@sassVars.firstPanelUpStart + 
             @getPaginatedMarginTop! + 
             @sassVars.interPanelDistance + 
             @sassVars.firstPanelExtraPause) 
          @$sections.eq(0).css('margin-top',  wouldBeOffsetTop + 'px')
      else if(newMode == "paginated" || currDesignKey == \SMALL)
          @$sections.eq(0).css('margin-top', '') # animation will handle this.

      # setup animations for scrolling sections
      # at the large or small designs
      if @animationMode == "scroll"
        navHeight     = $('nav').outerHeight!
        scrollTop     = @$window.scrollTop!

        @$sections.each((i) !->
          sectionOffset = self.getAnimatedOffsetTopForSection(i, currDesignKey, self.animationMode)
          sectionAtTop  = (sectionOffset - navHeight)
          sectionTransitionPoints[*] = [(sectionAtTop - 35), (sectionAtTop+1)]

          # scrolling doesn't actually require any special animation (just sending 
          # out the transition points), but we still need to clear old animations.
          # (just have to specify the right properties for skrollr to clear)
          self.animate($(@), \LARGE, {0: "position:static;"}, true)
        )


      # setup animations for paginated sections
      # for now, this can only be on large designs
      # (see @determineAnimationMode).
      else if @animationMode == "paginated"
        @$sections.each((i) !->
          $section = $(@)
          startUp = self.getAnimatedOffsetTopForSection(i, \LARGE, self.animationMode)
          pauseOnScreen = self.getAnimatedOffsetTopForSection(i+1, \LARGE, self.animationMode)
          endValue = startUp + self.sassVars.interPanelDistance + (if i==0 then self.sassVars.firstPanelExtraPause else 0)

          largeDesignKeyframes = do
            # move it off screen
            0: do
              top: \100%
              "margin-top": \0rem
              "z-index": i + 1
              "position": \fixed

            #prepare for it to start coming on after this
            (startUp): do
              "blank": \true

            (startUp + self.sassVars.interPanelDistance): do
              top: \0%
              "margin-top": self.sassVars.largeDesignSectionMarginTop

            #pause it before beginning to lift it out and the next one int
            (pauseOnScreen): do
              blank: true

            #bring it out
            (pauseOnScreen + self.sassVars.interPanelDistance): do
              top: \-100%
              "margin-top": \0rem

          # last section doesn't animate out
          if i == (sectionCount - 1)
            delete largeDesignKeyframes[pauseOnScreen + self.sassVars.interPanelDistance]

          self.animate($section, \LARGE, largeDesignKeyframes)
          sectionTransitionPoints[*] = [startUp, endValue]
        )

      @trigger('sectionsTransitionPointsChange', {transitionPoints: sectionTransitionPoints})
      @trigger('animationsChange', {keframesOnly: true})


    @after('initialize', ->
      @$sections = @select(\sectionsSelector)
      @$window   = $(window) 
      @setSectionAnimations!
      @on(window, "resize", @setSectionAnimations);
    )

  , mixins.managesAnimations, mixins.usesSassVars)
);
