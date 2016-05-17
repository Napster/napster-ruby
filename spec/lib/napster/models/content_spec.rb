require 'spec_helper'
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET']
}
client = Napster::Client.new(options)

describe Napster::Models::Content do
  it 'has a class' do
    expect(Napster::Models::Content).not_to be nil
  end
end
