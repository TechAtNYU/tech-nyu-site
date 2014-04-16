
define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(mixins.tracksCurrentDesign, mixins.managesAnimations, mixins.usesSassVars, ->
    @defaultAttrs(isHomeSection: false)

    @$window  = $(window)
    @$content = $('#content')
    @$info    = $('#info')

    @pickImage = (ev, data) ->
      if @designSizeKey is \SMALL || @$window.width() > 1270 
        @$node.css('background-image', 'url(' + @$node.attr('data-wide') + ')')

      else 
        @$node.css('background-image', 'url(' + @$node.attr('data-narrow') + ')')

    @position = (ev, data) ->
      if @designKey == \LARGE
        @$node.insertAfter(@$content)
      else
        @$node.insertBefore(@$info)

    @after('initialize', ->
      if @attr.isHomeSection
        @after('handleDesignModeChange', @position)

      $(document).one('designModeChange', @~pickImage)
      @on(window, "resize", @pickImage)
    )
  )
);