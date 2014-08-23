require! {
    express
    nunjucks
    nunjucks-helper: "./helpers/nunjucks"
}

app = express!
env = nunjucks.configure(__dirname + '/views', { autoescape: true, express: app })
for own name, filter of nunjucks-helper.filters
  env.addFilter(name, filter)

data = 
  now: new Date!

  gaKey: 'UA-39634458-2'

  promo:
    shortTitle: "Join our team!"
    shortDescription: "We're looking for new students to join our board."
    moreInfoUrl: "http://www.techatnyu.org/apply"
    isEvent: false

  sponsors:
    * name: "Meetup"
      img: "meetup.png"    
    * name: "Rackspace"
      img: "rackspace.jpg"
      url: ""
    * name: "Quirky"
      img: "quirky.gif"
      url: ""
    * name: "Pearson"
      img: "pearson.png"
      url: ""
    * name: "artsicle"
      img: "artsicle.png"
      url: ""
    * name: "Bitly"
      img: "bitly.png"
      url: ""
    * name: "Branch"
      img: "branch.png"
      url: ""
    * name: "chatID"
      img: "chatid.png"
      url: ""
    * name: "Codecademy"
      img: "codecademy.png"
      url: ""
    * name: "Craft Coffee"
      img: "craftcoffee.jpg"
      url: ""
    * name: "Github"
      img: "github.png"
      url: ""
    * name: "hackNY"
      img: "hackny.png"
      url: ""
    * name: "Knewton"
      img: "knewton.jpg"
      url: ""
    * name: "Lean Startup Machine"
      img: "leanstartupmachine.png"
      url: ""
    * name: "MailChimp"
      img: "mailchimp.jpeg"
      url: ""
    * name: "Onswipe"
      img: "onwsipe.png"
      url: ""
    * name: "Pivotal Labs"
      img: "pivotal.png"
      url: "" 
    * name: "PopTip"
      img: "poptip.jpg"
      url: ""
    * name: "RebelMouse"
      img: "rebelmouse.png"
      url: ""
    * name: "SeatGeek"
      img: "seatgeek.jpg"
      url: ""
    * name: "Squarespace"
      img: "squarespace.jpg"
      url: ""
    * name: "Techstars"
      img: "techstars.jpg"
      url: ""
    * name: "I Heart NY Tech Week 2013"
      img: "tw_nyc.png"
      url: ""
    * name: "NYU"
      img: "nyu_stacked_color.jpg"
      url: ""
    * name: "CaterCow"
      img: "catercow.jpg" 
      url: ""

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

app.get('/', (req, res) ->
  res.render('home.tmpl', data, (err, html) ->
    if err then console.log(err);
    res.send(html);
  )
  void
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

app.get(\/apply, (req, res) ->
  localData = require('./data/applications')
  localData[\now, \gaKey] = data[\now, \gaKey]
  res.render("applications.tmpl", localData);
)

# to do. what should the response be (more optional fields, social media links, other?)
app.post('/subscribe', ->

)

app.use(express.static(__dirname + '/public'));

# 404 handler
app.use((req, res, next) ->
  res.render("404.tmpl", data);
)
app.listen(3000)