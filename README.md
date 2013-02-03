zaru
====

[![Build Status](https://travis-ci.org/madrobby/zaru.png)](https://travis-ci.org/madrobby/zaru)

Filename sanitization for Ruby.

```ruby
Zaru.sanitize! "  what\ēver//wëird:user:înput:"
# => "whatēverwëirduserînput"
```

Zaru takes a given filename (a string) and normalizes, filters and truncates it.

It removes the bad stuff but leaves unicode characters in place, so users can use whatever alphabets they want to. Zaru also doesn't remove whitespace—instead, any sequence of whitespace that is 1 or more characters in length is collapsed to a single space. Filenames are truncated so that they are at maximum 255 characters long.

Zaru works with Ruby 1.8.7 or later. It's experimental and may eat your cat. Don't trust it in production systems.

TODO
----

* Make sure truncation is correct on Ruby 1.8
* Fix failing test suite (it does work locally with 1.9.3)
* Extend test suite

[Wait, what, Zaru?](http://en.wikipedia.org/wiki/Zaru)

Zaru is licensed under the terms of the MIT license. (c) 2013 Thomas Fuchs.