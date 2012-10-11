[![Build Status](https://secure.travis-ci.org/Crunch09/contentr.png)](http://travis-ci.org/Crunch09/contentr)

# WARNING: Under heavy development

I think I should write that this gem is not yet production
ready. So you should probably wait a bit if you want
to use that.

# Contentr -  The embeddable CMS Engine

## Installation

First add contentr and the edge version of `carrierwave` to your Gemfile
```ruby
gem 'contentr', git: "git://github.com/Crunch09/contentr.git", branch: "activerecord""
gem 'carrierwave', git: 'git://github.com/jnicklas/carrierwave.git'
```

Then run the `bundle` command.

Copy the migrations and run them:

`rake contentr_engine:install:migrations db:migrate`

After that run the install generator.

`rails g contentr:install`

In order to use `contentr` properly you need to override two methods in your **ApplicationController**:

`contentr_authorized?` and `contentr_publisher?`