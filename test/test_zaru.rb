require 'test/unit'
require 'zaru'

class ZaruTest < Test::Unit::TestCase
  def test_normalization
    ['a', ' a', 'a ', ' a ', "a    \n"].each do |name|
      assert_equal 'a', Zaru.sanitize!(name)
    end

    ['x x', 'x  x', 'x   x', ' x  |  x ', "x\tx", "x\r\nx"].each do |name|
      assert_equal 'x x', Zaru.sanitize!(name)
    end
  end

  def test_truncation
    name = 'A' * 400
    assert_equal 255, Zaru.sanitize!(name).length

    assert_equal 245, Zaru.sanitize!(name, padding: 10).length
  end

  def test_truncation_with_large_padding
    # padding >= 255 should not break — result should still be truncated to a reasonable length
    assert_equal 1, Zaru.sanitize!('A' * 400, padding: 255).length
    assert_equal 1, Zaru.sanitize!('A' * 400, padding: 300).length
    assert_equal 1, Zaru.sanitize!('A' * 400, padding: 999).length
  end

  def test_truncation_does_not_overflow
    # With large padding, we should never get more than 255 characters
    result = Zaru.sanitize!('A' * 400, padding: 255)
    assert_operator result.length, :<=, 255
  end

  def test_sanitization
    assert_equal 'abcdef', Zaru.sanitize!('abcdef')

    %w[< > | / \\ * ? :].each do |char|
      assert_equal 'file', Zaru.sanitize!(char)
      assert_equal 'a', Zaru.sanitize!("a#{char}")
      assert_equal 'a', Zaru.sanitize!("#{char}a")
      assert_equal 'aa', Zaru.sanitize!("a#{char}a")
    end

    assert_equal '笊, ざる.pdf', Zaru.sanitize!('笊, ざる.pdf')

    assert_equal 'whatēverwëirduserînput',
                 Zaru.sanitize!('  what\\ēver//wëird:user:înput:')
  end

  def test_windows_reserved_names
    assert_equal 'file', Zaru.sanitize!('CON')
    assert_equal 'file', Zaru.sanitize!('lpt1 ')
    assert_equal 'file', Zaru.sanitize!('com4')
    assert_equal 'file', Zaru.sanitize!(' aux')
    assert_equal 'file', Zaru.sanitize!(" LpT\x122")

    # Windows is... weird
    assert_equal 'file', Zaru.sanitize!('COM³')
    # special casing for LPT/COM only go up to "9"
    assert_equal 'COM10', Zaru.sanitize!('COM10')
  end

  def test_windows_reserved_names_with_extensions
    # Microsoft's documentation states that "avoid these names followed
    # immediately by an extension; for example, NUL.txt and NUL.tar.gz
    # are both equivalent to NUL
    assert_equal 'file.txt', Zaru.sanitize!('nul.txt')
    assert_equal 'file.txt', Zaru.sanitize!('.nul.txt')
    assert_equal 'file.tar.gz', Zaru.sanitize!('nul.tar.gz')
    assert_equal 'file.tar.gz', Zaru.sanitize!(' COM³.tar.gz ')

    # it's fine if reserved names are used as extensions
    # or as part of filenames
    assert_equal 'file.con', Zaru.sanitize!('file.con')
    assert_equal 'Acon.ext', Zaru.sanitize!('Acon.ext')
    assert_equal 'Afile.con', Zaru.sanitize!('Afile.con')
  end

  def test_blanks
    assert_equal 'file', Zaru.sanitize!('')
    assert_equal 'file', Zaru.sanitize!('<')
  end

  def test_dots
    assert_equal 'file.pdf', Zaru.sanitize!('.pdf')
    assert_equal 'file.pdf', Zaru.sanitize!('<.pdf')
    assert_equal 'file..pdf', Zaru.sanitize!('..pdf')
  end

  def test_fallback_filename
    assert_equal 'file', Zaru.sanitize!('<')
    assert_equal 'file', Zaru.sanitize!('lpt1')
    assert_equal 'file.pdf', Zaru.sanitize!('<.pdf')

    assert_equal 'blub', Zaru.sanitize!('<', fallback: 'blub')
    assert_equal 'blub', Zaru.sanitize!('lpt1', fallback: 'blub')
    assert_equal 'blub.pdf', Zaru.sanitize!('<.pdf', fallback: 'blub')
  end
end
