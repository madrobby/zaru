zaru
====

[![CI tests](https://github.com/madrobby/zaru/actions/workflows/main.yml/badge.svg)](https://github.com/madrobby/zaru/actions/workflows/main.yml)

Filename sanitization for Ruby. This is useful when you generate filenames
for downloads from user input (we're using it for PDF invoice
downloads in [Noko](https://nokotime.com)).

```ruby
Zaru.sanitize! "  what\ēver//wëird:user:înput:"
# => "whatēverwëirduserînput"
```

Zaru takes a given filename (a string) and normalizes, filters and
truncates it.

It removes the bad stuff but leaves unicode characters in place, so users
can use whatever alphabets they want to. Zaru also doesn't remove
whitespace — instead, any sequence of whitespace that is 1 or more
characters in length is collapsed to a single space. Filenames are
truncated so that they are at maximum 255 characters long.

If extra breathing room is required (for example to add your own filename
extension later), you can leave extra room with the `:padding` option
(up to a maximum of 254):

```ruby
Zaru.sanitize! "A"*400, :padding => 100
# resulting filename is 145 characters long
```

If you need to customize the fallback filename you can add your own
fallback with the `:fallback` option:

```
Zaru.sanitize! "<<<", :fallback => 'no_file'
# resulting filename is 'no_file'
```

Zaru works with Ruby 2.0 or later, including Ruby 4 (the unit tests
target 2.4 and higher).

It may eat your cat.

Bad things in filenames
-----------------------

Wikipedia has a [good overview on filenames]\
(https://en.wikipedia.org/wiki/Filename). Basically, on modern-ish operating
systems, the following characters are considered no-no (Zaru filters
these):

```
/ \ ? * : | " < >
```

Additionally, the [ASCII control characters]\
(https://en.wikipedia.org/wiki/ASCII#ASCII_control_characters) (hexadecimal
`00` to `1f`) are filtered.

All [Unicode whitespace]\
(https://en.wikipedia.org/wiki/Whitespace_character#Unicode) at the beginning
and end of the potential filename is removed, and any Unicode whitespace
within the filename is collapsed to a single space character.

[Certain filenames are reserved in Windows]\
(https://learn.microsoft.com/en-us/windows/win32/fileio/naming-a-file)
and are filtered.

[Wait, what, Zaru?](https://en.wikipedia.org/wiki/Zaru)

Zaru is licensed under the terms of the MIT license.
(c) 2013-2026 Thomas Fuchs
