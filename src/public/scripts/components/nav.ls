define(["flight/component", "mixins", "jquery"], (defineComponent, mixins, $) ->

  defineComponent(->
    @defaultAttrs(
      dummyMobileFirstNavLink: 'li:first-child'
      li: 'li'
      list: 'ol'
      calendarLi: '.calendar'
    )

    @$logo = $('#logo')

    @transitionPoints = []

    @prepSmallNav = ->
      @$dropdown = $('nav ol').clone!.attr('id', 'nav-dropdown').removeClass('optionList')
      # Safari doesn't expose .innerHtml on svg elems, so we can't just do
      # @$dropdown.find('svg').replaceWith(-> $(@).attr('aria-label'))
      $svg = @$dropdown.find('svg'); $svg.before($svg.attr('aria-label')).remove();

      # sub in shortNames if availabe.
      swapLabels(@$dropdown, \short)

      @$dropdown.addClass('hidden').appendTo('body')
      @trigger('smallNavReady')

    @showDropdown = ->
      @$dropdown.removeClass('hidden')

    @hideDropdown = ->
      @$dropdown.addClass('hidden')

    @setAnimations = (ev, data) ->
      @transitionPoints = data.transitionPoints

      smallKeyframes = {}
      largeKeyframes = {}
      largeLogoKeyframes = {}
      navHeight = $('nav').outerHeight!
      lastIndex = data.transitionPoints.length - 1

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
      for keyframePair, i in data.transitionPoints
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
        (data.transitionPoints[lastIndex][0] - 1): "dummy:true;"
        (data.transitionPoints[lastIndex][0]): do
          'transform': 'translate(0px, ' + (lastIndex*navHeight) + 'px)'
        (data.transitionPoints[lastIndex][1]): do
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
      $targetLi = $(ev.target).parent!
      if !@sassVars.largeDesignApplies! and (!$targetLi.hasClass('calendar') || $targetLi.hasClass('active') || ev.target.attributes.id == 'logo')
        @showDropdown!
        false

    @navLabelsToUse
    @setNavText = ->
      currLabels = @navLabelsToUse
      @navLabelsToUse = if @sassVars.largeDesignApplies! then \orig else \short
      if currLabels != @navLabelsToUse then swapLabels(@select('list'), @navLabelsToUse)

    function swapLabels($list, newLabels)
      attr = 'data-' + newLabels + 'name'
      $list.find('li[' + attr + ']').each( -> 
        $curr = $(@)
        $curr.find('a').html($curr.attr(attr))
      );

    @after('initialize', ->
      @prepSmallNav!
      @setNavText!

      @on(window, 'sectionsTransitionPointsChange', $.proxy(@setAnimations, @))
      @on(window, 'resize', $.proxy(@setNavText, @))
      @on(@select('li').find('a').add('#logo'), 'click', @handleNavClick)
      @on(@$dropdown, 'click', @hideDropdown)
    )

  , mixins.managesAnimations, mixins.usesSassVars)
);