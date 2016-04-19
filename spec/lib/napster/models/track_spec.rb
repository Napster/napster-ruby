require 'spec_helper'
tracks_top = FixtureLoader.init('tracks_top.json')

describe Napster::Models::Track do
  it 'has a class' do
    expect(Napster::Models::Track).not_to be nil
  end

  describe '.new' do
    it 'should instantiate' do
      track = Napster::Models::Track.new({})

      Napster::Models::Track::ATTRIBUTES.each do |attr|
        expect(track).to respond_to(attr)
      end
    end

    it 'should assign values' do
      track = Napster::Models::Track.new(tracks_top['tracks'].first)

      expect(track.type).to eql('track')
    end
  end
end
