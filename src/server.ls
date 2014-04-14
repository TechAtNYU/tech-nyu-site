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