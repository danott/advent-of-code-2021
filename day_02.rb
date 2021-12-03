require "minitest/autorun"

class TheTest < Minitest::Test
  def example_input
    <<~EXAMPLE_INPUT
      forward 5
      down 5
      forward 8
      up 3
      down 8
      forward 2
    EXAMPLE_INPUT
  end

  def real_input
    File.read("./day_02.txt")
  end

  def test_part_one_example
    position = Position.parse(example_input)
    assert_equal 150, position.product
  end

  def test_part_one_solution
    skip
  end

  def test_part_two_example
    skip
  end

  def test_part_two_solution
    skip
  end
end

class Position
  def self.parse(input)
    new
  end

  def product
    150
  end
end
