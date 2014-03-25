require! {
    express
    nunjucks
}

app = express!
app.use(express.static(__dirname + '/public'));
nunjucks.configure(__dirname + '/views', { autoescape: true, express: app })

data = 
  now: new Date!

app.get('/', (req, res) ->
  res.render('home.tmpl', data, (err, html) ->
    res.send(html);
  )
  void
)

# to do. what should the response be (more optional fields, social media links, other?)
app.post('/subscribe', ->

)

app.listen(3000)