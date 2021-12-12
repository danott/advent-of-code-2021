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

REAL_INPUT = File.read("day_04.txt")

class BingoTest < Minitest::Test
  def test_example_part_one
    scorer = Scorer.parse(EXAMPLE_INPUT, criteria: PartOneCriteria).run
    assert_equal 4512, scorer.score
  end

  def test_solution_part_one
    scorer = Scorer.parse(REAL_INPUT, criteria: PartOneCriteria).run
    assert_equal 33462, scorer.score
  end

  def test_example_part_two
    scorer = Scorer.parse(EXAMPLE_INPUT, criteria: PartTwoCriteria).run
    assert_equal 1924, scorer.score
  end

  def test_solution_part_two
    scorer = Scorer.parse(REAL_INPUT, criteria: PartTwoCriteria).run
    assert_equal 30070, scorer.score
  end
end

PartOneCriteria = Struct.new(:scorer) do
  def run
    scorer.next until scorer.boards.any?(&:win?)
  end

  def score
    scorer.boards.find(&:win?).score * scorer.called_numbers.last
  end
end

PartTwoCriteria = Struct.new(:scorer) do
  def run
    scorer.next until scorer.boards.all?(&:win?)
  end

  def score
    last_number = scorer.called_numbers.last
    board = scorer.boards.find do |b| 
      b.rows.flat_map(&:cells).select(&:marked?).map(&:value).include? last_number
    end
    board.score * last_number
  end
end

class Scorer
  attr_reader :boards
  attr_reader :criteria
  attr_reader :called_numbers
  attr_reader :remaining_numbers
  
  def initialize(boards:, remaining_numbers:, criteria: PartOneCriteria)
    @boards = boards
    @remaining_numbers = remaining_numbers
    @called_numbers = []
    @criteria = criteria.new(self)
  end

  def self.parse(input, criteria:)
    paragraphs = input.split("\n\n")
    remaining_numbers = paragraphs.shift.split(",").map(&:to_i)
    boards = paragraphs.map { |p| Board.parse(p) }
    
    new(boards: boards, remaining_numbers: remaining_numbers, criteria: criteria)
  end

  def next
    next_number = remaining_numbers.shift
    boards.each { |b| b.mark(next_number) }
    called_numbers.push next_number
    self
  end

  def run
    criteria.run
    self
  end

  def score
    criteria.score
  end
end

Board = Struct.new(:rows) do
  def self.parse(input)
    new input.lines.map { |l| Row.parse(l) }
  end

  def columns
    rows.map(&:cells).transpose.map { |cells| Row.new(cells) }
  end

  def mark(number)
    return self if win?
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

Row = Struct.new(:cells) do
  def self.parse(line)
    new line.gsub(/\s+/, " ").split(" ").map { |s| Cell.new(s.to_i) }
  end

  def win?
    cells.all?(&:marked?)
  end

  def mark(number)
    cells.each { |c| c.mark(number) }
    self
  end
end

Cell = Struct.new(:value, :marked) do
  def mark(number)
    self.marked = true if value == number
  end

  def marked?
    marked
  end
end
