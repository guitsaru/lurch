require 'spec_helper'

describe "projects/new" do
  before(:each) do
    assign(:project, stub_model(Project,
      :repo => "MyString",
      :jenkins_id => "MyString"
    ).as_new_record)
  end

  it "renders new project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path, :method => "post" do
      assert_select "input#project_repo", :name => "project[repo]"
      assert_select "input#project_jenkins_id", :name => "project[jenkins_id]"
    end
  end
end
