require 'spec_helper'
config_hash = ConfigLoader.init
config_variables = config_hash['config_variables']
options = {
  api_key: config_variables['API_KEY'],
  api_secret: config_variables['API_SECRET'],
  username: config_variables['USERNAME'],
  password: config_variables['PASSWORD']
}
client = Napster::Client.new(options)
client.authenticate(:password_grant)

describe Napster::Me do
  it 'has a class' do
    expect(Napster::Me).not_to be nil
  end

  it '.profile' do
    profile = client.me.profile

    expect(profile.class).to eql(Napster::Models::Profile)
  end

  it '.update_profile' do
    body = {
      'me' => {
        'bio' => Faker::Lorem.word
      }
    }
    client.me.update_profile(body)
    profile = client.me.profile

    expect(profile.bio).to eql(body['me']['bio'])
  end
end
