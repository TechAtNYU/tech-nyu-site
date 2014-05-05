# How to Build/Run

From the root directory of the repository, run `npm install`, then run `gulp --require gulp-livescript` (`npm install gulp -g`). 

That will download all the project’s dependencies and use gulp to compile the [Livescript](http://livescript.net/) and Sass files that make up the project. (For compiling the Sass, you'll need to have Sass 3.3, Compass, and Breakpoint installed too; you can get those with `gem install sass`, `gem install compass --pre`, and `gem install breakpoint` respectively.).

The built version of the project, with all the compiled files, will show up in the `build` directory. You can then run `node server.js` from the `build` directory to start the server. The whole thing is an Express app. To actually see the site, then visit `localhost:3000` in a browser.

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
