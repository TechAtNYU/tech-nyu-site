define(function() {
  return function() {
    this.after('initialize', function(){
      this.on(document, 'designModeChange', this.handleDesignModeChange);
    });

    this.oldScrollMode; this.scrollMode; this.oldDesignSizeKey; this.designSizeKey;

    this.handleDesignModeChange = function(ev, data) {
      this.oldScrollMode = data.oldScrollMode;
      this.scrollMode = data.scrollMode;
      this.oldDesignSizeKey = data.oldDesignSizeKey;
      this.designSizeKey = data.designSizeKey;
    };
  }
});