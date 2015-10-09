/**
 * This component does four simple things: 
 *
 * First and right away, it initializes skrollr. Then, it just responds to events:
 *
 * 1. When the DOM changes at all (based on the tnyu-domContentModification event), 
 *    it refreshes skrollr, so skrollr can recalcuate the body height.
 *
 * 2. When the design mode changes (based on the tnyu-designModeChange event),
 *    it moves the appropriate animation instructions (saved by the setsAnimations
 *    mixin) out of every element's inactive data- attributes and into live 
 *    skrollr-managed data attributes, replacing the old live skrollr attributes. 
 *    Then, it refreshes skrollr on all the elements that have animations in the
 *    new design, or had some under the old design.
 *
 * 3. When animations are added or changed (based on the tnyu-animationsChange 
 *    event), it looks if those changed events apply to the current design (using 
 *    the event's data.forDesignMode). If they do, it updates the live skrollr 
 *    attributes and refreshes skrollr.
 */
define(["flight/component", "skrollr", "mixins"], function(defineComponent, skrollr, mixins) {
  return defineComponent(mixins.tracksCurrentDesign, function() {
    var self = this;

    // Function #1
    this.handleDomChange = function(ev, data) {
      self.skrollrInstance.refresh(data.$elems);
    };

    // Function #2
    this.swapInAnimationsForDesign = function() {
      var modeLowerCase = this.designMode.toLowerCase()
        , oldModeLowerCase = this.oldDesignMode.toLowerCase();

      var animationsAttrName = 'data-animations-mode-'+ modeLowerCase
        , oldAnimationsAttrName = 'data-animations-mode-'+ oldModeLowerCase;

      var $elms = $('['+ animationsAttrName +'],['+ oldAnimationsAttrName +']');

      // removes any inline styles specifying property `prop` on element `elm`,
      // using skrollr's built in setStyle function, which handles vendor 
      // prefixes on prop automatically.
      var emptyStyleForProp = function(elm, prop) { 
        self.skrollrInstance.setStyle(elm, prop, ''); 
      };

      console.log("Animations Manager responding to designModeChange");

      $elms.each(function() {
        var elm = this, keyframe;
        var newAnims = JSON.parse(elm.getAttribute(animationsAttrName)) || {};

        // Map all the existing attributes to their names and then remove
        // the ones that are live skrollr attributes (from the old design).
        Array.prototype.map.call(elm.attributes, function(attr) { 
          return attr.name; 
        }).forEach(function(attrName) {
          if (/^data-\-?[0-9]+$/.test(attrName)) {
            elm.removeAttribute(attrName);
          }
        }); 

        // Add in attributes from the new animations
        for(keyframe in newAnims) {
          elm.setAttribute('data-' + keyframe, newAnims[keyframe]);
        }

        // Finally, skrollr can(?) get a bit confused about which inline styles
        // it added (i think) when we go willy-nilly deleting data- attributes.
        // So, we need to manually remove inline styles for all the properties
        // specified on this keyframe by the last design (ugh).
        /** 
         * TODO: IS THIS NECESARY? AND, IF SO, HOW ARE WE GOING TO IMPLEMENT AN
         * EQUIVALENT IN FUNCTION 3? DO WE NEED A CHANGESET OR SOMETHING?
        var oldAnims = JSON.parse(elm.getAttribute(oldAnimationsAttrName)) || {};
        for(keyframe in oldAnimations) {
          extractProperties(oldAnimations[keyframe])
            .map(stripEasing).forEach(function(property) {
              emptyStyleForProp(elm, property)
            });
        }
        */
      });
      
      // And, finally, reset skrollr
      self.skrollrInstance.refresh($elms);
    };

    // Function 3, which (holding aside the TODO caveat in swapInAnimationsForDesign)
    // can actually be implemented just like a design mode switch.
    this.handleAnimationsChange = function(ev, data) {
      if(data.forDesignMode === self.designMode) {
        self.swapInAnimationsForDesign();
      }
    };

    this.after('initialize', function() {
      this.skrollrInstance = skrollr.init({
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

      this.on(document, 'tnyu-domContentModifaction', this.handleDomChange);
      this.after('handleDesignModeChange', this.swapInAnimationsForDesign);
      this.on(document, 'tnyu-animationsChange', this.handleAnimationsChange);
    });
  });
});

function stripEasing(propertyWithEasing) { 
  return propertyWithEasing.replace(/\[.*\]/, ''); 
}

//returns an array of properties from a string of inline css
function extractProperties(cssString) {
  cssString = cssString.trim();
  var propValStrings = (cssString.charAt(cssString.length-1) == ';' ? cssString.substring(0, cssString.length - 1) : cssString).split(';');
  var properties = [];

  for(var i = 0, len = propValStrings.length; i < len; i++) {
    properties.push(propValStrings[i].split(':')[0]);
  }

  return properties;
}