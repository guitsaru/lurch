require 'spec_helper'

describe "projects/index" do
  before(:each) do
    assign(:projects, [
      stub_model(Project,
        :repo => "Repo",
        :jenkins_id => "Jenkins"
      ),
      stub_model(Project,
        :repo => "Repo",
        :jenkins_id => "Jenkins"
      )
    ])
  end

  it "renders a list of projects" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Repo".to_s, :count => 2
    assert_select "tr>td", :text => "Jenkins".to_s, :count => 2
  end
end
