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

    Gitnesse.configure do |config|
      config.repository_url = "git@github.com:hybridgroup/gitnesse-demo.wiki"
      config.annotate_results = true
      config.info = "Bob Martin's development laptop"
    end

## rake tasks

    $ rake gitnesse:pull
    $ rake gitnesse:push
    $ rake gitnesse:run
    $ rake gitnesse:info

## Usage In Rails 3

For Rails 3 the rake tasks should automatically just appear, as long as you have added the gitnesse gem to your Gemfile.

There is an example application using Rails 3 located here: [https://github.com/hybridgroup/gitnesse-example-rails](https://github.com/hybridgroup/gitnesse-example-rails)

## Usage In Sinatra

To use gitnesse in a Sinatra application, simple add this line of code to your Rakefile:

    require "gitnesse/tasks"

There is an example application using Sinatra located here: [https://github.com/hybridgroup/gitnesse-example-sinatra](https://github.com/hybridgroup/gitnesse-example-sinatra)

## Other Usage

Want to use plain old Gitnesse? There is an executable that requires the path to the configuration file:

    $ GITNESSE_CONFIG='./gitnesse_config.rb' gitnesse

## TODO

	- test git push back to git wiki
	- pluggable feature runners, so can be used with Spinach, Cucumber-JS, or ?

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
