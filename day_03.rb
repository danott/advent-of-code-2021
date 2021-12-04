require "minitest/autorun"

class Day3Test < Minitest::Test
  def example_input
    <<~EXAMPLE_INPUT
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
    File.read("./day_03.txt")
  end

  def test_example_part_one
    report = Report.parse(example_input)
    assert_equal 22, report.gamma_rate
    assert_equal 9, report.epsilon_rate
    assert_equal 198, report.power_consumption
  end

  def test_solution_part_one
    report = Report.parse(real_input)
    assert_equal 198, report.power_consumption
  end
end

Report = Struct.new(:gamma_rate, :epsilon_rate) do
  def self.parse(input)
    measurements = input.lines.map(&:strip)

    counts = measurements.reduce([0] * measurements.first.size) do |memo, measurement|
      memo.zip(measurement.chars.map(&:to_i)).map(&:sum)
    end

    gamma_rate = counts.map do |digit|
      digit > measurements.size / 2 ? "1" : "0"
    end.join.to_i(2)

    epsilon_rate = counts.map do |digit|
      digit > measurements.size / 2 ? "0" : "1"
    end.join.to_i(2)

    new(gamma_rate, epsilon_rate)
  end

  def power_consumption
    gamma_rate * epsilon_rate
  end
end
