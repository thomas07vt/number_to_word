require "benchmark/memory"
require 'number_to_word'

def zero
  NumberToWord.new(0).word
end

def single_digit
  NumberToWord.new(7).word
end

def tens
  NumberToWord.new(18).word
end

def below_hundred
  NumberToWord.new(84).word
end

def thousands
  NumberToWord.new(4321).word
end

def millions
  NumberToWord.new(1_856_231).word
end

Benchmark.memory do |x|
  x.report("preload")          { NumberToWord.solutions }
  x.report("zero")          { zero }
  x.report("single_digit")  { single_digit }
  x.report("tens")          { tens }
  x.report("below_hundred") { below_hundred }
  x.report("thousands")     { thousands }
  x.report("millions")      { millions }

  x.compare!
end

