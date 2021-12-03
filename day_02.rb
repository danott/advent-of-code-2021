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


Position = Struct.new(:horizontal, :vertical) do
  def self.parse(input)
    horizontal = vertical = 0

    input.lines.map(&:strip).each do |line|
      direction, magnitude = line.split(" ")
      magnitude = magnitude.to_i

      case direction
      when "forward"
        horizontal += magnitude
      when "down"
        vertical += magnitude
      when "up"
        vertical -= magnitude
      end
    end

    new(horizontal, vertical)
  end

  def product
    horizontal * vertical
  end
end
