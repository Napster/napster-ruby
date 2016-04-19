require 'spec_helper'
genres = FixtureLoader.init('genres.json')

describe Napster::Models::Genre do
  it 'has a class' do
    expect(Napster::Models::Genre).not_to be nil
  end

  describe '.new' do
    it 'should instantiate' do
      genre = Napster::Models::Genre.new({})

      Napster::Models::Genre::ATTRIBUTES.each do |attr|
        expect(genre).to respond_to(attr)
      end
    end

    it 'should assign values' do
      genre = Napster::Models::Genre.new(genres['genres'].first)

      expect(genre.type).to eql('genre')
    end
  end
end
