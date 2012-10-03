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

  describe :jenkins do
    it "should create a new jenkins job on creation" do
      Jenkins.any_instance.should_receive(:create_job)

      FactoryGirl.create(:project, :repo => 'br/breport')
    end

    it "should have a jenkins url" do
      project = FactoryGirl.build(:project, :repo => 'br/breport')
      project.jenkins_url.should == 'http://example.com/job/br-breport'
    end
  end
end
