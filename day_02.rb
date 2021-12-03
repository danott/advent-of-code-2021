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
    position = Position.parse(real_input)
    assert_equal 1762050, position.product
  end

  def test_part_two_example
    skip
  end

  def test_part_two_solution
    skip
  end
end

FaultyInterpreter = Struct.new(:instruction, :magnitude) do
  def execute(position)
    case instruction
    when "forward"
      Position.new(position.horizontal + magnitude, position.vertical)
    when "down"
      Position.new(position.horizontal, position.vertical + magnitude)
    when "up"
      Position.new(position.horizontal, position.vertical - magnitude)
    end
  end
end

Position = Struct.new(:horizontal, :vertical) do
  def self.parse(input)
    instructions = input.lines.map do |line|
      instruction, magnitude = line.strip.split(" ")
      FaultyInterpreter.new(instruction, magnitude.to_i)
    end

    instructions.reduce(Position.new(0, 0)) do |position, instruction|
      instruction.execute(position)
    end
  end

  def product
    horizontal * vertical
  end
end
