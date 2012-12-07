# Gitnesse

 Gitnesse is an acceptance testing tool.

 It enables a project to store Cucumber feature stories in a git-based wiki, test them against your code, and then update the wiki with the latest test results.

 The advantage is, that the features are on a wiki, so non-programmers can see them, and edit using the wiki. Hence an awesome bi-directional testing flow between developers and non-developers on a team.

 Conceptually influenced by Fitnesse http://fitnesse.org/ thank you Uncle Bob!

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
    $ rake gitnesse:push_results

## Usage In Rails 3

For Rails 3 the rake tasks should automatically just appear, as long as you have added the gitnesse gem to your Gemfile.

There is an example application using Rails 3 located here: [https://github.com/hybridgroup/gitnesse-example-rails](https://github.com/hybridgroup/gitnesse-example-rails)

## Usage In Sinatra

To use gitnesse in a Sinatra application, simple add this line of code to your Rakefile:

    require "gitnesse/tasks"

There is an example application using Sinatra located here: [https://github.com/hybridgroup/gitnesse-example-sinatra](https://github.com/hybridgroup/gitnesse-example-sinatra)

## Other Usage

Want to use plain old Gitnesse? There is an executable, if you're allergic to rake tasks:

    $ gitnesse


## TODO

    - pluggable feature runners, so can be used with Spinach, Cucumber-JS, or ?
    - standalone server so end users to run tests and see live results, just like Fitnesse

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
