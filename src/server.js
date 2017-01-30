var express = require('express');
var nunjucks = require('nunjucks');
var nunjucksHelper = require('./helpers/nunjucks');
var request = require('request');
var Q = require('q');

var app = express();
var env = nunjucks.configure(
  __dirname + '/views',
  { autoescape: true, express: app }
);

var filter;
for (var name in nunjucksHelper.filters) {
  if (Object.prototype.hasOwnProperty.call(nunjucksHelper.filters, name)) {
    filter = nunjucksHelper.filters[name];
    env.addFilter(name, filter);
  }
}

var data = {
  now: new Date(),
  gaKey: 'UA-39634458-2',
  sponsors: require('./data/sponsors'),
  channels: {
    "Freshman Circuit": {
      facebook: "https://www.facebook.com/groups/814357601925669/",
      meetup: ""
    },
    "Design": {
      facebook: "https://www.facebook.com/groups/767396439957423/"
    },
    "Programming": {
      facebook: "https://www.facebook.com/groups/1392655554348086/"
    },
    "Business": {
      facebook: "https://www.facebook.com/groups/574494619324143/"
    },
    "Gaming": {
      facebook: "https://www.facebook.com/groups/453344364799579/"
    }
  },
  sections: [
    {
      name: "Get Started with the Tech Scene",
      anchor: "get-started"
    }, {
      name: "Improve Your Skills",
      anchor: "improve-your-skills"
    }, {
      name: "Build & Socialize with Cool People",
      shortName: "Build & Socialize with Others",
      anchor: "build-and-socialize"
    }, {
      name: "Follow the Latest in Tech",
      anchor: "latest-in-tech"
    }, {
      name: "About Us",
      anchor: "about",
      shortName: "About"
    }, {
      name: "Event Calendar",
      anchor: "http://cal.techatnyu.org/"
    }
  ],
  customShortUris: {
    'tufte': 'https://www.eventbrite.com/e/edward-tufte-data-visualization-master-class-tickets-16049397179'
  }
};

var updateData = function() {
  data.promo = undefined;
  if (data.specialPromo) {
    data.promo = data.specialPromo;
  }

  else {
    Q.nfcall(request, {
      url: 'https://api.tnyu.org/v2/events/up-next-publicly',
      rejectUnauthorized: false,
      method: "GET"
    }).then(function(result){
      var response = result[0];
      var body = result[1];
      var nextEvent;

      if (response.statusCode === 200 && body) {
        nextEvent = JSON.parse(body).data.attributes;
        if (nextEvent) {
          return data.promo = {
            shortTitle: nextEvent.shortTitle,
            shortDescription: nextEvent.description,
            moreInfoUrl: nextEvent.rsvpUrl,
            isEvent: true
          };
        } else {
          return data.promo = undefined;
        }
      }
    });
  }
  setTimeout(updateData, 3600000);
};

updateData();

app.get('/', function(req, res){
  return res.render('home.tmpl', data, function(err, html){
    if (err) {
      console.log(err);
    }
    return res.send(html);
  });
});

app.get(/^\/anti-harassment\/?$/, function(req, res){
  return res.render("anti-harassment.tmpl", data);
});

app.get(/^\/team\/?$/, function(req, res){
  return res.redirect('http://ship.techatnyu.org/#board');
});

app.get(/\/job\-board\/?/, function(req, res){
  return res.redirect('http://jobs.techatnyu.org/');
});

//app.get(/^\/apply-now\/?$/, function(req, res){
//  var localData, ref$;
//  localData = require('./data/applications');
//  ref$ = [data['now'], data['gaKey']], localData['now'] = ref$[0], localData['gaKey'] = ref$[1];
//  return res.render("applications.tmpl", localData);
//});

app.post('/subscribe', function(){});

for(var path in data.customShortUris) {
  (function(path) {
    app.get(new RegExp("^\/" + path + "\/?$"), function(req, res) {
      return res.redirect(data.customShortUris[path]);
    });
  })(path);
}

app.use(express.compress());
app.use(express['static'](__dirname + '/public'));

// 404 handler
app.use(function(req, res, next){
  if (/^\/apply/.exec(req.url)) {
    return res.render("404.tmpl", import$({
      customMessage: "Applications are closed :/"
    }, data));
  } else {
    return res.render("404.tmpl", data);
  }
});

app.listen(3000);

function import$(obj, src){
  var own = {}.hasOwnProperty;
  for (var key in src) if (own.call(src, key)) obj[key] = src[key];
  return obj;
}
