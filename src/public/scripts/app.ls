requirejs.config(
    baseUrl: 'scripts/bower_components'
    enforceDefine: true
    paths:
        app: '../app'
        flight: 'flight/lib'
        jquery:
            'http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min'
            'jquery'
    shim:
        'jquery.scrollTo':
            deps: ['jquery']
            exports: 'jQuery.fn.scrollTo'
)

define(["flight/component", "jquery"], (flight, $) -> 
    console.log('here');
)