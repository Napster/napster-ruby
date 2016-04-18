require 'spec_helper'

describe Napster::Client do
  config_hash = ConfigLoader.init
  config_variables = config_hash['config_variables']

  it 'has a class' do
    expect(Napster::Client).not_to be nil
  end

  describe '.initialize' do
    it 'auth with password_grant' do
      options = {
        api_key: config_variables['API_KEY'],
        api_secret: config_variables['API_SECRET'],
        username: config_variables['USERNAME'],
        password: config_variables['PASSWORD']
      }

      client = Napster::Client.new(options)

      expect(client.access_token).to_not be_nil
      expect(client.refresh_token).to_not be_nil
      expect(client.expires_in).to_not be_nil
    end

    describe 'validate' do
      it 'should reject when api_key is missing' do
        options = { api_secret: Faker::Lorem.characters(20) }
        expect { Napster::Client.new(options) }.to raise_error(RuntimeError)
      end

      it 'should reject when api_secret is missing' do
        options = { api_key: Faker::Lorem.characters(20) }
        expect { Napster::Client.new(options) }.to raise_error(RuntimeError)
      end
    end

    it 'without attributes' do
      options = {
        api_key: Faker::Lorem.characters(20),
        api_secret: Faker::Lorem.characters(20)
      }
      client = Napster::Client.new(options)

      expect(client).to respond_to('api_key')
      expect(client).to respond_to('api_secret')
      expect(client).to respond_to('redirect_uri')
      expect(client).to respond_to('username')
      expect(client).to respond_to('password')
      expect(client).to respond_to('state')
      expect(client).to respond_to('auth_code')
      expect(client).to respond_to('access_token')
      expect(client).to respond_to('refresh_token')
      expect(client).to respond_to('expires_in')
      expect(client).to respond_to('request')
    end

    it 'with attributes' do
      options = {
        api_key: Faker::Lorem.characters(20),
        api_secret: Faker::Lorem.characters(20)
      }
      client = Napster::Client.new(options)

      expect(client.api_key).to eql(options[:api_key])
      expect(client.api_secret).to eql(options[:api_secret])
    end
  end

  describe '#authenticate' do
    describe 'validate' do
      it 'should reject auth_method as a non-symbol' do
        invalid_arg = Faker::Name.name
        options = {
          api_key: Faker::Lorem.characters(20),
          api_secret: Faker::Lorem.characters(20)
        }
        client = Napster::Client.new(options)
        expect { client.authenticate(invalid_arg) }
          .to raise_error(ArgumentError)
      end

      it 'should reject invalid auth_method' do
        invalid_arg = Faker::Name.name.to_sym
        options = {
          api_key: Faker::Lorem.characters(20),
          api_secret: Faker::Lorem.characters(20)
        }
        client = Napster::Client.new(options)
        expect { client.authenticate(invalid_arg) }
          .to raise_error(ArgumentError)
      end
    end

    describe '#auth_password_grant' do
      describe 'validate' do
        it 'should reject when username is missing' do
          options = {
            api_key: Faker::Lorem.characters(20),
            api_secret: Faker::Lorem.characters(20),
            password: Faker::Lorem.characters(20)
          }
          client = Napster::Client.new(options)

          expect { client.authenticate(:password_grant) }
            .to raise_error(RuntimeError)
        end

        it 'should reject when password is missing' do
          options = {
            api_key: Faker::Lorem.characters(20),
            api_secret: Faker::Lorem.characters(20),
            username: Faker::Lorem.characters(20)
          }
          client = Napster::Client.new(options)

          expect { client.authenticate(:password_grant) }
            .to raise_error(RuntimeError)
        end
      end

      it 'should authenticate' do
        options = {
          api_key: config_variables['API_KEY'],
          api_secret: config_variables['API_SECRET'],
          username: config_variables['USERNAME'],
          password: config_variables['PASSWORD']
        }

        client = Napster::Client.new(options)
        client = client.authenticate(:password_grant)

        expect(client.access_token).to_not be_nil
        expect(client.refresh_token).to_not be_nil
        expect(client.expires_in).to_not be_nil
      end
    end
  end

  describe '#auth_oauth2', type: :feature do
    describe 'validate' do
      it 'should reject when redirect_uri is missing' do
        options = {
          api_key: Faker::Lorem.characters(20),
          api_secret: Faker::Lorem.characters(20),
          auth_code: Faker::Lorem.characters(20)
        }
        client = Napster::Client.new(options)

        expect { client.authenticate(:oauth2) }
          .to raise_error(RuntimeError)
      end

      it 'should reject when auth_code is missing' do
        options = {
          api_key: Faker::Lorem.characters(20),
          api_secret: Faker::Lorem.characters(20),
          auth_code: Faker::Lorem.characters(20)
        }
        client = Napster::Client.new(options)

        expect { client.authenticate(:oauth2) }
          .to raise_error(RuntimeError)
      end
    end

    it 'should authenticate' do
      options = {
        api_key: config_variables['API_KEY'],
        api_secret: config_variables['API_SECRET'],
        redirect_uri: config_variables['REDIRECT_URI'],
        state: Faker::Lorem.characters(20)
      }
      client = Napster::Client.new(options)

      visit client.authentication_url
      within('.form-horizontal') do
        fill_in 'Username', with: config_variables['USERNAME']
        fill_in 'Password', with: config_variables['PASSWORD']
      end
      click_button 'Sign In'

      selector = '.btn.btn-primary.btn-warning.pull-right'
      redirect_uri = page.find(selector)['href']
      client.auth_code = CGI.parse(URI.parse(redirect_uri).query)['code'].first
      client.state = CGI.parse(URI.parse(redirect_uri).query)['state'].first
      client = client.authenticate(:oauth2)

      expect(client.access_token).to_not be_nil
      expect(client.refresh_token).to_not be_nil
      expect(client.expires_in).to_not be_nil
    end
  end

  describe '#authentication_url' do
    describe 'validate' do
      it 'should reject when redirect_uri is missing' do
        options = {
          api_key: Faker::Lorem.characters(20),
          api_secret: Faker::Lorem.characters(20)
        }
        client = Napster::Client.new(options)

        expect { client.authentication_url }.to raise_error(RuntimeError)
      end
    end

    it 'should get authentication_url' do
      options = {
        api_key: Faker::Lorem.characters(20),
        api_secret: Faker::Lorem.characters(20),
        redirect_uri: Faker::Internet.url
      }
      client = Napster::Client.new(options)
      url = client.authentication_url
      expect(url).to_not be_nil
    end
  end

  describe '#get' do
    it 'should get a response from Napster API' do
      client = ClientSpecHelper.get_client({})
      req_options = { headers: { 'Accept-Version' => '2.0.0' } }
      response = client.get('/artists/top', req_options)
      expect(response).to_not be_nil
    end

    it 'should get a response from Napster API\'s authenticated route' do
      includes = %w(username password)
      client = ClientSpecHelper.get_client(includes)
      client.authenticate(:password_grant)
      req_options = {
        headers: {
          Authorization: 'Bearer ' + client.access_token
        }
      }
      response = client.get('/v1/me/account', req_options)
      expect(response['logon']).to eql(client.username)
    end
  end

  describe '#put' do
    it 'should make a put request' do
      includes = %w(username password)
      client = ClientSpecHelper.get_client(includes)
      client.authenticate(:password_grant)
      playlists = ClientSpecHelper.get_me_library_playlists(client)
      playlist = playlists['playlists'][0]
      body = {
        'playlists' => {
          'name' => Faker::Lorem.word
        }
      }
      put_options = {
        headers: {
          Authorization: 'Bearer ' + client.access_token,
          'Content-Type' => 'application/json',
          'Accept-Version' => '2.0.0'
        }
      }
      response = client.put('/me/library/playlists/' + playlist['id'],
                            Oj.dump(body), put_options)
      updated_playlist = response['playlists'][0]
      expect(updated_playlist['name']).to eql(body['playlists']['name'])
    end
  end

  describe '#connect', type: :feature do
    it 'via password_grant' do
      options = {
        api_key: config_variables['API_KEY'],
        api_secret: config_variables['API_SECRET']
      }
      client = Napster::Client.new(options)
      client.username = config_variables['USERNAME']
      client.password = config_variables['PASSWORD']
      client.connect

      expect(client.access_token).to_not be_nil
      expect(client.refresh_token).to_not be_nil
      expect(client.expires_in).to_not be_nil
    end

    it 'via oauth2' do
      options = {
        api_key: config_variables['API_KEY'],
        api_secret: config_variables['API_SECRET'],
        redirect_uri: config_variables['REDIRECT_URI'],
        state: Faker::Lorem.characters(20)
      }
      client = Napster::Client.new(options)

      visit client.authentication_url
      within('.form-horizontal') do
        fill_in 'Username', with: config_variables['USERNAME']
        fill_in 'Password', with: config_variables['PASSWORD']
      end
      click_button 'Sign In'

      selector = '.btn.btn-primary.btn-warning.pull-right'
      redirect_uri = page.find(selector)['href']
      client.auth_code = CGI.parse(URI.parse(redirect_uri).query)['code'].first
      client.state = CGI.parse(URI.parse(redirect_uri).query)['state'].first
      client = client.connect

      expect(client.access_token).to_not be_nil
      expect(client.refresh_token).to_not be_nil
      expect(client.expires_in).to_not be_nil
    end
  end
end
