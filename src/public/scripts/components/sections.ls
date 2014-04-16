define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(->
    @defaultAttrs(do
      sectionsSelector: '.objective'
    )


    @getAnimatedOffsetTopForSection = (i, designKey, animationMode) ->
      | animationMode == 'paginated' =>
          if designKey == \SMALL 
            "NOT SUPPORTED. SEE @determineAnimationMode"
          if designKey == \LARGE
            @sassVars.firstPanelUpStart + 
            (if i!=0 then @sassVars.firstPanelExtraPause else 0) + 
            i*(@sassVars.interPanelDistance + @sassVars.onPanelPause)
    @scrollMode
    @oldScrollMode
    @designKey

    @handleDesignModeChange = (ev, {scrollMode, designKey}) ->
      @oldScrollMode = @scrollMode
      @scrollMode = scrollMode
      @designKey = designKey

    @handleResize = ->
      # if we were and still are paginated, we can leave anims as is.
      if not (@oldScrollMode == @scrollMode == "paginated")
        @setSectionAnimations(@scrollMode, @designKey)
        @trigger('animationsChange', {keframesOnly: true});
      | otherwise =>
            @$sections.eq(i).offset!.top


    # The top margin that each section would have were we to 
    # be in the paginated design. Useful for seeing whether 
    # sections would fit on screen in that design, and simulating
    # the position of the first screen in the scrolling esign
    @getPaginatedMarginTop = ->
      parseFloat(@sassVars.largeDesignSectionMarginTop)*parseFloat($('html').css('font-size'))

    @setSectionAnimations = (scrollMode, designKey) ->
      self = @
      sectionCount = @$sections.length                

      # we'll populate this with scroll offsets defining
      # when each section is coming on screen, when it's
      # fully on screen, etc. Will be thrown as event data,
      # which other components can catch (e.g. the nav
      # component, for animating colors).
      sectionTransitionPoints = []

      # if we're on a large design but scrolling, we need to push the first section past
      # the intro animation, but then we need to pull it back up if we switch back to
      # paginated mode or to the small designs.
      if(scrollMode == "scroll" and designKey == \LARGE)
          wouldBeOffsetTop = 
            (@sassVars.firstPanelUpStart + 
             @getPaginatedMarginTop! + 
             @sassVars.interPanelDistance + 
             @sassVars.firstPanelExtraPause) 
          @$sections.eq(0).css('margin-top',  wouldBeOffsetTop + 'px')

      # setup animations for scrolling sections
      # at the large or small designs
        navHeight     = $('nav').outerHeight!
      else if(scrollMode == "paginated" || designKey == \SMALL)
      if scrollMode == "scroll"
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


      # Setup animations for paginated sections, which  
      # (for now anyway) only occur on the large design
      else if scrollMode == "paginated"
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

    @preSkrollr = ->
      @$sections = @select(\sectionsSelector)
      @$window   = $(window)
      @setSectionAnimations!

    @after('initialize', ->
      @preSkrollr!
      @on(document, 'designModeChange', @~handleDesignModeChange)
      @on(document, 'skrollrInitialized', ~>
        @trigger('animationsChange', {keframesOnly: true});
        @on(window, "resize", @handleResize);
      ); 
    )

  , mixins.managesAnimations, mixins.usesSassVars)
);
