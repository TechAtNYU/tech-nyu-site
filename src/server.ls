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
    * name: "Getting Started with the Tech Scene"
    * name: "Improve Your Skills"
    * name: "Build & Socialize with Cool People"
    * name: "Follow the Latest in Tech"
    * name: "About Us"
    * name: "Event Calendar"

app.get('/', (req, res) ->
  res.render('home.tmpl', data, (err, html) ->
    console.log(err);
    res.send(html);
  )
  void
)

# to do. what should the response be (more optional fields, social media links, other?)
app.post('/subscribe', ->

)

app.use(express.static(__dirname + '/public'));
app.listen(3000)