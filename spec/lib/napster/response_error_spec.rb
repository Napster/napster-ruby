require 'spec_helper'

describe Napster::ResponseError do
  it 'has a class' do
    expect(Napster::ResponseError).not_to be nil
  end

  it '#message' do
    client = ClientSpecHelper.get_client([])
    expect { client.playlists.find('pp.125821370').tracks({}) }
      .to raise_error(Napster::ResponseError)
  end
end
