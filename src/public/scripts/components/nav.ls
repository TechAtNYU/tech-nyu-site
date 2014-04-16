define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(mixins.tracksCurrentDesign, mixins.managesAnimations, mixins.usesSassVars, ->
    @defaultAttrs(
      dummyMobileFirstNavLink: 'li:first-child'
      li: 'li'
      list: 'ol'
      calendarLi: '.calendar'
    )

    @$logo = $('#logo')

    @transitionPoints = []

    @prepSmallNav = ->
      @$dropdown = @select('list').clone!.attr('id', 'nav-dropdown').removeClass('optionList')
      # Safari doesn't expose .innerHtml on svg elems, so we can't just do
      # @$dropdown.find('svg').replaceWith(-> $(@).attr('aria-label'))
      $svg = @$dropdown.find('svg'); $svg.before($svg.attr('aria-label')).remove();

      # sub in shortNames if available.
      swapLabels(@$dropdown, \short)

      @$dropdown.addClass('hidden').appendTo('body')
      @trigger('smallNavReady')

    @showDropdown = ->
      @$dropdown.removeClass('hidden')

    @hideDropdown = ->
      @$dropdown.addClass('hidden')

    @setAnimations = (ev, {transitionPoints}) ->
      @transitionPoints = transitionPoints

      smallKeyframes = {}
      largeKeyframes = {}
      largeLogoKeyframes = {}
      navHeight = @sassVars.currentNavHeight!
      lastIndex = transitionPoints.length - 1

      # animations for the intro screen (large design only)
      largeKeyframes[@sassVars.navCascadeEnd] = do
        'top': "0px"
        'background-color': "rgba(0,0,0,0)"
        'box-shadow[sqrt]': "hsla(0, 0%, 25%, 0.7) 0px 0px 0px 0px"

      largeKeyframes[@sassVars.headerAnimEnd] = do
        'background-color': @sassVars.sectionColorsRGBA[0]
        'box-shadow[sqrt]': "hsla(0, 0%, 25%, 0.6) 0px 0px 2px 1px"

      largeLogoKeyframes[0] = "fill[sqrt]:" + @sassVars.logoStartColor + ';'
      largeLogoKeyframes[@sassVars.navCascadeEnd] = "fill[sqrt]:" + @sassVars.navInactiveTextColors[0] + ';'

      # remove old ol animations, as the transition points
      # have changed. (Then we rebuild them below)
      @animate(@select('list'), \SMALL, {}, true);
      @animate(@select('calendarLi'), \SMALL, {}, true);

      # animations for each section
      for keyframePair, i in transitionPoints
        [start, end] = keyframePair.map(Math.round)

        smallKeyframes[start] = "dummy: true";
        smallKeyframes[end] = do
          "background-color": @sassVars.sectionColorsRGBA[i]
          "color": @sassVars.navInactiveTextColors[i]
          "fill": @sassVars.navInactiveTextColors[i]

        # skip changing the color of the first section on the 
        # large design (messes with some of the cascade effects).
        if i != 0 
          largeKeyframes[end - @sassVars.colorChangeLength] = "dummy: true";
          largeKeyframes[end] = do
            "background-color": @sassVars.sectionColorsRGBA[i]
            "color": @sassVars.navInactiveTextColors[i]
            "fill": @sassVars.navInactiveTextColors[i]

          largeLogoKeyframes[end - @sassVars.colorChangeLength] = "dummy:true;";
          largeLogoKeyframes[end] = "fill:" + @sassVars.navInactiveTextColors[i] + ';';

        # in the small design, I have to not only animate 
        # the color, but also the naviation text
        if i == 0
          @animate(@$logo, \SMALL, (do
            (start): do
              'transform': 'translateY(0px)'
            (end): do
              'transform': 'translateY(' + -1*navHeight + 'px)'
          ), true)

          @animate(@select('list'), \SMALL, do
            (start): do
              'transform': 'translateY(0px)'
            (end): do
              'transform': 'translateY(' + (-1*navHeight) + 'px)'
          )

        else
          @animate(@$node.find('ol'), \SMALL, do
            (start): do
              'dummy': 'true'
            (end): do
              'transform': 'translateY(' + (i+1)*-1*navHeight + 'px)'
          )

        if i != lastIndex
          @animate(@select('calendarLi'), \SMALL, do
            (start): do
              'transform': 'translate(0px,' + (i)*navHeight + 'px)'
            (end): do
              'transform': 'translate(0px,' + (i+1)*navHeight + 'px)'
          )

      # configure the special animation for the calendar icon
      @animate(@select('calendarLi'), \SMALL, do
        (transitionPoints[lastIndex][0] - 1): "dummy:true;"
        (transitionPoints[lastIndex][0]): do
          'transform': 'translate(0px, ' + (lastIndex*navHeight) + 'px)'
        (transitionPoints[lastIndex][1]): do
          'transform': 'translate(' + -1*(@select('list').width! - @select('calendarLi').width!) + ', ' + (lastIndex+1)*navHeight + 'px)'
      );

      @animate(@$node, \LARGE, largeKeyframes, true)
      @animate(@$logo.find('svg'), \LARGE, largeLogoKeyframes, true)
      @animate(@$node, \SMALL, smallKeyframes, true)
      @trigger('animationsChange', {keframesOnly: true})

    @handleNavClick = (ev, data) ->
      # only do something special for the small design
      # And, if we're dealing with the calendar, only
      # show the dropdown if we're on the calendar screen
      # (i.e. let the calendar shortcut take the user
      # straight to the calendar screen).
      $targetLi = $(ev.currentTarget).parent!
      if @designSizeKey != \LARGE and (!$targetLi.hasClass('calendar') || $targetLi.hasClass('active') || ev.target.attributes.id == 'logo')
        @showDropdown!
        false

    @setNavText = ->
      if @oldDesignSizeKey != @designSizeKey then swapLabels(@select('list'), if @designSizeKey is \LARGE then \orig else \short)

    # must be after setNavText is defined. Annoying.
    @after('handleDesignModeChange', @setNavText)

    function swapLabels($list, newLabels)
      attr = 'data-' + newLabels + 'name'
      $list.find('li[' + attr + ']').each( -> 
        $curr = $(@)
        $curr.find('a').html($curr.attr(attr))
      );

    @after('initialize', ->
      @prepSmallNav!

      @on(window, 'sectionsTransitionPointsChange', @setAnimations)
      @on(@select('li').find('a').add('#logo'), 'click', @handleNavClick)
      @on(@$dropdown, 'click', @hideDropdown)
    )
  )
);