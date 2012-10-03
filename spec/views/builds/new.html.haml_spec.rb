require 'spec_helper'

describe "builds/new" do
  before(:each) do
    assign(:build, stub_model(Build,
      :sha => "MyString",
      :jenkins_id => "MyString",
      :status => "MyString"
    ).as_new_record)
  end

  it "renders new build form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => builds_path, :method => "post" do
      assert_select "input#build_sha", :name => "build[sha]"
      assert_select "input#build_jenkins_id", :name => "build[jenkins_id]"
      assert_select "input#build_status", :name => "build[status]"
    end
  end
end
