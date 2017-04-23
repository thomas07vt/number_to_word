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

    # 0 - 9 are base words and 10-15 (14 is normal :) ) so lets tests those
    # explicitly. I usually don't like to have more than one assertion per 'it'
    # block, but if I did that, then I would be writing a lot more text that
    # would probably make this test file harder to read
    context '0-15' do
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
      end
    end

    # These teens can be programmatically tested, so we can still have full test
    # coverage, assuming that the base number conversion is correct. We just
    # check that the pattern is matched:
    #
    # e.g. 16
    #   base = 6 #=> 'six',
    #   unit = 'teen'
    #
    #   result = 'sixteen'
    #
    context '16-19' do
      it 'returns teens correctly' do
        (16..19).each do |number|
          base = number - 10
          expect(NumberToWord.new(number).word).to \
            eq("#{NumberToWord.new(base).word}teen")
        end
      end
    end

    context '20s' do
      it 'returns twenties correctly' do
        expect(NumberToWord.new(20).word).to eq('twenty')

        (21..29).each do |number|
          base = number - 20
          expect(NumberToWord.new(number).word).to \
            eq("twenty #{NumberToWord.new(base).word}")
        end
      end
    end

    context '30s' do
      it 'returns thirties correctly' do
        expect(NumberToWord.new(30).word).to eq('thirty')

        (31..39).each do |number|
          base = number - 30
          expect(NumberToWord.new(number).word).to \
            eq("thirty #{NumberToWord.new(base).word}")
        end
      end
    end
  end
end

