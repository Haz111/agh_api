require 'rails_helper'

RSpec.describe V1::StatsController do
  before(:each) do
    allow_any_instance_of(V1::StatsController).to receive(:api_authenticate).and_return(true)
  end

  it "should get version" do
    get '/version', {}, {'Accept' => 'application/agh.edu.pl; version=1'}
    assert_response 200
    assert_match /Version 1/, response.body
  end
end