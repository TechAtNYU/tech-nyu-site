requirejs.config(
    baseUrl: 'scripts/bower_components'
    enforceDefine: true
    paths:
        app: '../app'
        mixins: '../mixins'
        components: '../components'

        "flight": 'flight/lib'
        "skrollr": 'skrollr/dist/skrollr.min'
        "skrollr-stylehseets": 'skrollr-stylesheets-amd/dist/skrollr.stylesheets.min'
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

define((require) -> 
  require! {
    'components/skrollr'
    'components/leftSidebar'
    'components/digestSignup'
    'components/sectionBg'
    'components/sections'
    'components/nav'
    flight: "flight/component"
    carousel: "jquery.flexisel"
  }
  $(->
    # Init components. The order is significant here.
    # E.g. nav component must exist so that it's registered 
    # its listeners before section component emits the initial
    # transition points. Similarly, bg must be positioned before 
    # the section container calculates the initial offset
    # positions. Could event some of this; not worth the work now.
    skrollr.attachTo('body')
    leftSidebar.attachTo('body')
    digestSignup.attachTo('#digestForm')
    nav.attachTo('nav')
    sectionBg.attachTo('.bg.starter', {isHomeSection: true})
    sections.attachTo('#content')
    sectionBg.attachTo('.objective .bg')
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
    );
    $(document).on(\skrollrInitialized, (ev, {skrollrInstance}) ->
      skrollrInstance.refresh!
    )
  );
)