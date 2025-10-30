# encoding: utf-8

class Zaru
  CHARACTER_FILTER = /[\x00-\x1F\/\\:\*\?\"<>\|]/u
  UNICODE_WHITESPACE = /[[:space:]]+/u
  WINDOWS_RESERVED_NAMES =
    %w{CON PRN AUX NUL COM1 COM2 COM3 COM4 COM5
       COM6 COM7 COM8 COM9 LPT1 LPT2 LPT3 LPT4
       LPT5 LPT6 LPT7 LPT8 LPT9}
  FALLBACK_FILENAME = 'file'

  def initialize(filename, options = {})
    @fallback = options[:fallback] || FALLBACK_FILENAME
    @padding = options[:padding] || 0
    @raw = filename.to_s.freeze
  end

  # strip whitespace on beginning and end
  # collapse intra-string whitespace into single spaces
  def normalize
    @normalized ||= @raw.strip.gsub(UNICODE_WHITESPACE,' ')
  end

  # remove bad things!
  # - remove characters that aren't allowed cross-OS
  # - don't allow certain special filenames (issue on Windows)
  # - don't allow filenames to start with a dot
  # - don't allow empty filenames
  #
  # this renormalizes after filtering in order to collapse whitespace
  def sanitize
    @sanitized ||=
      filter(normalize.gsub(CHARACTER_FILTER,'')).gsub(UNICODE_WHITESPACE,' ')
  end

  # cut off at 255 bytes
  # optionally provide a padding, which is useful to
  # make sure there is room to add a file extension later
  def truncate
    max_size = 255 - @padding
    @truncated ||= begin
      return sanitize if sanitize.bytesize < max_size

      result = ''
      sanitize.each_char do |ch|
        return result if result.bytesize + ch.bytesize > max_size

        result << ch
      end
    end
  end

  def to_s
    truncate
  end

  # convenience method
  def self.sanitize!(filename, options = {})
    new(filename, options).to_s
  end

  private

    attr_reader :fallback

    def filter(filename)
      filename = filter_windows_reserved_names(filename)
      filename = filter_blank(filename)
      filename = filter_dot(filename)
    end

    def filter_windows_reserved_names(filename)
      WINDOWS_RESERVED_NAMES.include?(filename.upcase) ? fallback : filename
    end

    def filter_blank(filename)
      filename.empty?? fallback : filename
    end

    def filter_dot(filename)
      filename.start_with?('.')? "#{fallback}#{filename}" : filename
    end

end
