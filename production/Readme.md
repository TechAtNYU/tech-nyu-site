# Desired Browser Support
## Full Support
Chrome (30-33), Safari 7

## Partial Support (as much as possible)
IE 10-11, Firefox (26–28)

### Minimal Support
IE9 and below

## X-Grade Support (i.e. untested)
Everything else

# Stack
Node + Express, Plz for building (with Sass), Livescript

# Frontend issues…
- Pushstate: none, just uses hashes; animatable with skrollr-menu

- Responsiveness of left-hand col: JS (flexbox and absolute positioning with margin auto for vertical centering won’t be sufficiently animatable).

- Arrow: use an svg background-image (rather than the webkit-transform + border trick), and then animate background-position, so the click area doesn’t move.
- HSLA/RGBA: work out of the box
- Filters: replace calendar and logo with svgs, which we can then get animatable filters for in all browsers