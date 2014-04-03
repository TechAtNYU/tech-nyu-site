define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(->
    @defaultAttrs()

    @$window = $(window)

    @pickImage = (ev, data) ->
      if @$window.width() > 1270
        @$node.css('background-image', 'url(' + @$node.attr('data-wide') + ')')

      else
        @$node.css('background-image', 'url(' + @$node.attr('data-narrow') + ')')

    @after('initialize', ->
      @on(window, "resize", @pickImage);
      @pickImage!
    )
  , mixins.managesAnimations, mixins.usesSassVars)
);