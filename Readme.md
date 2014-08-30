# Tech@NYU Website
This is the source for Tech@NYU's awesome website.

## Getting Started
### Download the Dependencies
To install the project's dependencies, run the following commands at the root
of the directory:
```bash
# The following gems are necessary for compiling the Sass files.
gem install sass
gem install sass-globbing
gem install compass --pre
gem install breakpoint

# For compiling the LiveScript and Sass files.
npm install gulp -g
npm install
```

### Build/Run
The following command compiles the [LivesScript](http://livescript.net/) and
[Sass](http://sass-lang.com/) files that make up the project:
```
gulp --require gulp-livescript.
```

To start the server, run `node server.js` in the `build/` directory. This
project is an Express app; to preview the site, visit `localhost:3000` in a web
browser.

If you want to develop so that the `gulp` does less minification (speeding up
build time), run
```
gulp dev --require-livescript
```


## Browser Support Goals
### Full Support
Chrome (30-33), Safari 7

### Partial Support (as much as possible)
IE 10-11, Firefox (26–28)

### Minimal Support
IE9 and below

### X-Grade Support (i.e. untested)
Everything else
