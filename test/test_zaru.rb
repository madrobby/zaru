# encoding: utf-8

require 'test/unit'
require 'zaru'

class ZaruTest < Test::Unit::TestCase

  def test_normalization
    ['a', ' a', 'a ', ' a ', "a    \n"].each do |name| 
      assert_equal 'a', Zaru.sanitize!(name)
    end
    
    ['x x', 'x  x', 'x   x', "x\tx", "x\r\nx"].each do |name|
      assert_equal 'x x', Zaru.sanitize!(name)
    end
  end
  
  def test_truncation
    name = "A"*400
    assert_equal 255, Zaru.sanitize!(name).length
  end
  
  def test_sanitization
    assert_equal "abcdef", Zaru.sanitize!('abcdef')
    
    %w(< > | / \\ * ? :).each do |char|
      assert_equal '', Zaru.sanitize!(char)
      assert_equal 'a', Zaru.sanitize!("a#{char}")
      assert_equal 'a', Zaru.sanitize!("#{char}a")
      assert_equal 'aa', Zaru.sanitize!("a#{char}a")
    end
    
    assert_equal "笊, ざる.pdf", Zaru.sanitize!("笊, ざる.pdf")
    
    assert_equal "whatēverwëirduserînput", 
      Zaru.sanitize!("  what\ēver//wëird:user:înput:")
  end
  
end