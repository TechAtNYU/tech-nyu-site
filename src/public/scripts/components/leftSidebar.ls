define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(->
    @defaultAttrs(do
      upcoming: \#upcoming
      tagline: \#tagline
      logo: \#logo
      taglineWrapper: \#info
    )

    @positionElems = ->
      upcomingHeight = @select('upcoming').outerHeight()
      windowHeight = $(window).outerHeight()
      taglineHeight = @select('tagline').outerHeight()

      top = (windowHeight - upcomingHeight - taglineHeight)/2;

      @select('logo').css('top', top + 'px');
      @select('tagline').css({'position':'relative', 'top':top + 'px'})
      @select('taglineWrapper').css('bottom', upcomingHeight + \px)

    @setupAnimations = ->
      upcoming = @select('upcoming')
      logo     = @select('logo')
      taglineWrapper = @select(\taglineWrapper)

      @animate(\upcoming, \LARGE, {
        0: "bottom[sqrt]: 0px",
        (@sassVars.leftColOut): 'bottom[sqrt]: '+ -1*upcoming.outerHeight! + 'px'
      })

      @animate(\taglineWrapper, \LARGE, {
        0: "left[sqrt]: 0px",
        (@sassVars.leftColOut): "left[sqrt]: " + -1*taglineWrapper.outerWidth! + 'px'
      })
      
      @animate(\logo, \LARGE, {
        0: do
          'top[sqrt]': logo.css('top')
          'margin-left[sqrt]': if $(window).outerWidth() > @bodyMaxWidth then -1*($(window).outerWidth() - @bodyMaxWidth)/2 + 'px' else \0px
        (@sassVars.navCascadeEnd - 50): do
          'top[sqrt]': \0px
          'margin-left[sqrt]': \0px
      })

      @trigger('animationsChange', {elements: upcoming.add(logo).add(tagline)});

    @animationsProxy = -> $.proxy(@setupAnimations, @)

    @handleDigestDetailsShown = (ev, data) ->
      @select(\tagline).add(@select(\logo)).animate({margin-top: "-=" + data.height}, 140, @animationsProxy)

    @handleDigestDetailsHidden = (ev, data) ->
      @select(\tagline).add(@select(\logo)).animate({margin-top: "+=" + data.height}, 140, @animationsProxy)

    @after('initialize', ->
      @on(window, "resize", @positionElems);
      @on(window, "resize", @setupAnimations);
      @on(@$node, "digestDetailsShown", @handleDigestDetailsShown);
      @on(@$node, "digestDetailsHidden", @handleDigestDetailsHidden);
      @bodyMaxWidth = parseInt(@sassVars.rsBodyMaxWidth)
      @positionElems!
      @setupAnimations!
    )
  , mixins.managesAnimations, mixins.usesSassVars)
);