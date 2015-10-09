requirejs.config({
  baseUrl: 'scripts/bower_components',
  enforceDefine: true,
  paths: {
    app: '../app',
    mixins: '../mixins',
    components: '../components',
    "flight": 'flight/lib',
    "skrollr": 'skrollr/dist/skrollr.min',
    "skrollr-stylesheets": 'skrollr-stylesheets-amd/src/skrollr.stylesheets',
    "skrollr-menu": 'skrollr-menu-amd/dist/skrollr.menu.min',
    "jquery.flexisel": "flexisel/js/jquery.flexisel"
  },
  shim: {
    'jquery.flexisel': {
      exports: 'jQuery.fn.flexisel'
    },
    'skrollr-menu': {
      deps: ['skrollr'],
      exports: 'skrollr.menu'
    }
  }
});

define([
  'skrollr', 'skrollr-stylesheets',
  'components/skrollr', 'components/designSwitcher', 'components/leftSidebar',
  'components/digestSignup', 'components/sectionBg', 'components/sections',
  'components/nav', 'components/scrollCue', 'flight/component', 'jquery.flexisel'
  ],

  function(skrollr, skrollrStylesheets, skrollrComponent, designSwitcher, leftSidebar, digestSignup, sectionBg, sections, nav, scrollCue, flight, carousel) {
    $(function(){
      var this$ = this;

      designSwitcher.attachTo('body');

      var s = skrollr.init({
        easing: {
          swing2: function(percentComplete){
            return Math.pow(percentComplete, 7);
          },
          swing3: function(percentComplete){
            return Math.pow(percentComplete, 1.8);
          },
          cubedroot: function(percentComplete){
            return Math.pow(percentComplete, 1 / 3);
          },
          swing4: function(percentComplete){
            return Math.pow(percentComplete, 12);
          },
          swing5: function(percentComplete){
            return Math.pow(percentComplete, 4);
          }
        },
        smoothScrollingDuration: 200
      });

      skrollrStylesheets.init(s);

      skrollrComponent.attachTo('body', {
        eventsTriggeringRefresh: 'sectionContentModified',
        skrollrInstance: s
      });

      $(document).on('animationsChange', function(ev, data){
        if (data != null && data.keframesOnly) {
          return skrollrStylesheets.registerKeyframeChange();
        } else {
          return s.refresh((data != null ? data.elements : void 8) || void 8);
        }
      });

      leftSidebar.attachTo('body');
      digestSignup.attachTo('#digestForm');
      sectionBg.attachTo('.bg.starter', {
        isHomeSection: true
      });
      sectionBg.attachTo('.objective .bg');
      nav.attachTo('nav');
      sections.attachTo('#content', {
        skrollrInstance: s
      });
      scrollCue.attachTo('#scrollCue');

      $('.announcement').each(function(i, announcement){
        var $announcement = $(announcement);
        var $close = $('<button class="close ir icon-button" alt="Close" />');

        $close.click(function(){
          var $container = $announcement.parent();
          $announcement.remove();
          if ($container.find('.announcement').length === 0) {
            return $container.remove();
          }
        });
        return $announcement.prepend($close);
      });
    });

    return $(window).load(function(){
      return $('#carousel').flexisel({
        visibleItems: 6,
        enableResponsiveBreakpoints: true,
        responsiveBreakpoints: {
          large: {
            changePoint: 1350,
            visibleItems: 5
          },
          lessLarge: {
            changePoint: 1150,
            visibleItems: 5
          },
          mediumBig: {
            changePoint: 930,
            visibleItems: 4
          },
          mediumSmall: {
            changePoint: 700,
            visibleItems: 3
          },
          lessSmall: {
            changePoint: 450,
            visibleItems: 2
          },
          small: {
            changePoint: 250,
            visibleItems: 1
          }
        }
      }).trigger('sectionContentModified');
    });
  }
);
