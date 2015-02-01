require 'spec_helper'
require 'helpers/user_management'

describe 'Registering a new user' do

  let(:body) { {:email => 'test@test.com', 
                :username => 'Josh', 
                :display_name => '@bebbs',
                :password => 'test',
                :password_confirmation => 'test' }.to_json 
              }
  let(:no_pass_body) { {:email => 'test@abc.com',
                        :username => 'abc',
                        :display_name => '@bebbs',
                        :password => 'test',
                        :password_confirmation => 'wrong'}.to_json
                      }


  it 'With valid details' do
    expect{sign_up(body)}.to change(User, :count).by 1
    expect(User.first.email).to eq('test@test.com')
  end

  it 'With a password that doesn\'t match' do
    expect{sign_up(no_pass_body)}.to change(User, :count).by 0
  end

  it 'With duplicate details' do
    sign_up(body)
    expect{sign_up(body)}.to change(User, :count).by 0
  end

end

describe 'User sessions' do

  let(:good_login) { {'email' => 'test@test.com', 'password' => 'test'}.to_json }
  let(:bad_login) { {'email' => 'test@test.com', 'password' => 'wrong'}.to_json }

  before(:all) do
    @user = User.create(email: 'test@test.com',
                username: '@bebbs',
                display_name: 'Josh',
                password: 'test',
                password_confirmation: 'test')
  end

  context 'Logging in' do

    it 'With the correct credentials' do
      sign_in(good_login)
      expect(last_response_data['token']).to match /^[a-f0-9]{32}$/
      expect(last_response.status).to eq 200
    end

    it 'With the incorrect credentials' do
      sign_in(bad_login)
      expect(last_response.status).to eq 401
    end

  end

  context 'Logging out' do

    it 'As a logged in user' do
      sign_in(good_login)
      token = last_response_data['token']
      delete 'api/tokens', 'token' => token
      expect(@user.token).to be_nil
    end

    it 'As a logged out user' do
      delete 'api/tokens', 'token' => 'abcdefg'
      expect(last_response.status).to eq 404
    end

  end

end

