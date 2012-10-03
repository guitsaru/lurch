require 'spec_helper'

describe "projects/edit" do
  before(:each) do
    @project = assign(:project, stub_model(Project,
      :repo => "MyString",
      :jenkins_id => "MyString"
    ))
  end

  it "renders the edit project form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => projects_path(@project), :method => "post" do
      assert_select "input#project_repo", :name => "project[repo]"
      assert_select "input#project_jenkins_id", :name => "project[jenkins_id]"
    end
  end
end
