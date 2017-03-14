[![Build Status](https://semaphoreci.com/api/v1/shlima/translate_enum/branches/master/shields_badge.svg)](https://semaphoreci.com/shlima/translate_enum)
[![Code Climate](https://codeclimate.com/github/shlima/translate_enum/badges/gpa.svg)](https://codeclimate.com/github/shlima/translate_enum)

# TranslateEnum

Simple, zero-dependant `enum` translation gem for Rails

## Installation

`gem install translate_enum`

## Usage

Here is a regular use case. ActiveRecord model:

```ruby
class Post < ActiveRecord::Base
  include TranslateEnum
  
  enum status: { published: 0, archive: 1 }
  translate_enum :status
end
```

Localization file

```yaml
en:
  activerecord:
    attributes:
      post:
        status_list:
          published: Was published
          archive: Was archived
```

```ruby
Post.translated_status(:published) #=> "Was published"
Post.translated_statuses => [["Was published", :published, 0], ["Was archived", :archive, 1]]

@post = Post.new(status: :published)
@post.translated_status #=> "Was published"
```

### Use in a Form

```haml
= form_for @post do |f|
  = f.select :status, options_for_select(f.object.class.translated_statuses.map { |translation, k, _v| [translation, k] })
```

## Extending ActiveRecord

Be default you should extend each `ActiveRecord` model manually by including `TranslateEnum` module in it.
You can extend `ActiveRecord` by requiring `translate_enum/active_record` in initializer or inside yout `Gemfile`:

Gemfile:

```ruby
gem 'translate_enum', require: 'translate_enum/active_record'
```

Initializer:

```ruby
# config/initializers/translate_enum.rb
require 'translate_enum/active_record'
```

## Advanced options

```ruby
class User < ActiveRecord::Base
  enum gender: [:male, :female]
  
  translate_enum :gender do |tr|
    tr.i18n_scope = 'activerecord.attributes'
    tr.i18n_key = 'gender_list'
    tr.enum_klass_method_name = 'genders'
    tr.enum_instance_method_name = 'gender'
    tr.method_name_singular = 'translated_gender'
    tr.method_name_plural = 'translated_genders'
  end
  
  # Or even provide your own logic
  def self.translated_gender(key)
    I18n.t(key, scope: 'global.gender_list')
  end
end
```
