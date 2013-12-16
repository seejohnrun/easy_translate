## EasyTranslate

[![Build Status](https://secure.travis-ci.org/seejohnrun/easy_translate.png)](http://travis-ci.org/seejohnrun/easy_translate)

I looked around a bit for a google translate library in Ruby that would perform bulk calls and handle user_ips and API keys properly.  There didn't seem to be any, so I made one.

---

### Installation

    $ gem install easy_translate

Or in your Gemfile:
```ruby
gem 'easy_translate'
```
---

### Single translation

```ruby
# auto-detect
EasyTranslate.translate('Hello, world', :to => :spanish) # => "Hola, mundo"
EasyTranslate.translate('Hello, world', :to => 'es') # => "Hola, mundo"

# feel free to specify explicitly 
EasyTranslate.translate('Hola, mundo', :from => :spanish, :to => :en) # => "Hello, world"
```

---

### Batch translation (Yay!)

```ruby
# multiple strings
EasyTranslate.translate(['Hello', 'Goodbye'], :to => :spanish) # => ["¡Hola", "Despedida"]

EasyTranslate.detect(['hello', 'hola, mundo']) # => ['en', 'es']
```

---

### Catalog translation

You can translate your locale messages from one of your locale dictionaries into one or more
other languages. This can be done destructively when you want to build clean versions, or
non-destructively if you want to avoid modifying any of the hand tuned values in your translations.

```ruby
# destructive translation - just to be sure we get updates to some of the old entries
EasyTranslate.tranlate_catalog!('config/locales/en.yml', 'sp', 'fr', 'de')

# non-destructive translation - don't tread on the finely tuned translations, but get the
# new items that were added since last time.
EasyTranslate.tranlate_catalog('config/locales/en.yml', 'sp', 'fr', 'de')
```

---

### API Keys

```ruby
# make google happy - (NOTE: use these anywhere)
EasyTranslate.translate('Hello, world', :to => :es, :key => 'xxx')

# don't want to set the key on every call? ** Me either! **
EasyTranslate.api_key = 'xxx'
```

---

### Because you might be greedy and want detection, too

```ruby
# detect language
EasyTranslate.detect "This is definitely English!" # => 'en'
```

### What if everything is buried in html?

```ruby
# mention that you're submitting HTML (translate calls only)
EasyTranslate.translate("<b>Hello</b>", :html => true) # => "<b>¡Hola</b>"
```

---

### List of languages

```ruby
# list from <http://translate.google.com/>
EasyTranslate::LANGUAGES # => { 'en' => 'english', ... }
```

### List of supported languages

```ruby
# List all languages (from API)
EasyTranslate.translations_available

# List all languages supported by some language
EasyTranslate.translations_available('zh-CN')
```

---

### EasyTranslate in PHP

[Kofel](https://github.com/Kofel) ported this library to PHP. 
You can find the port [on GitHub](https://github.com/Kofel/EasyTranslate)

---

### Contributors

* John Crepezzi - john.crepezzi@gmail.com
* Guy Maliar - gmaliar@gmail.com

Full contributor data at:
https://github.com/seejohnrun/easy_translate/contributors

---

### License

(The MIT License)

Copyright © 2010-2011 John Crepezzi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ‘Software’), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
