define(["flight/component", "mixins", "jquery"], (defineComponent, mixins, $) ->

  defineComponent(->
    @defaultAttrs(do
      sectionsSelector: '.objective'
    )

    @getAnimatedOffsetTopForSection = (i, designKey) ->
      | @animationMode == 'paginated' =>
          if designKey == \SMALL 
            \TODO
          if designKey == \LARGE
            @sassVars.firstPanelUpStart + (if i!=0 then @sassVars.firstPanelExtraPause else 0) + i*(@sassVars.interPanelDistance + @sassVars.onPanelPause)
      | otherwise =>
          if designKey == \SMALL
            @$sections.eq(i).offset!.top

    @setSectionAnimations = ->
      self = @
      if @animationMode == "scroll"
        @$sections.each((i) !->
          $section = $(@)
          self.animate($section, \LARGE, {})
          self.animate($section, \SMALL, {})
        )

      else
        @$sections.each((i) !->
          $section = $(@)
          startUp = self.getAnimatedOffsetTopForSection(i, \LARGE)
          pauseOnScreen = (self.sassVars.firstPanelUpStart + self.sassVars.firstPanelExtraPause + (i+1)*(self.sassVars.interPanelDistance + self.sassVars.onPanelPause))

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

          self.animate($section, \LARGE, if i == 5 then (delete largeDesignKeyframes[pauseOnScreen + self.sassVars.interPanelDistance]; largeDesignKeyframes) else largeDesignKeyframes)
          self.animate($section, \SMALL, {})
        )

      @trigger('animationsChange', {keframesOnly: true})


    @determineAnimationMode = ->
      mode = "paginated"
      @$sections.each((i) ->
        if $(@).outerHeight(true) > $(window).outerHeight!
          mode := "scroll"
          false
      )
      mode

    @animationMode
    @updateAnimationMode = ->
      oldMode = @animationMode
      newMode = @determineAnimationMode!
      @animationMode = newMode
      if oldMode != newMode
        @trigger('sectionsAnimationModeChange', newVal: newMode)


    @after('initialize', ->
      @$sections = @select(\sectionsSelector)

      #change listener must be added BEFORE updateAnimationMode is called
      @on(@$node, 'sectionsAnimationModeChange', $.proxy(@setSectionAnimations, @));

      @on(window, "resize", @updateAnimationMode);
      @updateAnimationMode!
    )
  , mixins.managesAnimations, mixins.usesSassVars)
);