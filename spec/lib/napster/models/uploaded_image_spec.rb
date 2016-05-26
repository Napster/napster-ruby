require 'spec_helper'
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)

describe Napster::Models::UploadedImage do
  it 'has a class' do
    expect(Napster::Models::UploadedImage).not_to be nil
  end

  describe '.new' do
    it 'should instantiate without data' do
      uploaded_image = Napster::Models::UploadedImage.new({})

      expect(uploaded_image.class).to eql(Napster::Models::UploadedImage)
    end

    it 'should instantiate with a client' do
      uploaded_image = Napster::Models::UploadedImage.new(client: client)

      expect(uploaded_image.class).to eql(Napster::Models::UploadedImage)
    end
  end
end
