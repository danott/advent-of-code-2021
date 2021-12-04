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
    report = Report.parse(example_input)
    assert_equal 22, report.gamma_rate
    assert_equal 9, report.epsilon_rate
    assert_equal 198, report.power_consumption
  end

  def test_solution_part_one
    report = Report.parse(real_input)
    assert_equal 2261546, report.power_consumption
  end
end

Report = Struct.new(:gamma_rate, :epsilon_rate) do
  def self.parse(measurements)
    gamma_rate = most_common_digit(measurements).to_i(2)
    epsilon_rate = least_common_digit(measurements).to_i(2)
    new(gamma_rate, epsilon_rate)
  end

  def power_consumption
    gamma_rate * epsilon_rate
  end
end

def most_common_digit(measurements)
  counts = measurements.reduce([0] * measurements.first.size) do |memo, measurement|
    memo.zip(measurement.chars.map(&:to_i)).map(&:sum)
  end.map do |digit|
    digit > measurements.size / 2 ? "1" : "0"
  end.join
end

def least_common_digit(measurements)
  invert(most_common_digit(measurements))
end

def invert(measurement)
  measurement.chars.map { |c| c == "0" ? "1" : "0" }.join
end
