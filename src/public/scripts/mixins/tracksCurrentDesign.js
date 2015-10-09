define(function() {
  var designMode = {"old": null, "current": null};

  return function() {
    // make getters to support our old components
    Object.defineProperty(this, 'oldDesignMode', {
      get: function() {
        return designMode.old;
      }, 
      set: function(val) {
        designMode.old = val;
      }
    });

    Object.defineProperty(this, 'currDesignMode', {
      get: function() {
        return designMode.current;
      }, 
      set: function(val) {
        designMode.current = val;
      }
    });
  }
});