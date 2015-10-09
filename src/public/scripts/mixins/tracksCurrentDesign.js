define(function() {
  return function() {
    this.after('initialize', function(){
      this.on(document, 'designModeChange', this.handleDesignModeChange);
    });

    this.oldDesignSizeKey; this.designSizeKey;

    this.handleDesignModeChange = function(ev, data) {
      this.oldDesignSizeKey = data.oldDesignSizeKey;
      this.designSizeKey = data.designSizeKey;
    };
  }
});