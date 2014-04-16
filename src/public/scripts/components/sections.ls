define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(->
    @defaultAttrs(do
      sectionsSelector: '.objective'
    )

    @handleResize = ->
      # if we were and still are paginated, we can leave 
      # the animations as is.
      if not (@oldScrollMode == @scrollMode == "paginated")
        @setSectionAnimations(@scrollMode, @designSizeKey)

    @getAnimatedOffsetTopForSection = (i, scrollMode) ->
      | scrollMode == 'paginated' =>
          @sassVars.firstPanelUpStart + 
          (if i!=0 then @sassVars.firstPanelExtraPause else 0) + 
          i*(@sassVars.interPanelDistance + @sassVars.onPanelPause)
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

      # We'll populate this with scroll offsets defining
      # when each section is coming on screen, when it's
      # fully on screen, etc. Will be thrown as event data,
      # which other components can catch (e.g. the nav
      # component, for animating colors).
      sectionTransitionPoints = []

      # Prep the margin on the first section. If we're on a large design but scrolling,
      # we need to give it a margin top that pushes it past the intro animation.
      # But otherwise (i.e. or paginated mode or the small design), we need to remove any
      # margin that may have been set (which skrollr will add back in the paginated case).
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
      # Setup animations for scrolling sections at the large or small designs
      if scrollMode == "scroll"
        scrollTop     = @$window.scrollTop!

        @$sections.each((i) !->
          sectionOffset = self.getAnimatedOffsetTopForSection(i, scrollMode)
          sectionAtTop  = (sectionOffset - navHeight)
          sectionTransitionPoints[*] = [(sectionAtTop - 35), (sectionAtTop+1)]

          # Scrolling doesn't actually require any special animation (just sending 
          # out the transition points), but we still need to clear old animations.
          # (just have to specify the right properties for skrollr to clear)
          self.animate($(@), \LARGE, {0: "position:static;"}, true)
        )


      # Setup animations for paginated sections, which  
      # (for now anyway) only occur on the large design
      else if scrollMode == "paginated"
        @$sections.each((i) !->
          $section = $(@)
          startUp = self.getAnimatedOffsetTopForSection(i, scrollMode)
          pauseOnScreen = self.getAnimatedOffsetTopForSection(i+1, scrollMode)
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
      @trigger('animationsChange', {keframesOnly: true});

    @preSkrollr = ->
      @$sections = @select(\sectionsSelector)
      @$window   = $(window)
      @setSectionAnimations(@scrollMode, @designSizeKey)

    @after('initialize', ->
      @preSkrollr!
      @on(document, 'skrollrInitialized', ~>
        @on(window, "resize", @handleResize);
      ); 
    )

  , mixins.tracksCurrentDesign, mixins.managesAnimations, mixins.usesSassVars)
);
