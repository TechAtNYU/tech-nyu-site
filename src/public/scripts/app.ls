requirejs.config(
    baseUrl: 'scripts/bower_components'
    enforceDefine: true
    paths:
        app: '../app'
        mixins: '../mixins'
        components: '../components'

        "flight": 'flight/lib'
        "skrollr": 'skrollr/dist/skrollr.min'
        "skrollr-stylesheets": 'skrollr-stylesheets-amd/dist/skrollr.stylesheets.min'
        "skrollr-menu": 'skrollr-menu/dist/skrollr.menu.min'
        "jquery.flexisel": "flexisel/js/jquery.flexisel"
    shim:
        'jquery.flexisel':
          exports: 'jQuery.fn.flexisel'
        'skrollr': 
            exports: 'skrollr'
        'skrollr-menu': 
            deps: ['skrollr']
            exports: 'skrollr.menu'
)

define([
  'skrollr'
  'skrollr-stylesheets'
  'components/skrollr'
  'components/designSwitcher'
  'components/leftSidebar'
  'components/digestSignup'
  'components/sectionBg'
  'components/sections'
  'components/nav'
  'flight/component'
  'jquery.flexisel'], (skrollr, skrollrStylesheets, skrollrComponent, designSwitcher, leftSidebar, digestSignup, sectionBg, sections, nav, flight, carousel) -> 
  $(->

    # Build the skrollr instance, which some other components
    # take as a dependency. Don't event this; it's not appropriate.
    s = skrollr.init(do
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
      smoothScrollingDuration: 200
    )

    skrollrStylesheets.init(s);

    # Init components. The order is significant here.

    # Skrollr goes first, as it doesn't trigger events but other components
    # need it to exist to handle the animationsChange events they throw.
    skrollrComponent.attachTo('body', do 
      eventsTriggeringRefresh:'sectionContentModified'
      skrollrInstance: s
    )

    # leftSidebar, sectionBg, and digestSignup don't trigger any events right
    # away exept possibly an animationsChange, so they have to go after skrollr
    # but can otherwise go anywhere. They just need to be instantiated before 
    # the initial designModeChange is fired, which they listen to.
    leftSidebar.attachTo('body') #only body bc of the moving moreEventsButton
    digestSignup.attachTo('#digestForm')

    # sectionBg must be positioned before the section container calculates 
    # the initial offset positions.
    sectionBg.attachTo('.bg.starter', {isHomeSection: true})
    sectionBg.attachTo('.objective .bg')

    # Nav component must exist before section component emits the initial
    # transition points.
    nav.attachTo('nav')

    # Sections must be listening before the initial designModeChange too.
    sections.attachTo('#content', {skrollrInstance: s})

    # And finally, the designSwitcher.
    designSwitcher.attachTo('body')
    void;
  );
  $(window).load(->
    $('#carousel').flexisel(do
      visibleItems: 6,
      enableResponsiveBreakpoints: true,
      responsiveBreakpoints:
        large:
          changePoint: 1350
          visibleItems: 5
        lessLarge: 
          changePoint: 1150
          visibleItems: 5
        mediumBig: 
          changePoint: 930
          visibleItems: 4
        mediumSmall:
          changePoint:700
          visibleItems: 3
        lessSmall:
          changePoint:450
          visibleItems: 2
        small:
          changePoint:250,
          visibleItems: 1
    ).trigger('sectionContentModified');
  );
)