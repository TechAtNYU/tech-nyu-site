/**
 * Components in Flight communicate through events, so it's important
 * to understand what events the system defines, and to make sure each
 * component is sending/receivng them appropriately. Currently, the 
 * events are as follows (parentheses after the event name indicates
 * the type of data that can be provided with the event, and the keys
 * at which that data should live):
 *
 * 1. tnyu-domContentModification($elems: $elemtsChangedOrAdded)
 *    This should be triggered whenever a component adds, removes,
 *    moves, or otherwise modifies something in the DOM. Among other 
 *    things, the animations manager listens for this event to 
 *    recalculate the body height, etc.
 *
 * 2. tnyu-designModeChange(oldDesignMode: string, designMode: string)
 *    This is fired every time the design mode switches from SMALL to
 *    large, or vice-versa. Many components may want to listen to it
 *    (e.g. to change their elements' structure for the new mode).
 *
 * 3. tnyu-animationsChange(forDesignMode: string)
 *    This should be triggered every time a component registers (a batch
 *    of) new or updated animation instructions (using the setAnimations
 *    mixin). Among other things, the AniationsManager listens to it to
 *    make sure the latest animations are being applied.
 */
requirejs.config({
  baseUrl: 'scripts/bower_components',
  enforceDefine: true,
  paths: {
    app: '../app',
    mixins: '../mixins',
    components: '../components',
    "jquery": 'jquery/dist/jquery.min',
    "flight": 'flight/lib',
    "skrollr": 'skrollr/dist/skrollr.min',
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
  'jquery',  
  'components/designModeTracker', 'components/animationsManager'
  /*'components/skrollr',  'components/leftSidebar',
  'components/digestSignup', 'components/sectionBg', 'components/sections',
  'components/nav', 'components/scrollCue', 'flight/component', 'jquery.flexisel' */
  ],

  function($, designModeTracker, animationsManager /*, skrollrComponent, leftSidebar, digestSignup, sectionBg, sections, nav, scrollCue, flight, carousel*/) {
    $(function() {
      var this$ = this;

      designModeTracker.attachTo('body');

      // note that sectionContentModified used to trigger a
      // skrollr refresh; now only tnyu-domContentModification does.
      // Likewise, animationsChange became tnyu-animationsChange.
      animationsManager.attachTo('body');
      
      /*

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
      });*/
    });
    /*
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
    }); */
  }
);
