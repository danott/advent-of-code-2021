require "minitest/autorun"

class Day3Test < Minitest::Test
  def example_input
    <<~EXAMPLE_INPUT.lines.map(&:strip)
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    EXAMPLE_INPUT
  end

  def real_input
    File.readlines("./day_03.txt").map(&:strip)
  end

  def test_example_part_one
    assert_equal 22, GammaRate.new(example_input).to_i
    assert_equal 9, EpsilonRate.new(example_input).to_i
    assert_equal 198, PowerConsumption.new(example_input).to_i
  end

  def test_solution_part_one
    assert_equal 2261546, PowerConsumption.new(real_input).to_i
  end

  def test_example_part_two
    assert_equal 23, OxygenGeneratorRating.new(example_input).to_i
    assert_equal 10, CO2ScrubberRating.new(example_input).to_i
    assert_equal 230, LifeSupportRating.new(example_input).to_i
  end
end

PowerConsumption = Struct.new(:measurements) do
  def to_i
    GammaRate.new(measurements).to_i * EpsilonRate.new(measurements).to_i
  end
end

GammaRate = Struct.new(:measurements) do
  def value
    measurements.map(&:chars).transpose.map { |column| most_occurring(column, tie: "0") }.join
  end

  def to_i
    value.to_i(2)
  end
end

EpsilonRate = Struct.new(:measurements) do
  def value
    measurements.map(&:chars).transpose.map { |column| least_occurring(column, tie: "0") }.join
  end

  def to_i
    value.to_i(2)
  end
end

LifeSupportRating = Struct.new(:measurements) do
  def to_i
    OxygenGeneratorRating.new(measurements).to_i * CO2ScrubberRating.new(measurements).to_i
  end
end

OxygenGeneratorRating = Struct.new(:measurements) do
  def value
    filtered_measurements = measurements.map(&:chars)
    filtered_measurements.first.size.times do |index|
      break if filtered_measurements.size == 1
      keep = most_occurring(filtered_measurements.transpose[index], tie: "1")
      filtered_measurements = filtered_measurements.select { |m| m[index] == keep }
    end
    filtered_measurements.first.join
  end

  def to_i
    value.to_i(2)
  end
end

CO2ScrubberRating = Struct.new(:measurements) do
  def value
    filtered_measurements = measurements.map(&:chars)
    filtered_measurements.first.size.times do |index|
      break if filtered_measurements.size == 1
      keep = least_occurring(filtered_measurements.transpose[index], tie: "0")
      filtered_measurements = filtered_measurements.select { |m| m[index] == keep }
    end
    filtered_measurements.first.join
  end

  def to_i
    value.to_i(2)
  end
end

def least_occurring(chars, tie: "0")
  tally = chars.tally.invert
  case tally.keys.size
  when 1
    tie
  else
    tally[tally.keys.min]
  end
end

def most_occurring(chars, tie: "0")
  tally = chars.tally.invert
  case tally.keys.size
  when 1
    tie
  else
    tally[tally.keys.max]
  end
end
