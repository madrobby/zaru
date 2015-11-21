zaru
====

[![Build Status](https://travis-ci.org/madrobby/zaru.png)](https://travis-ci.org/madrobby/zaru)

Filename sanitization for Ruby. This is useful when you generate filenames for downloads from user input (we're using it for PDF invoice downloads in [Freckle](http://letsfreckle.com)).

```ruby
Zaru.sanitize! "  what\ēver//wëird:user:înput:"
# => "whatēverwëirduserînput"
```

Zaru takes a given filename (a string) and normalizes, filters and truncates it.

It removes the bad stuff but leaves unicode characters in place, so users can use whatever alphabets they want to. Zaru also doesn't remove whitespace—instead, any sequence of whitespace that is 1 or more characters in length is collapsed to a single space. Filenames are truncated so that they are at maximum 255 characters long.

If extra breathing room is required (for example to add your own filename extension later),
you can leave extra room with the `:padding` option:

```ruby
Zaru.sanitize! "A"*400, :padding => 100
# resulting filename is 145 characters long
```

Zaru works with Ruby 1.9.2 or later. It's experimental and may eat your cat. Don't trust it in production systems.

Bad things in filenames
-----------------------

Wikipedia has a [good overview on filenames](http://en.wikipedia.org/wiki/Filename). Basically, on modern-ish operating systems, the following characters  are considered no-no (Zaru filters these):

```
/ \ ? * : | " < >
```

Additionally the [ASCII control characters](http://en.wikipedia.org/wiki/ASCII#ASCII_control_characters) (hexadecimal `00` to `1f`) are filtered.

All [Unicode whitespace](http://en.wikipedia.org/wiki/Whitespace_character#Unicode) at the beginning and end of the potential filename is removed, and any Unicode whitespace within the filename is collapse to a single space character.

[Certain filenames are reserved in Windows](http://msdn.microsoft.com/en-us/library/windows/desktop/aa365247%28v=vs.85%29.aspx) and are filtered.

[Wait, what, Zaru?](http://en.wikipedia.org/wiki/Zaru)

Zaru is licensed under the terms of the MIT license. (c) 2013 Thomas Fuchs.
