require! {
    express
    nunjucks
    nunjucks-helper: "./helpers/nunjucks"
    request
    Q: "q"
}

app = express!
env = nunjucks.configure(__dirname + '/views', { autoescape: true, express: app })
for own name, filter of nunjucks-helper.filters
  env.addFilter(name, filter)

data = 
  now: new Date!

  #promo:
    #shortTitle: "Back Soon"
    #shortDescription: "Tech@NYU's enjoying summer break, but we'll be back with more events in a couple weeks."
    #moreInfoUrl: "http://www.techatnyu.org/apply"
    #isEvent: false

  gaKey: 'UA-39634458-2'

  sponsors: require('./data/sponsors')

  channels:
    "Freshman Circuit": 
      facebook: "https://www.facebook.com/groups/814357601925669/"
      meetup: ""
    "Design":
      facebook: "https://www.facebook.com/groups/767396439957423/"
    "Programming":
      facebook: "https://www.facebook.com/groups/1392655554348086/"
    "Business":
      facebook: "https://www.facebook.com/groups/574494619324143/"
    "Gaming":
      facebook: "https://www.facebook.com/groups/453344364799579/"

  sections:
    * name: "Get Started with the Tech Scene"
      anchor: "get-started"
    * name: "Improve Your Skills"
      anchor: "improve-your-skills"
    * name: "Build & Socialize with Cool People"
      shortName: "Build & Socialize with Others"
      anchor: "build-and-socialize"
    * name: "Follow the Latest in Tech"
      anchor: "latest-in-tech"
    * name: "About Us"
      anchor: "about"
      shortName: "About"
    * name: "Event Calendar"
      anchor: "event-calendar"

updateData = ->
  if data.promo?.isEvent
    Q.nfcall(request,
      url: 'https://api.tnyu.org/v1.0/events/up-next-publicly'
      rejectUnauthorized: false
      method: "GET"
    ).then(([response, body]) -> 
      if response.statusCode == 200 && body
        nextEvent = JSON.parse(body).events

        if nextEvent
          data.promo = 
            shortTitle: nextEvent.shortTitle
            shortDescription: nextEvent.description
            moreInfoUrl: nextEvent.rsvpUrl
            isEvent: true
    )

  setTimeout(updateData, 3600000)
  void

# update data on start, which will then re-run itself once an hour
updateData!

app.get('/', (req, res) ->
  res.render('home.tmpl', data, (err, html) ->
    if err then console.log(err);
    res.send(html);
  )
)

app.get(/^\/anti-harassment\/?$/, (req, res) ->
  res.render("anti-harassment.tmpl", data);
)
app.get(/^\/team\/?$/, (req, res) ->
  res.redirect('http://ship.techatnyu.org/#board');
)

app.get(/\/job\-board\/?/, (req, res) ->
  res.redirect('https://tech-nyu.squarespace.com/job-board/');
)

app.get(/^\/apply-now\/?$/, (req, res) ->
  localData = require('./data/applications')
  localData[\now, \gaKey] = data[\now, \gaKey]
  res.render("applications.tmpl", localData);
)

# to do. what should the response be (more optional fields, social media links, other?)
app.post('/subscribe', ->

)

app.use(express.compress());
app.use(express.static(__dirname + '/public'));

# 404 handler
app.use((req, res, next) ->
  if req.url is /^\/apply/
    res.render("404.tmpl", {customMessage: "Applications are closed :/"} <<< data)
  else res.render("404.tmpl", data)
)
app.listen(3000)
