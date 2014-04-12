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

    @prepMobileNav = ->
      @$dropdown = $('nav ol').clone!.attr('id', 'nav-dropdown').removeClass('optionList')
      # Safari doesn't expose .innerHtml on svg elems, so we can't just do
      # @$dropdown.find('svg').replaceWith(-> $(@).attr('aria-label'))
      $svg = @$dropdown.find('svg'); $svg.insertBefore($svg.attr('aria-label')).remove();
      @$dropdown.addClass('hidden').appendTo('body')

    @showDropdown = ->
      @$dropdown.removeClass('hidden')

    @hideDropdown = ->
      @$dropdown.addClass('hidden')

    @setAnimations = (ev, data) ->
      @transitionPoints = data.transitionPoints

      smallKeyframes = {}
      largeKeyframes = {}
      colorChangeStartDelay = @sassVars.colorChangeStartDelay
      navHeight = $('nav').outerHeight!

      # animations for the intro screen (large design only)
      largeKeyframes[@sassVars.navCascadeEnd] = do
        'top': "0px"
        'background-color': "rgba(0,0,0,0)"
        'box-shadow[sqrt]': "hsla(0, 0%, 25%, 0.7) 0px 0px 0px 0px"

      largeKeyframes[@sassVars.headerAnimEnd] = do
        'background-color': @sassVars.sectionColorsRGB[0]
        'box-shadow[sqrt]': "hsla(0, 0%, 25%, 0.6) 0px 0px 2px 1px"

      # remove old ol animations, as the transition points
      # have changed. (Then we rebuild them below)
      @animate(@select('list'), \SMALL, {}, true);
      @animate(@select('calendarLi'), \SMALL, {}, true);

      # animations for each section
      for keyframePair, i in data.transitionPoints
        [start, end] = keyframePair

        smallKeyframes[Math.round(start)] = "dummy: true";
        smallKeyframes[Math.round(end)] = do
          "background-color": @sassVars.sectionColorsRGB[i]
          "color": @sassVars.navInactiveTextColors[i]
          "fill": @sassVars.navInactiveTextColors[i]

        # skip changing the color of the first section on the 
        # large design (messes with some of the cascade effects).
        if i != 0
          largeKeyframes[start + colorChangeStartDelay] = "dummy: true";
          largeKeyframes[end] = do
            "background-color": @sassVars.sectionColorsRGB[i]
            "color": @sassVars.navInactiveTextColors[i]
            "fill": @sassVars.navInactiveTextColors[i]

        # in the small design, I have to not only animate 
        # the color, but also the naviation text

        if i == 0
          @animate(@$logo, \SMALL, (do
            (start): do
              'transform': 'translateY(0px)'
            (end): do
              'transform': 'translateY(' + -1*navHeight + ')'
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
              'min-width': '1em'
            (end): do
              'transform': 'translateY(' + (i+1)*-1*navHeight + 'px)'
          )

        @animate(@select('calendarLi'), \SMALL, do
          (start): do
            'transform': 'translateY(' + (i)*navHeight + 'px)'
          (end): do
            'transform': 'translateY(' + (i+1)*navHeight + 'px)'
        )

      # configure the special animation for the calendar icon
      /*
      @animate(@select('calendarLi'), \SMALL, do
        (data.transitionPoints[*-1][0] - 1): "dummy:true;"
        (data.transitionPoints[*-1][0]): do
          'right': '0%'
          'left': '40%'
          'padding-left': '0px'
        (data.transitionPoints[*-1][1]): do
          'right': '40%'
          'left': '0%'
          'padding-left': @select('calendarLi').css('padding-right')
      );*/

      @animate(@$node, \LARGE, largeKeyframes, true)
      @animate(@$node, \SMALL, smallKeyframes, true)
      @trigger('animationsChange', {keframesOnly: true})


    @after('initialize', ->
      @prepMobileNav!
      @on(window, 'sectionsTransitionPointsChange', @setAnimations)
    )

  , mixins.managesAnimations, mixins.usesSassVars)
);