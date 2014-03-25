# How to Build/Run

From the root directory of the repository, run `npm install`, then run `gulp --require gulp-livescript`. 

That will download all the project’s dependencies and use gulp to compile the [Livescript](http://livescript.net/) and Sass files that make up the project. (You’ll need to have Sass 3.3 installed too; you can get that with `gem install sass`.).

The built version of the project, with all the compiled files, will show up in the `build` directory. You can then run `node server.js` to see the site. The whole thing is an Express app.

If you want to develop, you can run `gulp dev --require gulp-livescript` instead of the above version (without the `dev`), which will do less minification, so each rebuild is faster.

# Browser Support Goals
## Full Support
Chrome (30-33), Safari 7

## Partial Support (as much as possible)
IE 10-11, Firefox (26–28)

### Minimal Support
IE9 and below

## X-Grade Support (i.e. untested)
Everything else

# Frontend issues…
- Pushstate: none, just uses hashes; animatable with skrollr-menu

- Responsiveness of left-hand col: JS (flexbox and absolute positioning with margin auto for vertical centering won’t be sufficiently animatable).

- Arrow: use an svg background-image (rather than the webkit-transform + border trick), and then animate background-position, so the click area doesn’t move.
- HSLA/RGBA: work out of the box
- Filters: replace calendar and logo with svgs, which we can then get animatable filters for in all browsers