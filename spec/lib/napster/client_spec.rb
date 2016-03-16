require 'spec_helper'

describe Napster::Client do
  it 'has a class' do
    expect(Napster::Client).not_to be nil
  end

  describe '.initialize' do
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

    describe 'password_grant' do
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
        config_hash = ConfigLoader.init
        config_variables = config_hash['config_variables']
        options = {
          api_key: config_variables['API_KEY'],
          api_secret: config_variables['API_SECRET'],
          username: config_variables['USERNAME'],
          password: config_variables['PASSWORD']
        }

        client = Napster::Client.new(options)
        response = client.authenticate(:password_grant)

        expect(client.access_token).to_not be_nil
        expect(client.refresh_token).to_not be_nil
        expect(client.expires_in).to_not be_nil
        expect(response).to_not be_nil
      end
    end
  end
end
