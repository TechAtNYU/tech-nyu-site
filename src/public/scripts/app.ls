requirejs.config(
    baseUrl: 'scripts/bower_components'
    enforceDefine: true
    paths:
        app: '../app'
        flight: 'flight/lib'
        "skrollr/skrollr": 'skrollr/dist/skrollr.min'
        "skrollr/stylehseets": '../components/skrollr-stylesheets/src/skrollr.stylesheets'
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

define(["flight/component", "jquery", "skrollr/skrollr", "skrollr/stylehseets"], (flight, $, skrollr2, skrollrStylesheets) -> 
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
)