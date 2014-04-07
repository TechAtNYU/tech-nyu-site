define(["flight/component", "mixins"], (defineComponent, mixins) ->

  defineComponent(->
    @defaultAttrs(
      dummyMobileFirstNavLink: 'li:first-child'
    )

    @$logo = $('#logo')

    @prepMobileNav = ->
      @$dropdown = $('nav ol').clone!.attr('id', 'nav-dropdown').removeClass('optionList')
      @$dropdown.find('svg').replaceWith(-> $(@).attr('aria-label'))
      @$dropdown.addClass('hidden').appendTo('body')

    @showDropdown = ->
      @$dropdown.removeClass('hidden')

    @hideDropdown = ->
      @$dropdown.addClass('hidden')

    @position = (ev, data) ->

    @after('initialize', ->
      @prepMobileNav!
    )

  , mixins.managesAnimations, mixins.usesSassVars)
);