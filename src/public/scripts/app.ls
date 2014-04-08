requirejs.config(
    baseUrl: 'scripts/bower_components'
    enforceDefine: true
    paths:
        app: '../app'
        mixins: '../mixins'
        components: '../components'

        flight: 'flight/lib'
        "skrollr": 'skrollr/dist/skrollr.min'
        "skrollr-stylehseets": 'skrollr-stylesheets-amd/dist/skrollr.stylesheets.min'
        "skrollr-menu": 'skrollr-menu/dist/skrollr.menu.min'
        jquery:
          'http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min'
          'jquery'
        
    shim:
        'jquery.scrollTo':
          deps: ['jquery']
          exports: 'jQuery.fn.scrollTo'
        'skrollr': 
            exports: 'skrollr'
        'skrollr-menu': 
            exports: 'skrollr.menu'
)

define([
  "flight/component"
  "jquery"
  "skrollr"
  "skrollr-stylehseets"
  "skrollr-menu"
  "components/leftSidebar"
  "components/digestSignup"
  "components/sectionBg"
  "components/sections"
  "components/nav"
  ], (flight, $, skrollr, skrollrStylesheets, skrollrMenu, leftSidebar, digestSignup, sectionBg, sections, nav) -> 
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
  skrollrMenu.init(s);

  $(document).on('animationsChange', (ev, data) -> if data.keframesOnly then skrollrStylesheets.registerKeyframeChange! else s.refresh(data.elements));

  # Init components
  leftSidebar.attachTo('header')
  digestSignup.attachTo('#digestForm')

  sections.attachTo('#content')
  sectionBg.attachTo('.bg.starter', {isHomeSection: true})
  sectionBg.attachTo('.objective .bg')
  nav.attachTo('nav')
  void;
)