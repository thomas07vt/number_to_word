require "number_to_word/version"

class NumberToWord
  attr_reader :number

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
    ''
  end
end

