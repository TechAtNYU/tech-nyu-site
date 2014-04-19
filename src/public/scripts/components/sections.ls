define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(mixins.tracksCurrentDesign, mixins.managesAnimations, mixins.usesSassVars, ->
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
          # + -2*translateY adjusts for mobile once skrollr's been
          # initialized. In that case, rather than having a positive
          # value for how far we've scrolled down, we have a negative
          # translate value of the same magnitue saying how far the
          # browser should pull the element up, and our pageYOffset
          # (i.e. scrollTop) is zero.
          translateY = if @s?.isMobile! then -1*@s.getScrollTop! else 0
          @$sections.eq(i).offset!.top + -2*translateY

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
             @sassVars.paginatedMarginTopPx! + 
             @sassVars.interPanelDistance + 
             @sassVars.firstPanelExtraPause) 
          @$sections.eq(0).css('margin-top',  wouldBeOffsetTop + 'px')

      else if(scrollMode == "paginated" || designKey == \SMALL)
          @$sections.eq(0).css('margin-top', '')

      # Setup animations for scrolling sections at the large or small designs
      if scrollMode == "scroll"
        navHeight     = @sassVars.currentNavHeight!
        scrollTop     = @$window.scrollTop!

        @$sections.each((i) !->
          sectionOffset = self.getAnimatedOffsetTopForSection(i, scrollMode)
          sectionAtTop  = (sectionOffset - navHeight)
          sectionTransitionPoints[*] = [(sectionAtTop - 40), (sectionAtTop+1)]

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
              "margin-top": self.sassVars.paginatedMarginTop

            #pause it before beginning to lift it out and the next one int
            (pauseOnScreen): do
              blank: true

            #bring it out
            (pauseOnScreen + self.sassVars.interPanelDistance): do
              top: \-100%
              "margin-top": \0rem

          # last section doesn't animate out
          if i == (sectionCount - 1)
            delete! largeDesignKeyframes[pauseOnScreen + self.sassVars.interPanelDistance]

          self.animate($section, \LARGE, largeDesignKeyframes)
          sectionTransitionPoints[*] = [startUp, endValue]
        )

      @trigger('sectionsTransitionPointsChange', {transitionPoints: sectionTransitionPoints})
      @trigger('animationsChange', {keframesOnly: true});

    @after('initialize', ->
      @$sections = @select(\sectionsSelector)
      @$window   = $(window)
      $(document).one('designModeChange', ~> @setSectionAnimations(@scrollMode, @designSizeKey))
      @on(document, 'skrollrInitialized', (ev, {skrollrInstance})~>
        @s = skrollrInstance
        @on(window, "resize", @handleResize);
        @on(document, 'sectionContentModified', @handleResize)
      ); 
    )
  )
);
