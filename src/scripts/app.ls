requirejs.config(
    baseUrl: 'scripts/bower_components'
    enforceDefine: true
    paths:
        jquery:
            'http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min'
            'jquery'
    shim:
        'jquery.scrollTo':
            deps: ['jquery']
            exports: 'jQuery.fn.scrollTo'
)

define(["flight", "jquery"], (flight, $) -> 
    console.log('here');
)