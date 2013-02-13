require 'spec_helper'

describe Project do
  subject { FactoryGirl.create(:project) }

  before do
    Jenkins.any_instance.stub(:create_job) { true }

    Setting.create(:key => 'jenkins_url', :value => 'http://example.com')
    Setting.create(:key => 'jenkins_user')
    Setting.create(:key => 'jenkins_password')
  end

  it { should validate_presence_of :repo }
  it { should validate_uniqueness_of :jenkins_id }
  it { should have_many(:builds) }

  describe :jenkins do
    it "should have a jenkins url" do
      project = FactoryGirl.build(:project, :repo => 'br/breport')
      project.jenkins_url.should == 'http://example.com/job/br-breport'
    end
  end
end
