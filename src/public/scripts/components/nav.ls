define(["flight/component", "mixins", "jquery"], (defineComponent, mixins, $) ->

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

    @setAnimations = ->
      # if design = large & mode = paginated
         # find second panel's offset, which is when it starts coming up, is dummy
         /*
    $firstPanelUpEnd: $firstPanelUpStart + $interPanelDistance;
    $colorChangeStartDelay: 65;
    #{$firstPanelUpEnd + $firstPanelExtraPause + $onPanelPause} {
       dummy: true;
    }

    @for $i from 1 through 5 {
        @if($i==1) {
          #{$firstPanelUpEnd + $firstPanelExtraPause + $i*($interPanelDistance + $onPanelPause)} {
            background-color: toRgbString(nth($sectionColors, $i+1), true);
            color: toRgbString(nth($navInactiveTextColors, $i+1), true);
            fill: toRgbString(nth($navInactiveTextColors, $i+1), true);
          }
        }
          #{$firstPanelUpEnd + $firstPanelExtraPause + $i*($interPanelDistance + $onPanelPause) + $onPanelPause + $colorChangeStartDelay} {
            dummy: true;
          }
        @if($i!=5) {
          #{$firstPanelUpEnd + $firstPanelExtraPause + ($i+1)*($interPanelDistance + $onPanelPause)} {
            background-color: toRgbString(nth($sectionColors, $i+2), true);
            color: toRgbString(nth($navInactiveTextColors, $i+2), true);
            fill: toRgbString(nth($navInactiveTextColors, $i+2), true);
          }
        }
    }*/


    @after('initialize', ->
      @prepMobileNav!
      @on(window, \sectionsAnimatedOffsetsTopChange, $.proxy(@setAnimations, @))
    )

  , mixins.managesAnimations, mixins.usesSassVars)
);