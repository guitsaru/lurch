require 'spec_helper'

describe GithubController do

  describe "GET 'create'" do
    it "returns http success" do
      FactoryGirl.create(:project, :repo => "test/test")
      get 'create', :payload => {'after' => 'abcdef', 'repository' => {'name' => 'test', 'owner' => {'name' => 'test'}}}.to_json

      response.should be_success
    end
  end

end
