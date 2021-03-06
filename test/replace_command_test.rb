require 'test_helper'
require 'tempfile'

module Pups
  class ReplaceCommandTest < MiniTest::Test

    def test_simple
      command = ReplaceCommand.new({})
      command.text = "hello world"
      command.from = /he[^o]+o/
      command.to = "world"

      assert_equal("world world", command.replaced_text)
    end

    def test_reverse

      source = <<SCR
1 one thousand 1
1 one thousand 1
1 one thousand 1
SCR

      f = Tempfile.new("test")
      f.write source
      f.close

      hash = {
        "filename" => f.path,
        "from" => "/one t.*d/",
        "to" => "hello world",
        "direction" => "reverse"
      }

      command = ReplaceCommand.from_hash(hash, {})

      assert_equal("1 one thousand 1\n1 one thousand 1\n1 hello world 1\n", command.replaced_text)
    ensure
      f.unlink
    end
  end

  def test_parse

    source = <<SCR
this {
is a test
}
SCR

    f = Tempfile.new("test")
    f.write source
    f.close

    hash = {
      "filename" => f.path,
      "from" => "/this[^\}]+\}/m",
      "to" => "hello world"
    }

    command = ReplaceCommand.from_hash(hash, {})

    assert_equal("hello world", command.replaced_text.strip)
  ensure
    f.unlink
  end
end
