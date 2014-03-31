define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(->
    @defaultAttrs(do
      details: \.details
      submit: "[type=submit]"
      input: "[type=email]"
    )

    @showInstructions = ->
      

    @setupAnimations = ->
      upcoming = @select('upcoming')
      logo     = @select('logo')
      taglineWrapper = @select(\taglineWrapper)

      @animate(\upcoming, \LARGE, {
        0: "bottom[sqrt]: 0px",
        (@sassVars.leftColOut): 'bottom[sqrt]: '+ -1*upcoming.outerHeight! + 'px'
      })

      @animate(\taglineWrapper, \LARGE, {
        0: "left[sqrt]: 0px",
        (@sassVars.leftColOut): "left[sqrt]: " + -1*taglineWrapper.outerWidth! + 'px'
      })
      
      @animate(\logo, \LARGE, {
        0: 'top[sqrt]:' + logo.css('top'),
        (@sassVars.navCascadeEnd - 50): 'top[sqrt]:0px;'
      })

      @trigger('animationsChange', {elements: upcoming.add(logo).add(tagline)});

    @after('initialize', ->
      @on(window, "resize", @positionElems);
      @on(window, "resize", @setupAnimations);
      @positionElems!
      @setupAnimations!
    )
  , mixins.managesAnimations, mixins.usesSassVars)
);