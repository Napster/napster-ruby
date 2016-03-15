require 'spec_helper'

describe Napster::Request do
  it 'has a class' do
    expect(Napster::Request).not_to be nil
  end

  describe '.initialize' do
    it 'without attributes' do
      request = Napster::Request.new({})

      expect(request).to respond_to('faraday')
    end

    it 'with attributes' do
      options = {
        access_token: Faker::Lorem.characters(20),
        api_key: Faker::Lorem.characters(20),
        api_secret: Faker::Lorem.characters(20)
      }
      request = Napster::Request.new(options)

      expect(request).to respond_to('faraday')
    end
  end
end
