
requirejs.config(
    baseUrl: 'scripts/bower_components'
    enforceDefine: true
    paths:
        app: '../app'
        mixins: '../mixins'
        components: '../components'

        flight: 'flight/lib'
        "skrollr/skrollr": 'skrollr/dist/skrollr.min'
        "skrollr/stylehseets": 'skrollr-stylesheets-amd/dist/skrollr.stylesheets.min'
        jquery:
          'http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min'
          'jquery'
        
    shim:
        'jquery.scrollTo':
          deps: ['jquery']
          exports: 'jQuery.fn.scrollTo'
        'skrollr/skrollr': 
            exports: 'skrollr'
)

define(["flight/component", "jquery", "skrollr/skrollr", "skrollr/stylehseets", "components/leftSidebar"], (flight, $, skrollr, skrollrStylesheets, leftSidebar) -> 
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

  $(-> skrollrStylesheets.init(s));

  $(document).on('animationsChange', (ev, data) -> s.refresh(data.elements));

  # Init components
  leftSidebar.attachTo('header');
  void;
)