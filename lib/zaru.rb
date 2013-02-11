# encoding: utf-8

class Zaru
  CHARACTER_FILTER = /[\x00-\x1F\/\\:\*\?\"<>\|]/u
  UNICODE_WHITESPACE = /[[:space:]]+/u
  WINDOWS_RESERVED_NAMES =
    %w{CON PRN AUX NUL COM1 COM2 COM3 COM4 COM5
       COM6 COM7 COM8 COM9 LPT1 LPT2 LPT3 LPT4
       LPT5 LPT6 LPT7 LPT8 LPT9}
  FALLBACK_FILENAME = 'file'

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
    @sanitized ||=
      filter(normalize.gsub(CHARACTER_FILTER,''))
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
    new(filename).to_s
  end

  private

    def filter(filename)
      filename = filter_windows_reserved_names(filename)
      filename = filter_blank(filename)
      filename = filter_dot(filename)
    end

    def filter_windows_reserved_names(filename)
      WINDOWS_RESERVED_NAMES.include?(filename.upcase) ? 'file' : filename
    end

    def filter_blank(filename)
      filename == '' ? FALLBACK_FILENAME : filename
    end

    def filter_dot(filename)
      filename.start_with?('.') ? "#{FALLBACK_FILENAME}#{filename}" : filename
    end

end