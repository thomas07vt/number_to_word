require "spec_helper"

# Number must be positive - it will always be positive.
# Needs to work for millions as well.
RSpec.describe NumberToWord do
  it "has a version number" do
    expect(NumberToWord::VERSION).not_to be nil
  end

  describe '.initialize' do
    it 'allows an integer as an argument' do
      expect { NumberToWord.new(8) }.to_not raise_error
    end

    # @todo Do we need to allow floats? I will start off by just allowing
    # Integers. If floats are allowed, how many decimals? That could get
    # complicated, however I think we could use the same logic for the left
    # side of the decimal as the right.
    it 'it does not allow floats' do
      expect { NumberToWord.new(8.0) }.to raise_error(ArgumentError)
    end

    # @todo You mentioned that 'it will always be positive' do I don't think
    # this test is necessary, but its an easy assertion to make in the
    # initialize block so I will check that
    it 'it does not allow negative numbers' do
      expect { NumberToWord.new(-8) }.to raise_error(ArgumentError)
    end
  end

  context '#number' do
    let(:subject) { NumberToWord.new(8) }

    it 'returns the unerlying integer' do
      expect(subject.number).to eq(8)
    end
  end

  context '#word' do
    let(:subject) { NumberToWord.new(8) }

    it 'returns a string' do
      expect(subject.word).to be_a(String)
    end

    # 0 - 19 are base words that aren't easily tested programatically
    # so lets tests those explicitly. I usually don't like to have more
    # than one assertion per 'it' block, but if I did that, then I would
    # be writing a lot more text that would probably make this test file
    # harder to read
    context '0-19' do
      it 'returns the correct word for the given integer' do
        expect(NumberToWord.new(0).word).to eq('zero')
        expect(NumberToWord.new(1).word).to eq('one')
        expect(NumberToWord.new(2).word).to eq('two')
        expect(NumberToWord.new(3).word).to eq('three')
        expect(NumberToWord.new(4).word).to eq('four')
        expect(NumberToWord.new(5).word).to eq('five')
        expect(NumberToWord.new(6).word).to eq('six')
        expect(NumberToWord.new(7).word).to eq('seven')
        expect(NumberToWord.new(8).word).to eq('eight')
        expect(NumberToWord.new(9).word).to eq('nine')
        expect(NumberToWord.new(10).word).to eq('ten')
        expect(NumberToWord.new(11).word).to eq('eleven')
        expect(NumberToWord.new(12).word).to eq('twelve')
        expect(NumberToWord.new(13).word).to eq('thirteen')
        expect(NumberToWord.new(14).word).to eq('fourteen')
        expect(NumberToWord.new(15).word).to eq('fifteen')
        expect(NumberToWord.new(16).word).to eq('sixteen')
        expect(NumberToWord.new(17).word).to eq('seventeen')
        expect(NumberToWord.new(18).word).to eq('eighteen')
        expect(NumberToWord.new(19).word).to eq('nineteen')
      end
    end

    context 'the rest of the 10s' do
      it 'returns the appropriate word for the given 10s number' do
        (20..99).each do |number|
          # This will round to the nearest 10s
          # e.g 29 will get converted to 20, 31 will get converted to 30
          # #floor() isn't necessary in ruby 2.4, but it does make it more
          # obvious what this line is doing
          tens_unit = (number / 10).floor * 10
          ones_unit = number - tens_unit
          # This test isn't super explicit, but basically 20 - 99 is
          # programatically verifyable, so I can actully test all these
          # combinations instead of just picking random samples
          tens_unit_word = NumberToWord.new(tens_unit).word
          ones_unit_word = NumberToWord.new(ones_unit).word unless ones_unit == 0
          expect(NumberToWord.new(number).word).to \
            eq([tens_unit_word, ones_unit_word].compact.join('-'))
        end
      end

      # Since the tests above is programmatic, it would help to have a sanity
      # check test or two, which will also get accross what the above test is 
      # doing
      context 'sanity checking' do
        it 'returns 83 correctly' do
          expect(NumberToWord.new(83).word).to eq('eighty-three')
        end

        it 'returns 27 correctly' do
          expect(NumberToWord.new(27).word).to eq('twenty-seven')
        end
      end
    end

    # This takes a little while to run. Realistically we woudn't run this test
    # every time, just on some ci/cd machine. We could go up to 1 billion but
    # that would take a really long time to run, so I am not going to do it :)
    #
    # This test assumes that all numbers under 100 are returning correctly.
    # Since we have tests above, we can be sure of that. Having tests depend on
    # other tests isn't great, but for some reason I really want to test very
    # number up to 1 million
    context '100 - 1_000_000' do
      it 'returns the appropriate word for the given 100 - 1_000_000' do
        # We will loop though each unit stage and test all of them between
        # the current unit and next unit
        units = [100, 1000, 1_000_000]
        while units.length > 1 do
          unit = units.shift
          (unit...units[0]).each do |number|
            unit_specific = (number / unit).floor * unit
            remainder = number % unit

            unit_word = NumberToWord.new(unit_specific).word
            remainder_word = NumberToWord.new(remainder).word unless remainder == 0

            expect(NumberToWord.new(number).word).to \
              eq([unit_word, remainder_word].compact.join(' '))
          end
        end
      end

      context 'sanity checking' do
        it 'returns 120 correctly' do
          expect(NumberToWord.new(120).word).to eq('one hundred twenty')
        end

        it 'returns 999 correctly' do
          expect(NumberToWord.new(999).word).to eq('nine hundred ninety-nine')
        end

        # I want to make sure we test some numbers between 1 milion and 1 billion
        it 'returns 985_723_146 correctly' do
          expect(NumberToWord.new(985_723_146).word).to \
            eq('nine hundred eighty-five million seven hundred twenty-three thousand one hundred fourty-six')
        end
      end
    end
  end
end

