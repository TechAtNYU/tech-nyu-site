define(["flight/component", "mixins", "jquery"], (defineComponent, mixins, $) ->

  defineComponent(->
    @defaultAttrs(do
      sectionsSelector: '.objective'
    )

    @animationMode

    @getAnimatedOffsetTopForSection = (i, designKey) ->
      | @animationMode == 'paginated' =>
          if designKey == \SMALL 
            "TODO. NOT YET SUPPORTED. SEE @determineAnimationMode"
          if designKey == \LARGE
            @sassVars.firstPanelUpStart + 
            (if i!=0 then @sassVars.firstPanelExtraPause else 0) + 
            i*(@sassVars.interPanelDistance + @sassVars.onPanelPause)
      | otherwise =>
            @$sections.eq(i).offset!.top

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

      # we'll populate this with scroll offsets defining
      # when each section is coming on screen, when it's
      # fully on screen, etc. Will be thrown as event data,
      # which other components can catch (e.g. the nav
      # component, for animating colors).
      sectionTransitionPoints = []

      # setup animations for scrolling sections
      # at the large or small designs
      if @animationMode == "scroll"
        # scrolling doesn't (for now) actually require any special
        # animation, but only sending out the transition points
        navHeight     = $('nav').outerHeight!
        currDesignKey = if @sassVars.largeDesignApplies! then \LARGE else \SMALL
        scrollTop     = @$window.scrollTop!
        @$sections.each((i) !->
          sectionOffset = self.getAnimatedOffsetTopForSection(i, currDesignKey)
          sectionAtTop  = (sectionOffset - navHeight)
          # @todo account for margin-top on each section (what the +/- is) in a
          # less janky way, possibly using the @sassVars.largeDesignSectionMarginTop,
          # e.g. making a dummy element that many rems & then measuring its px height
          sectionTransitionPoints[*] = [(sectionAtTop - 30), sectionAtTop + 10]
        )

      # setup animations for paginated sections
      # for now, this can only be on large designs
      # (see @determineAnimationMode).
      else if @animationMode == "paginated"
        @$sections.each((i) !->
          $section = $(@)
          startUp = self.getAnimatedOffsetTopForSection(i, \LARGE)
          pauseOnScreen = self.getAnimatedOffsetTopForSection(i+1, \LARGE)

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
          sectionTransitionPoints[*] = [startUp, startUp + self.sassVars.interPanelDistance]
        )
      @trigger('sectionsTransitionPointsChange', {transitionPoints: sectionTransitionPoints})
      @trigger('animationsChange', {keframesOnly: true})

    @determineAnimationMode = ->
      if !@sassVars.largeDesignApplies!
        "scroll" 
      else
        mode = "paginated"
        @$sections.each((i) ->
          if $(@).outerHeight(true) > $(window).outerHeight!
            mode := "scroll"
            false
        )
        mode

    @after('initialize', ->
      @$sections = @select(\sectionsSelector)
      @$window   = $(window) 
      @setSectionAnimations!
      @on(window, "resize", @setSectionAnimations);
    )

  , mixins.managesAnimations, mixins.usesSassVars)
);