# Kaminari::Sinatra

kaminari-sinatra is a Kaminari paginator's adapter gem for Sinatra and Sinatra-based frameworks.

Note that this gem does not contain model-side features, such as <tt>Model#page</tt> and <tt>Model#per</tt>.
They are contained in gems for each ORM, [kaminari-activerecord](https://github.com/kaminari/kaminari/tree/master/kaminari-activerecord) for example.

## Installation

Add this line to your Sinatra app's Gemfile:

```ruby
gem 'kaminari-sinatra'
```

And bundle.

## Usage

`register` view helpers in your Sinatra or Padrino app:

    register Kaminari::Helpers::SinatraHelpers

Or, you can implement your own awesome helper :)

More features are coming, and again, this is still experimental. Please let us know if you found anything wrong with the Sinatra support.


## Contributing

Pull requests are welcome on GitHub at https://github.com/kaminari/kaminari-sinatra.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
