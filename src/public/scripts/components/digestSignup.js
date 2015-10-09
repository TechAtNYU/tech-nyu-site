define(["flight/component", "mixins"], function(defineComponent, mixins){

  return defineComponent(function() {
    this.defaultAttrs({
      details: '.caption',
      submit: "[type=submit]",
      input: "[type=email]"
    });

    this.showDetails = function(){
      var details = this.select('details').show().removeClass('hidden');
      this.trigger('digestDetailsShown', { 'height': details.outerHeight() });
    };

    this.hideDetails = function(){
      var details = this.select('details');
      var height = details.outerHeight();

      details.hide().addClass('hidden');
      this.trigger('digestDetailsHidden', { 'height': height });
    };

    return this.after('initialize', function(){
      this.on(this.select('input'), "focus", this.showDetails);
      this.on(this.select('input'), 'blur', function(){
        setTimeout(this.hideDetails.bind(this), 150);
      });
    });
  });
});
