require 'spec_helper'

describe "builds/index" do
  before(:each) do
    assign(:builds, [
      stub_model(Build,
        :sha => "Sha",
        :jenkins_id => "Jenkins",
        :status => "Status"
      ),
      stub_model(Build,
        :sha => "Sha",
        :jenkins_id => "Jenkins",
        :status => "Status"
      )
    ])
  end

  it "renders a list of builds" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Sha".to_s, :count => 2
    assert_select "tr>td", :text => "Jenkins".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
  end
end
