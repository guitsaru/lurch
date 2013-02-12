require 'spec_helper'

describe BuildCreator do
  let(:build) { OpenStruct.new }

  subject { BuildCreator.new(build) }

  context "create!" do
    before do
      subject.stub(:update_pull_request_information)
      subject.stub(:send_to_jenkins)
      build.stub(:save!)
    end

    it "updates pull request information" do
      subject.should_receive(:update_pull_request_information)

      subject.create!
    end

    it "sends to jenkins" do
      subject.should_receive(:send_to_jenkins)

      subject.create!
    end

    it "saves the record twice" do
      subject.build.should_receive(:save!).twice

      subject.create!
    end
  end

  context "save!" do
    before do
      subject.build.stub(:save!)
    end

    it "runs the notifiers" do
      NotifierManager.should_receive(:notify_all)

      subject.save!
    end

    it "saves the record" do
      subject.build.should_receive(:save!)

      subject.save!
    end
  end

  context "send_to_jenkins" do
    it "sets to pending on successful response" do
      jenkins = stub
      jenkins.stub(:create_build).with(build).and_return(true)
      Jenkins.stub(:new).and_return(jenkins)

      subject.send_to_jenkins

      build.status.should == 'pending'
    end

    it "sets to error on successful response" do
      jenkins = stub
      jenkins.stub(:create_build).with(build).and_return(false)
      Jenkins.stub(:new).and_return(jenkins)

      subject.send_to_jenkins

      build.status.should == 'error'
    end
  end

  context "update_pull_request_information" do
    let(:project) { stub }
    let(:sha)     { stub }

    before do
      build.stub(:project => project)
      build.stub(:sha     => sha)
    end

    it "does nothing if no pull_request found" do
      Github.stub(:pull_request_for_sha).with(project, sha).and_return(nil)

      subject.update_pull_request_information.should == nil
    end

    it "updates the build if there is a pull request" do
      head    = stub
      head.stub(:repo => stub(:owner => stub(:login => 'guitsaru')),
                :ref  => 'branch')

      request = stub
      request.stub(:html_url) { 'something/1' }
      request.stub(:head) { head }

      Github.stub(:pull_request_for_sha).with(project, sha).and_return(request)

      subject.update_pull_request_information

      subject.build.pull_request_id.should == '1'
      subject.build.pull_request_user.should == 'guitsaru'
      subject.build.pull_request_branch.should == 'branch'
    end
  end
end
