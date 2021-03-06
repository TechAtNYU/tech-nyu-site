# Tech@NYU Website

[![Circle CI](https://circleci.com/gh/TechAtNYU/tech-nyu-site/tree/master.svg?style=svg)](https://circleci.com/gh/TechAtNYU/tech-nyu-site/tree/master)

This is the source for Tech@NYU's awesome website.

## Getting Started
### Download the Dependencies
To install the project's dependencies, run the following commands at the root
of the directory:
```bash
# bundle install is sorta like the ruby equivalent of
# npm install (though you need to install bundler first)
gem install bundler
bundle install

# For compiling the LiveScript and Sass files.
npm install gulp -g
npm install
```

### Build/Run
The following command compiles the [Sass](http://sass-lang.com/) files that
make up the project and puts everything in the build directory. To do this, it
runs gulp through bundler, which makes sure the correct ruby dependencies are used:
```
bundle exec gulp
```

To start the server, run `node build/server.js` from the project's root
directory. This project is an Express app; to preview the site, visit
`localhost:3000` in a web browser.

During development, you can have `gulp` do less minification (which makes
debugging easier and speeds up the build time), by running:
```
bundle exec gulp dev
```

### Architecture
#### Flight
This repo uses [flight](https://github.com/flightjs/flight) to build the webpage out of independent [components](https://github.com/TechAtNYU/tech-nyu-site/tree/master/src/public/scripts/components) that communicate with one another by sending out and responding to events. These components [can be](https://github.com/flightjs/flight/blob/master/doc/mixin_api.md) augmented by composable [mixins](https://github.com/TechAtNYU/tech-nyu-site/blob/master/src/public/scripts/mixins.ls). This architecture, which is used by Twitter, makes the coupling between the different parts of the page much looser, so the resulting code is less brittle, and each component is fully testable in isolation.

#### Animations
Once you've grocked the flight architecture, the only other big thing to understand is how the animations are set up. Basically, different components can register animations ([example](https://github.com/TechAtNYU/tech-nyu-site/blob/master/src/public/scripts/components/nav.ls#L33)) using the [animate mixin](https://github.com/TechAtNYU/tech-nyu-site/blob/master/src/public/scripts/mixins.ls#L43), which stores the animation instructions for each element in that element's DOM node on a `data-` attribute. These `data-` attributes encode all of that node's animation instructions at each different design mode. (There are two design modes: large and small.) Then, a heavily-modified [skrollr-stylesheets](https://github.com/ethanresnick/skrollr-stylesheets/) [keeps track](https://github.com/ethanresnick/skrollr-stylesheets/blob/master/src/skrollr.stylesheets.js#L102) of which design mode is in view and loads only that mode's animations into the main [skrollr](https://github.com/Prinzhorn/skrollr). (The skrollr library wasn't built for responsive design and can only handle one set of animations at a time, hence the need for skrollr-stylesheets to switch the animation instruction sets in and out as the design mode changes.)

This picture is complicated a bit by the need to actually move around some elements in the DOM when the design mode, as not all the layout adjustments were possible with just CSS. Those changes are handled in the [skrollr component](https://github.com/TechAtNYU/tech-nyu-site/blob/master/src/public/scripts/components/skrollr.ls#L51), which in turn just sets up listeners for the `'designModeChange'` event. That event is thrown by the [designSwitcher component](https://github.com/TechAtNYU/tech-nyu-site/blob/master/src/public/scripts/components/designSwitcher.ls), which is just a really nice way to centralize keeping track of which design mode is currently being used and when the design mode changes, so that every single component doesn't have to track this stuff on it's own; other components can just listen to the `designModeChange` event.

## Browser Support Goals
### Full Support
Chrome (30-33), Safari 7

### Partial Support (as much as possible)
IE 10-11, Firefox (26–28)

### Minimal Support
IE9 and below

### X-Grade Support (i.e. untested)
Everything else
