## contentr [![Build Status](https://travis-ci.org/metaminded/contentr.svg?branch=master)](https://travis-ci.org/metaminded/contentr)

## Requirements

* Ruby 2.0.0 or higher
* Rails 4.0.0 or higher
* [Bootstrap from Twitter](http://getbootstrap.com)

## Installation

Add `contentr` to your Gemfile:

```ruby
gem 'contentr', github: 'metaminded/contentr'
```

You'll also want to include `contentr` in your CSS

```css
@import 'contentr';
```

And in your `application.js`

```javascript
//= require contentr/contentr
```

## Usage

You get three new methods which you should override in your user model:

- `allowed_to_interact_with_contentr?`
- `allowed_to_use_paragraphs?`
- `contentr_authorized?`

The `contentr_authorized?` method takes two arguments which are `type` and `object`.
`type` is a symbol and either `:manage` or `:see`. `object` is the object for
which an action needs to be authorized.

The `allowed_to_use_paragraphs?` method is used to determine if a user is
allowed to use paragraphs, depending on multiple arguments. The first argument
is `area`, which is a String  with the name of the name of the effected area.
If the second parameter `subject` is set to a paragraph object
the method should only determine if a user is allowed to use the specified `subject`.