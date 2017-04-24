require "number_to_word/version"

class NumberToWord
  attr_reader :number
  UNIT_TABLE = {
    1000000000 => 'billion',
    1000000 => 'million',
    1000 => 'thousand',
    100 => 'hundred',
    10 => 'tens',
    1 => 'ones',
  }

  TENS_TABLE = {
    90 => 'ninety',
    80 => 'eighty',
    70 => 'seventy',
    60 => 'sixty',
    50 => 'fifty',
    40 => 'fourty',
    30 => 'thirty',
    20 => 'twenty',
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

  def num_to_word(number, parts=[])
    UNIT_TABLE.each do |unit_num, unit_name|
      div, mod = number.divmod(unit_num)

      if div > 0
        if unit_name == 'tens'
          if div > 1
            if mod == 0
              parts << TENS_TABLE[number - mod]
            else
              parts << "#{TENS_TABLE[number - mod]}-"
              num_to_word(mod, parts)
            end
          else
            parts << NUMBER_TABLE[number]
          end
        elsif unit_name == 'ones'
          parts << NUMBER_TABLE[number]
        else
          parts << num_to_word(div)
          parts << ' '
          parts << unit_name
          parts << ' '
          num_to_word(mod, parts)
        end

        break
      end
    end

    parts.compact.join('').strip
  end
end

