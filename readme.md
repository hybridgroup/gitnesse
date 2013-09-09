# Gitnesse

Gitnesse is an acceptance testing tool, enabling a project to store Cucumber
feature stories in a git-based wiki, test them against the code, and then update
the wiki with the latest test results.

Because the features are in a wiki, non-programmers can see them more easily,
and edit them using the wiki.

Gitnesse provides an awesome bi-directional testing flow between developers and
non-developers on a team.

Conceptually influenced by [Fitnesse][]. Thanks, Uncle Bob!

## Table Of Contents
- [Installation](#installation)
- [Dependencies](#dependencies)
- [Config](#config)
- [Tasks](#tasks)
    - [Pull](#pull)
    - [Push](#push)
    - [Run](#run)
    - [Info](#info)
- [~/.gitnesse](#gitnesse)
- [Contributing](#contributing)

## Installation

You can add Gitnesse to your project's Gemfile:

```ruby
gem 'gitnesse'
```

Or install it manually (recommended):

```
gem install gitnesse
```

Now add a `gitnesse.rb` file to your project. This will be used to configure
Gitnesse's behaviour.

An example config file:

```ruby
# ~/dev/awesome_rails_app/config/
Gitnesse::Config.config do |c|
  c.repository_url = "git@github.com:hybridgroup/gitnesse.wiki.git"
  c.annotate_results = true
  c.identifier = "Uncle Bob's Laptop"
end
```

A full description of each config option can be found in the [Config](#config)
section.


## Dependencies

Gitnesse has a few dependencies it needs to function properly:

1. Git must be installed
2. Cucumber must be installed and globally accessible (`gem install cucumber`)

## Config

Gitnesse loads config values from a `gitnesse.rb` file in your project. The
available configuration options are:

- **repository_url** - the Git URL to the remote git-based wiki you'd like to
  use with Gitnesse. We recommend using the SSH url
  (e.g `git@github.com:hybridgroup/gitnesse.wiki.git`)
- **features_dir** - the local directory Cucumber features are store in. This
  defaults to `features`.
- **branch** - The git branch of the remote wiki to use. Defaults to `master`.
- **annotate_results** - Boolean, determines if Gitnesse will annotate Cucumber
  results to wiki pages when `gitnesse run` is called. Defaults to `false`.
- **identifier** - If annotate_results is true, an identifier to use to indicate
  who ran the results. e.g. `Uncle Bob's Laptop`.

## Tasks

Gitnesse comes with a few commands:

```
gitnesse pull
gitnesse push
gitnesse run
gitnesse info
gitnesse help
```

All of these commands are also available as Rake tasks, if you've added Gitnesse
to your Gemfile:

```
rake gitnesse:pull
rake gitnesse:push
rake gitnesse:run
rake gitnesse:info
```

If you're using Gitnesse with a Rails app, these rake tasks will be hooked up
automatically. If you're not using Rails, but still want the rake tasks, add
this line to your Rakefile:

```ruby
require 'gitnesse/tasks'
```

### pull

`gitnesse pull` pulls features from the remote git wiki, and updates/replaces
the relevant local features. It also creates new local features if they don't
already exist.

### push

`gitnesse push` pushes local features to the remote git wiki,
updating/replacing/creating as necessary. It also adds index pages, so for
example if your `features` folder looked like this:

```
features
├── purchasing
│   ├── purchasing.feature
└── subscribing
    ├── subscriping_logged_in.feature
    ├── subscribing_logged_out.feature
    └── subscribing_fail.feature
```

Gitnesse would create these wiki pages:

```
features.md
features > purchasing.md
features > purchasing > purchasing.feature.md
features > subscribing.md
features > subscribing > subscriping_logged_in.feature.md
features > subscribing > subscribing_logged_out.feature.md
features > subscribing > subscribing_fail.feature.md
```

### run

`gitnesse run` pulls remote wiki features to local, similarly to `gitnesse
pull`, but then it runs Cucumber on the updated feature. If the
**annotate_results** settings is enabled, it will push annotated Cucumber
results for each feature scenario to the remote wiki.

### info

`gitnesse info` prints the current Gitnesse configuration info. Useful for
debugging purposes and sanity checking.

## ~/.gitnesse

To store local copies of your remote wikis, Gitnesse creates a hidden folder in
your home folder called `~/.gitnesse`. The wikis are stored in the project
folder, so for example if you have a project called 'awesome_rails_app', it's
wiki would appear in `~/.gitnesse/awesome_rails_app`

## Contributing

First of all, thanks! We appreciate any help you can give Gitnesse.

The main way you can contribute is with some code! Here's how:

1. [Fork](https://help.github.com/articles/fork-a-repo) Gitnesse
2. Create a topic branch: `git checkout -b my_awesome_feature`
3. Push to your branch - `git push origin my_awesome_feature`
4. Create a [Pull Request](http://help.github.com/pull-requests/) from your branch
5. That's it!

We use RSpec for testing. Please include tests with your pull request. A simple
`bundle exec rake` will run the suite. Also, please try to [TomDoc][] your
methods, it makes it easier to see what the code does and makes it easier for
future contributors to get started.

[Fitnesse]: http://fitnesse.org/
[TomDoc]: http://tomdoc.org/
