# Kaminari::Sinatra

kaminari-sinatra is a Kaminari paginator's adapter gem for Sinatra and Sinatra-based frameworks.


## Installation

Add this line to your Sinatra app's Gemfile:

```ruby
gem 'kaminari-sinatra'
```

And bundle.


## Usage

Bundling this gem just enables model-side features, such as <tt>Model#page</tt> and <tt>Model#per</tt>.
If you want to use view helpers, please explicitly <tt>register</tt> helpers in your Sinatra or Padrino app:

    register Kaminari::Helpers::SinatraHelpers

Or, you can implement your own awesome helper :)

More features are coming, and again, this is still experimental. Please let us know if you found anything wrong with the Sinatra support.


## Contributing

Pull requests are welcome on GitHub at https://github.com/kaminari/kaminari-sinatra.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
