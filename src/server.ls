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
    * name: "Freshman Circuit"
      facebook: ""
      meetup: ""
    * name: "Design"
      facebook: ""
    * name: "Programming"
      facebook: ""
    * name: "Business"
      facebook: ""
    * name: "Gaming"
      facebook: ""

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

# to do. what should the response be (more optional fields, social media links, other?)
app.post('/subscribe', ->

)

app.use(express.static(__dirname + '/public'));
app.listen(3000)