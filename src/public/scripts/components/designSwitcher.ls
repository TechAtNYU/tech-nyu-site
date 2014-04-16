define(["flight/component", "mixins"], (defineComponent, skrollr, skrollrStylesheets, skrollrMenu) ->

  defineComponent(->

    @sections
    @oldSizeKey
    @oldScrollMode
    @currentSizeKey     # LARGE or SMALL
    @currentScrollMode  # paginated or scroll

    @getSizeKey = -> 
      if !matchMedia || window.matchMedia("(min-width: 920px) and (min-height:620px) and (max-aspect-ratio: 1500/750)").matches
        \LARGE
      else
        \SMALL

    @getScrollMode = ->
      self = @
      if @getSizeKey! != \LARGE
        "scroll" 
      else
        mode = "paginated"
        @$sections.each((i) ->
          $section = $(@)
          if ($section.outerHeight! + self.sassVars.paginatedMarginTopPx! - $('nav').height!) > $(window).outerHeight!
            mode := "scroll"
            false
        )
        mode

    @getDesignMode = ->
      @oldScrollMode     = @currentScrollMode
      @oldSizeKey        = @currentSizeKey
      @currentSizeKey    = @getSizeKey!
      @currentScrollMode = @getScrollMode!

      if(@oldScrollMode != @currentScrollMode || @oldSizeKey != @currentSizeKey)
        @trigger('designModeChange', {}{oldScrollMode, currentScrollMode, oldSizeKey, currentSizeKey} = @)

    @after('initialize', ->
      @$sections = @select(\sectionsSelector)
      @on(window, 'resize', @~getDesignMode)
    )
  )
);
