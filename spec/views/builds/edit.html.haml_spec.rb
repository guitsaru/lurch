require 'spec_helper'

describe "builds/edit" do
  before(:each) do
    @build = assign(:build, stub_model(Build,
      :sha => "MyString",
      :jenkins_id => "MyString",
      :status => "MyString"
    ))
  end

  it "renders the edit build form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => builds_path(@build), :method => "post" do
      assert_select "input#build_sha", :name => "build[sha]"
      assert_select "input#build_jenkins_id", :name => "build[jenkins_id]"
      assert_select "input#build_status", :name => "build[status]"
    end
  end
end
