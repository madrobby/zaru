# encoding: utf-8

class Zaru
  CHARACTER_FILTER = /[\x00-\x1F\/\\:\*\?\"<>\|]/u
  UNICODE_WHITESPACE = /[[:space:]]+/u

  def initialize(filename)
    @raw = filename.to_s.freeze
  end

  # strip whitespace on beginning and end
  # collapse intra-string whitespace into single spaces
  def normalize
    @normalized ||= @raw.strip.gsub(UNICODE_WHITESPACE,' ')
  end

  # remove characters that aren't allowed cross-OS
  def sanitize
    @sanitized ||= normalize.gsub(CHARACTER_FILTER,'')
  end

  # normalize unicode string and cut off at 255 characters
  # TODO
  def truncate
    @truncated ||= sanitize.chars.to_a.slice(0..254).join
  end

  # convert back from multibyte string
  def to_s
    truncate
  end
  
  # convenience method
  def self.sanitize!(filename)
    Zaru.new(filename).to_s
  end
end