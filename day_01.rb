require "minitest/autorun"

class TheTest < Minitest::Test
  def test_example_input
    input = <<~TEST_INPUT
      199
      200
      208
      210
      200
      207
      240
      269
      260
      263
    TEST_INPUT
    assert_equal 7, count_increases(input)
  end

  def test_my_input
    input = File.read("./day_01.txt")
    assert_equal 1390, count_increases(input)
  end
end

IncreasesAccumulator = Struct.new(:prev_depth, :increases) do
  def next(depth)
    next_increases = depth > prev_depth ? increases + 1 : increases
    self.class.new(depth, next_increases)
  end
end

def count_increases(input)
  depths = input.lines.map(&:strip).map(&:to_i)
  depths.reduce(IncreasesAccumulator.new(depths.first, 0)) do |counter, depth|
    counter.next(depth)
  end.increases
end
