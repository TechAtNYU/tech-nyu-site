
define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(->
    @defaultAttrs(isHomeSection: false)

    @$window  = $(window)
    @$content = $('#content')
    @$info    = $('#info')

    @pickImage = (ev, data) ->
      if @$window.width() > 1270 || !@sassVars.largeDesignApplies!
        @$node.css('background-image', 'url(' + @$node.attr('data-wide') + ')')

      else 
        @$node.css('background-image', 'url(' + @$node.attr('data-narrow') + ')')

    @position = (ev, data) ->
      if @sassVars.largeDesignApplies!
        @$node.insertAfter(@$content)
      else
        @$node.insertBefore(@$info)

    @after('initialize', ->
      if @attr.isHomeSection
        @on(window, "resize", @position);
        @position!

      @on(window, "resize", @pickImage);
      @pickImage!
    )
  , mixins.managesAnimations, mixins.usesSassVars)
);