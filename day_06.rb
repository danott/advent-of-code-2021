require "minitest/autorun"

EXAMPLE_INPUT = "3,4,3,1,2"
REAL_INPUT = "1,1,1,3,3,2,1,1,1,1,1,4,4,1,4,1,4,1,1,4,1,1,1,3,3,2,3,1,2,1,1,1,1,1,1,1,3,4,1,1,4,3,1,2,3,1,1,1,5,2,1,1,1,1,2,1,2,5,2,2,1,1,1,3,1,1,1,4,1,1,1,1,1,3,3,2,1,1,3,1,4,1,2,1,5,1,4,2,1,1,5,1,1,1,1,4,3,1,3,2,1,4,1,1,2,1,4,4,5,1,3,1,1,1,1,2,1,4,4,1,1,1,3,1,5,1,1,1,1,1,3,2,5,1,5,4,1,4,1,3,5,1,2,5,4,3,3,2,4,1,5,1,1,2,4,1,1,1,1,2,4,1,2,5,1,4,1,4,2,5,4,1,1,2,2,4,1,5,1,4,3,3,2,3,1,2,3,1,4,1,1,1,3,5,1,1,1,3,5,1,1,4,1,4,4,1,3,1,1,1,2,3,3,2,5,1,2,1,1,2,2,1,3,4,1,3,5,1,3,4,3,5,1,1,5,1,3,3,2,1,5,1,1,3,1,1,3,1,2,1,3,2,5,1,3,1,1,3,5,1,1,1,1,2,1,2,4,4,4,2,2,3,1,5,1,2,1,3,3,3,4,1,1,5,1,3,2,4,1,5,5,1,4,4,1,4,4,1,1,2"

class FishTest < Minitest::Test
  def test_example_part_one
    school = School.parse(EXAMPLE_INPUT)
    assert_equal 5, school.count
    assert_equal 5, school.day(1).count
    assert_equal 6, school.day(2).count
    assert_equal 26, school.day(18).count 
    assert_equal 5934, school.day(80).count 
  end

  def test_solution_part_one
    school = School.parse(REAL_INPUT)
    assert_equal 372984, school.day(80).count 
  end

  def test_example_part_two
    school = School.parse(EXAMPLE_INPUT)
    assert_equal 26984457539, school.day(256).count 
  end

  def test_solution_part_two
    school = School.parse(REAL_INPUT)
    assert_equal 1681503251694, school.day(256).count 
  end
end

School = Struct.new(:tally) do
  def self.parse(digits)
    digits = digits.split(",").map(&:to_i)
    new(digits.tally)
  end

  def count
    tally.values.sum
  end

  def day(this_many)
    this_many.times.reduce(self) { |g| g.next }
  end

  def next
    next_tally = {
      0 => tally.fetch(1, 0),
      1 => tally.fetch(2, 0),
      2 => tally.fetch(3, 0),
      3 => tally.fetch(4, 0),
      4 => tally.fetch(5, 0),
      5 => tally.fetch(6, 0),
      6 => tally.fetch(0, 0) + tally.fetch(7, 0),
      7 => tally.fetch(8, 0),
      8 => tally.fetch(0, 0),
    }
    self.class.new(next_tally)
  end
end