# css2sass #

[http://css2sass.heroku.com/](http://css2sass.heroku.com/)

css2sass is a simple sinatra app that Convert CSS Snippets to Syntactically Awesome StyleSheets code.

Is is heavily inspired by the [html2haml app](http://html2haml.heroku.com/)

You simply copy your CSS in the first box and click convert, then see the results in the Sass box below.

## Api ##

You can also run the convert via a RestClient or Curl Client, by posting your html in the page_html parameter.

It currently works properly with json and xml.

### Testing

[RSpec](http://wiki.github.com/dchelimsky/rspec)

[Sinatra testing](http://www.sinatrarb.com/testing.html)

Sinatra now relies on Rack::Test and has deprecated the use of Sinatra::Test.

`sudo gem install rack-test`

See `css2sass_spec.rb`

### TODO

*    Add suport for the new [SCSS syntax](http://sass-lang.com/docs/yardoc/file.SASS_REFERENCE.html)

### Resources

*    [Sinatra](http://www.sinatrarb.com) 
*    [Mongodb](http://www.mongodb.org)
*    [SASS](http://sass-lang.com/)

### Note on Patches/Pull Requests

Fork the project.
Make your feature addition or bug fix.
Add tests for it. This is important so I don’t break it in a future version unintentionally.
Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
Send me a pull request. Bonus points for topic branches.

### Copyright

Copyright 2009 Jose Pablo Barrantes. MIT Licence, so go for it.
