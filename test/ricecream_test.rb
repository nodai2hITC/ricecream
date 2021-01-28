# frozen_string_literal: true

require "test_helper"

class RicecreamTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Ricecream::VERSION
  end

  def test_analyzer
    path = File.absolute_path("test/testscript.rb")
    ic_methods = Ricecream::Analyzer.new(path).ic_methods

    assert_equal :ic, ic_methods[0].name
    assert_equal path, ic_methods[0].script
    assert_equal 2, ic_methods[0].lineno
    assert_equal 0, ic_methods[0].column
    assert_equal 1, ic_methods[0].arity
    assert_equal ['1'], ic_methods[0].args

    assert_equal :ic_format, ic_methods[1].name

    assert_equal ['1'], ic_methods[2].args

    assert_equal 5, ic_methods[3].column

    assert_equal 2, ic_methods[4].arity
    assert_equal ['1', '2'], ic_methods[4].args

    assert_equal 3, ic_methods[5].arity
    assert_equal ['3', '4', '5'], ic_methods[5].args
  end

  def test_ic_format
    assert_equal 'ic| 123', ic_format(123)
    assert_equal 'ic| "abc"', ic_format("abc")
    a = 123
    b = "abc"
    assert_equal 'ic| a: 123', ic_format(a)
    assert_equal 'ic| a: 123, b: "abc"', ic_format(a, b)
    assert ic_format.start_with?("ic| #{__FILE__}:#{__LINE__}")
    assert ic_format.match?(/ at \d{2}:\d{2}:\d{2}\.\d{3}\z/)
  end
end
