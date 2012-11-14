# Gitnesse

 Gitnesse is a Cucumber-wiki integration tool.
 It enables a project to store cucumber features in a git-based wiki, and then test them against your code.
 Conceptually influenced by Fitnesse http://fitnesse.org/

## Installation

Add this line to your application's Gemfile:

    gem 'gitnesse'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gitnesse

Create a `gitnesse.rb` file somewhere in your project, and add something like
the following to it:

    Gitnesse.config do
      repository_url "git@github.com:hybridgroup/gitnesse-demo.wiki"
    end

## Usage In Rails 3

For Rails 3 there is a rake task:

    $ rake gitnesse

There is an example application using Rails 3 located here: [https://github.com/hybridgroup/gitnesse-example-rails](https://github.com/hybridgroup/gitnesse-example-rails)

## Usage In Sinatra

For Sinatra there is a rake task:

    $ rake gitnesse

There is an example application using Sinatra located here: [https://github.com/hybridgroup/gitnesse-example-sinatra](https://github.com/hybridgroup/gitnesse-example-sinatra)

## Other Usage

Want to use plain old Gitnesse? There is an executable that requires the path to the configuration file:

    $ GITNESSE_CONFIG='./gitnesse_config.rb' gitnesse

## TODO

Keep tunned.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
