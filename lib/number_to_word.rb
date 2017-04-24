require "number_to_word/version"

class NumberToWord
  attr_reader :number
  UNIT_TABLE = [
    [1000000000, 'billion'],
    [1000000, 'million'],
    [1000, 'thousand'],
    [100, 'hundred']
  ]

  TENS_TABLE = {
    9 => 'ninety',
    8 => 'eighty',
    7 => 'seventy',
    6 => 'sixty',
    5 => 'fifty',
    4 => 'fourty',
    3 => 'thirty',
    2 => 'twenty',
  }

  NUMBER_TABLE = {
    19 => 'nineteen',
    18 => 'eighteen',
    17 => 'seventeen',
    16 => 'sixteen',
    15 => 'fifteen',
    14 => 'fourteen',
    13 => 'thirteen',
    12 => 'twelve',
    11 => 'eleven',
    10 => 'ten',
    9 => 'nine',
    8 => 'eight',
    7 => 'seven',
    6 => 'six',
    5 => 'five',
    4 => 'four',
    3 => 'three',
    2 => 'two',
    1 => 'one',
  }

  # This will memoize all the solutions so that the actual lookup should be
  # very fast, at the cost of the first accessor
  #
  # @private
  #
  # @return [Hash] All the solutions
  def self.solutions
    @solutions ||= solve_for_most
  end

  # I initially tried this up to 1 million, but it hosed my computer.
  # So I am backing off to just solve for 100,000
  # @private
  def self.solve_for_most
    solutions = {}
    (0..100_000).each do |number|
      solutions[number] = solve_any_number(number)
    end
    solutions
  end

  # Taking the same logic to solve the number that was used on the instance
  #
  # @private
  def self.solve_any_number(number)
    case number
    when 0..19
      NUMBER_TABLE[number]
    when 20..99
      tens, mod = number.divmod(10)
      "#{TENS_TABLE[number / 10]}#{'-' + NUMBER_TABLE[mod] unless mod == 0}"
    else
      UNIT_TABLE.each do |unit_num, unit_name|
        div, mod = number.divmod(unit_num)
        if div > 0
          return "#{solve_any_number(div)} #{unit_name}#{' ' + solve_any_number(mod) unless mod == 0}"
        end
      end
    end
  end

  # We can use this to lookup pre-solved solutions first, before doing the 
  # solve_large_number call again
  #
  # @private
  def self.solve(number)
    solutions[number] || solve_large_number(number)
  end

  # We can remove the case statement if we know we are only dealing with large
  # numbers
  def self.solve_large_number(number)
    UNIT_TABLE.each do |unit_num, unit_name|
      div, mod = number.divmod(unit_num)
      if div > 0
        return "#{solve(div)} #{unit_name}#{' ' + solve(mod) unless mod == 0}"
      end
    end
  end

  # Creates a NumberToWord instance
  #
  # @param [Integer] (Required) The integer that will be used to generate the word. Must be positive
  #
  # @raise ArgumentError If supplied param is not a positive Integer
  #
  # @return [NumberToWord]
  def initialize(number)
    unless number.is_a?(Integer) && number >= 0
      raise ArgumentError.new("Only positive Integers allowed")
    end

    @number = number
  end

  # Returns the word associated with the base number
  #
  # @return [String] The resulting word
  def word
    return 'zero' if @number == 0

    NumberToWord.solutions[@number] || NumberToWord.solve_large_number(@number)
  end
end

