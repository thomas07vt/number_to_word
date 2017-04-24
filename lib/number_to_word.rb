require "number_to_word/version"

class NumberToWord
  attr_reader :number
  #UNIT_TABLE = {
    #1000000000 => 'billion',
    #1000000 => 'million',
    #1000 => 'thousand',
    #100 => 'hundred'
  #}

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

    num_to_word(@number)
  end

  private

  def num_to_word(number)
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
          return "#{num_to_word(div)} #{unit_name}#{' ' + num_to_word(mod) unless mod == 0}"
        end
      end
    end
  end
end

