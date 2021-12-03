require "minitest/autorun"

class TheTest < Minitest::Test
  def test_input
    <<~TEST_INPUT
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
  end

  def real_input
    File.read("./day_01.txt")
  end

  def test_part_one_example
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
    assert_equal 7, count_increases(test_input)
  end

  def test_part_one_solution
    assert_equal 1390, count_increases(real_input)
  end

  def test_part_two_example
    assert_equal 5, count_window_increases(test_input)
  end

  def test_part_two_solution
    assert_equal 1457, count_window_increases(real_input)
  end
end

IncreasesAccumulator = Struct.new(:prev_depth, :increases) do
  def self.compute(depths)
    depths.reduce(new(depths.first, 0)) { |memo, depth| memo.next(depth) }.increases
  end

  def next(depth)
    next_increases = depth > prev_depth ? increases + 1 : increases
    self.class.new(depth, next_increases)
  end
end

def count_increases(input)
  depths = input.lines.map(&:strip).map(&:to_i)
  IncreasesAccumulator.compute(depths)
end

def count_window_increases(input)
  depths = input.lines.map(&:strip).map(&:to_i)
  IncreasesAccumulator.compute(windowize_depths(depths))
end

def windowize_depths(depths)
  remaining_depths = depths.dup
  next_depths = []
  while remaining_depths.size > 2
    next_depths.push(remaining_depths.first(3).sum)
    remaining_depths = remaining_depths.drop(1)
  end
  next_depths
end
