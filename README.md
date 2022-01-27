## EasyTranslate

[![Build Status](https://secure.travis-ci.org/seejohnrun/easy_translate.png)](http://travis-ci.org/seejohnrun/easy_translate)

This is a Ruby library for Google Translate that makes working with bulk calls,
user_ips and access via API Key easy.

---

### Installation

```bash
$ gem install easy_translate
```

Or in your Gemfile:

```ruby
gem 'easy_translate'
```

---

## Single translation

```ruby
# auto-detect
EasyTranslate.translate('Hello, world', to: :spanish) # => "Hola, mundo"
EasyTranslate.translate('Hello, world', to: 'es') # => "Hola, mundo"

# feel free to specify explicitly
EasyTranslate.translate('Hola, mundo', from: :spanish, to: :en) # => "Hello, world"
```

## Batch translation (Yay!)

```ruby
# multiple strings
EasyTranslate.translate(['Hello', 'Goodbye'], to: :spanish) # => ["¡Hola", "Despedida"]
```

## API Keys

```ruby
# make google happy - (NOTE: use these anywhere)
EasyTranslate.translate('Hello, world', to: :es, key: 'xxx')

# don't want to set the key on every call? ** Me either! **
EasyTranslate.api_key = 'xxx'
```

## You want language detection too?

```ruby
# detect language
EasyTranslate.detect "This is definitely English!" # => 'en'
```

## Batch detection (Woohoo!)

```ruby
# detect language
EasyTranslate.detect ['Hello World', '我姓譚'] # => ['en', 'zh-CN']
```

## Need confidence in your detections?

```ruby
# detect language with confidence
EasyTranslate.detect "This is definitely English!", confidence: true # => { :language => 'en', :confidence => 0.77272725 }
```

```ruby
# detect batch languages with confidence
EasyTranslate.detect ['This is definitely English!', '我姓譚'], confidence: true # => [{ :language => 'en', :confidence => 0.77272725 }, { :language => 'zh-CN', :confidence => 1.0 }]
```

## Explicitly select translation model (NMT, PBMT)
Google Translate now replaces Phrase Based Machine Translation (PBMT) with Neural Machine Translation (NMT) automatically where possible. If you prefer PBMT or need to compare the results, you can use the `model:` parameter with either `nmt` or `base` to force the model selection:

```ruby
EasyTranslate.translate("El cuervo americano es un ave con plumas negras iridiscentes sobre todo su cuerpo.", from: "es", to: "en", model: "nmt")
 # => "The American Raven is a bird with iridescent black feathers over its entire body."
 ```

 ```ruby
EasyTranslate.translate("El cuervo americano es un ave con plumas negras iridiscentes sobre todo su cuerpo.", from: "es", to: "en", model: "base")
# => "The American crow is a bird with iridescent black feathers over her body."
```

See https://research.googleblog.com/2016/09/a-neural-network-for-machine.html for more background

## Google Translate supports HTML (default) and plain text formats

```ruby
EasyTranslate.translate "Las doce en punto", format: 'text', to: :en
# => "Twelve o'clock"
EasyTranslate.translate "Las doce <b>en punto</b>", format: 'html', to: :en
# => "Twelve <b>o&#39;clock</b>"
```

---

## A note on concurrency as of v0.4.0

Due to limitations with the Google Translate batch API, above a certain
number of translations - this library will begin making calls concurrently.

The default concurrency is 4, but if you'd prefer to run without threads,
you can set `:concurrency => 1` to run the translation calls serially.

---

## List of languages

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
* [Gleb Mazovetskiy](https://github.com/glebm)

Full contributor data at:
https://github.com/seejohnrun/easy_translate/contributors

---

### License

(The MIT License)

Copyright © 2010-2018 John Crepezzi

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the ‘Software’), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
