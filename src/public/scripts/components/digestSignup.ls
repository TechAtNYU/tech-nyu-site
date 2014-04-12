define(["flight/component", "mixins", "jquery"], (defineComponent, mixins, $) ->

  defineComponent(->
    @defaultAttrs(do
      details: \.caption
      submit: "[type=submit]"
      input: "[type=email]"
    )

    @showDetails = ->
      details = @select(\details).show!.removeClass(\hidden)
      @trigger('digestDetailsShown', {'height': details.outerHeight!})

    @hideDetails = ->
      details = @select(\details).hide!.addClass(\hidden)
      height = details.outerHeight!
      @trigger('digestDetailsHidden', {'height': height})

    @after('initialize', ->
      @on(@select('input'), "focus", @showDetails);
      @on(@select('input'), 'blur', @hideDetails);
    )
  , mixins.managesAnimations, mixins.usesSassVars)
);