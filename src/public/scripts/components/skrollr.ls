define(require, ->

  require! {
    defineComponent: "flight/component"
    skrollr
    mixins
    'skrollr-menu'
    'skrollr-stylehseets'
    'skrollr-menu'
  };

  defineComponent(->

    @defaultAttrs(do
      navList: 'nav ol'
      upcoming: '#upcoming'
      taglineWrapper: '#info'
      nav: 'nav'
      skrollrBody: '#skrollr-body'
      dropdownNav: '#nav-dropdown'
      eventsTriggeringRefresh: ''
    )

    @transitionPoints = []
    @dropdownNav = null
    @s = null

    @initializeSkrollr = ->
      @s = skrollr.init(do
        easing:
          swing2: (percentComplete) ->
            Math.pow(percentComplete, 7)

          swing3: (percentComplete) ->
            Math.pow(percentComplete, 1.8)

          cubedroot: (percentComplete) ->
            Math.pow(percentComplete, 1/3)

          swing4: (percentComplete) ->
            Math.pow(percentComplete, 12);

          swing5: (percentComplete) ->
            Math.pow(percentComplete, 4)
        smoothScrollingDuration: 200,

        # We need to manage the active nav section on scroll, 
        # but no way to do that except as a skrollr listener,
        # since real scroll events are never fired on mobile 
        # devices (and wouldn't have the right data anyway).
        # but this listener will depend on some globals, which
        # we set above
        render: (data) ~>
          colorToInherit = @navList.css('color')
          scrollTop = data.curTop
          activeIndex = 0

          for section, activeIndex in @transitionPoints ++ [[Infinity, Infinity]]
            if scrollTop < section[0]
              activeIndex -= 1
              if activeIndex < 0 then activeIndex = void
              break

          # assuming we're beyond the intro screen...
          if(activeIndex != void)
            @navList.find('li').removeClass('active').eq(activeIndex).addClass('active')
            @dropdownNav.find('li').removeClass('active').eq(activeIndex).addClass('active')
        )

      skrollrStylesheets.init(@s);
      skrollrMenu.init(@s, do
        handleLink: (linkElm) ~>
          if @transitionPoints.length > 0
            @transitionPoints[$(linkElm).attr('data-transitionpoint')][1]
      );

      # A generic listener. Any component that's explicitly
      # changing animations (i.e. setting keyframes) can call this.
      $(document).on('animationsChange', (ev, data) ~> 
        if data?.keframesOnly 
          skrollrStylesheets.registerKeyframeChange! 
        else @s.refresh(data?.elements || void)
      )

      @trigger(document, \skrollrInitialized, {skrollrInstance: @s})

      # on initialize, run a refresh for any pre-initialize skrollr updates.
      skrollrStylesheets.registerKeyframeChange!
      @s.refresh!

    @after('handleDesignModeChange', @moveElementsForMobileSkrollr)
    @moveElementsForMobileSkrollr = ->
      if @oldDesignSizeKey != @newDesignSizeKey
        if @newDesignSizeKey == \LARGE
          @select('taglineWrapper').insertBefore(@select('nav'))
          @select('upcoming').insertAfter(@select('nav'))
        else
          @select('taglineWrapper').add(@select('upcoming')).prependTo(@select('skrollrBody'))

        @s.refresh!

    # This method listens for when both the dropdownNav
    # and the transitionPoints have been set, and then
    # triggers an event which initializes Skrollr. 
    # This mess should pbobably be done with a Promise somehow.
    @after('initialize', ->  
      self = @
      @navList = @select('navList')

      $(document)
      .on('sectionsTransitionPointsChange', (ev, {transitionPoints}) -> 
        self.transitionPoints := transitionPoints
        if self.dropdownNav then $(document).trigger('readyForSkrollr')
      )
      .on('smallNavReady', (ev, data) ->
        self.dropdownNav := @select('dropdownNav')
        if self.transitionPoints.length > 0 then $(document).trigger('readyForSkrollr')
      )
      # important to use one, as sectionTransitionPointsChange is triggered a lot.
      .one('readyForSkrollr', @~initializeSkrollr)
    )

  , mixins.tracksCurrentDesign)
);
