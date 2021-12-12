require "minitest/autorun"

EXAMPLE_INPUT = <<~VENTS
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
VENTS

REAL_INPUT = File.read("day_05.txt")

class VentTest < Minitest::Test
  def test_example_part_one
    vent = Vent.parse(EXAMPLE_INPUT)
    assert_equal 5, vent.without_diagonals.overlap
  end

  def test_solution_part_one
    vent = Vent.parse(REAL_INPUT)
    assert_equal 6687, vent.without_diagonals.overlap
  end

  def test_example_part_two
    vent = Vent.parse(EXAMPLE_INPUT)
    assert_equal 12, vent.overlap
  end

  def test_solution_part_two
    vent = Vent.parse(REAL_INPUT)
    assert_equal 19851, vent.overlap
  end
end

Point = Struct.new(:x, :y)

Vent = Struct.new(:lines) do
  def self.parse(input)
    lines = input.lines.map { |l| Line.parse(l) }
    new(lines)
  end

  def without_diagonals
    self.class.new(lines.reject(&:diagonal?))
  end

  def overlap
    lines.flat_map(&:points).tally.select { |k, v| v >= 2 }.size
  end
end

Line = Struct.new(:endpoints) do
  def self.parse(line)
    left, _, right = line.split(" ")
    endpoints = [left, right].map do |point|
      x, y = point.split(",").map(&:to_i)
      Point.new(x, y)
    end
    new(endpoints)
  end

  def vertical?
    endpoints.map(&:x).uniq.size == 1
  end

  def horizontal?
    endpoints.map(&:y).uniq.size == 1
  end

  def diagonal?
    !vertical? && !horizontal?
  end

  def points
    case
    when min_x == max_x
      min_y.upto(max_y).map { |y| Point.new(min_x, y) }
    when min_y == max_y
      min_x.upto(max_x).map { |x| Point.new(x, min_y) }
    else
      horizontal = []
      vertical = []

      left, right = endpoints.sort_by(&:x)
      horizontal = left.x.upto(right.x).to_a

      if left.y < right.y
        vertical = left.y.upto(right.y).to_a
      else
        vertical = left.y.downto(right.y).to_a
      end
      
      horizontal.zip(vertical).map { |x, y| Point.new(x, y) }
    end
  end

  private

  def min_x
    endpoints.map(&:x).min
  end

  def max_x
    endpoints.map(&:x).max
  end

  def min_y
    endpoints.map(&:y).min
  end

  def max_y
    endpoints.map(&:y).max
  end
end
