require "minitest/autorun"

EXAMPLE_INPUT = <<~BINGO
7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

22 13 17 11  0
 8  2 23  4 24
21  9 14 16  7
 6 10  3 18  5
 1 12 20 15 19

 3 15  0  2 22
 9 18 13 17  5
19  8  7 25 23
20 11 10 24  4
14 21 16 12  6

14 21 17 24  4
10 16 15  9 19
18  8 23 26 20
22 11 13  6  5
 2  0 12  3  7
BINGO

class BingoTest < Minitest::Test
  def test_example_part_one
    scorer = Scorer.parse(EXAMPLE_INPUT)
    scorer.next until scorer.win?
    assert_equal 4512, scorer.score
  end

  def test_solution_part_one
    scorer = Scorer.parse(File.read("day_04.txt"))
    scorer.next until scorer.win?
    assert_equal 33462, scorer.score
  end
end

class Scorer
  attr_reader :boards
  attr_reader :called_numbers
  attr_reader :remaining_numbers
  
  def initialize(boards:, remaining_numbers:)
    @boards = boards
    @remaining_numbers = remaining_numbers
    @called_numbers = []
  end

  def self.parse(input)
    paragraphs = input.split("\n\n")
    remaining_numbers = paragraphs.shift.split(",").map(&:to_i)
    boards = paragraphs.map { |p| Board.parse(p) }
    
    new(boards: boards, remaining_numbers: remaining_numbers)
  end

  def win?
    boards.any?(&:win?)
  end

  def next
    next_number = remaining_numbers.shift
    boards.each { |b| b.mark(next_number) }
    called_numbers.push next_number
    self
  end

  def score
    boards.find(&:win?).score * called_numbers.last
  end
end

class Board
  attr_reader :rows

  def initialize(rows)
    @rows = rows
  end

  def self.parse(input)
    new input.lines.map { |l| Row.parse(l) }
  end

  def columns
    rows.map(&:cells).transpose.map { |cells| Row.new(cells) }
  end

  def mark(number)
    rows.each { |r| r.mark(number) }
    self
  end

  def win?
    (rows + columns).flatten.any?(&:win?)
  end

  def score
    rows.flat_map(&:cells).reject(&:marked?).sum(&:value)
  end
end

class Row
  attr_reader :cells
  
  def initialize(cells)
    @cells = cells
  end

  def mark(number)
    cells.each { |c| c.mark(number) }
    self
  end

  def self.parse(line)
    new line.gsub(/\s+/, " ").split(" ").map { |s| Cell.new(s.to_i) }
  end

  def win?
    cells.all?(&:marked?)
  end
end

class Cell
  attr_reader :value

  def initialize(value)
    @value = value
    @marked = false
  end

  def mark(number)
    @marked = true if value == number
  end

  def marked?
    @marked
  end
end
