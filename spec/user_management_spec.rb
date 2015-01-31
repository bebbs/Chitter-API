require 'spec_helper'

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

def sign_up(content)
  post '/api/users/new', content, {'Content-Type' => 'application/json'}
end