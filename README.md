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

For Rails 3, create an initializer file config/initializer/gitnesse.rb like this:

    Gitnesse.config do |config|
      config.repository_url = "git@github.com:luishurtado/gitnesse-wiki.wiki"
    end

## Usage

For Rails 3 there is a rake task:

    $ rake gitnesse

Not Rails 3 ? There is available an executable that requires the path to the configuration file:

    $ CONFIG='./gitnesse_config.rb' gitnesse

## Usage

For Rails 3 there is a rake task:

## TODO

		- implement git push back to git wiki
		- rake tasks for push/pull/run

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
