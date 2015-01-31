require 'spec_helper'

describe 'Registering a new user' do

  let(:body) { {email: 'test@test.com', 
                username: 'Josh', 
                display_name: '@bebbs',
                password: 'test',
                password_confirmation: 'test' }.to_json 
              }
  
  it 'With valid details' do
    sign_up = post '/api/users/new', body, {'Content-Type' => 'application/json'}
    expect{new_user}.to change(User, :count).by 1
  end

end