require 'spec_helper_without_rails'

require 'models/pull_request'
require 'github'

describe PullRequest do
  let(:project) { stub }
  let(:sha)     { stub }

  context "when one does not exist" do
    it "raises an exception" do
      expect do
        PullRequest.new(project, sha)
      end.to raise_exception(PullRequest::NotFoundException)
    end
  end

  context "when one does exist" do
    subject { PullRequest.new(project, sha) }

    let(:response) do
      response = stub
      head     = stub

      head.stub(:ref  => 'branch')
      head.stub(:repo => stub(:owner => stub(:login => 'collaborator')))

      response.stub(:html_url => "github.com/guitsaru/lurch/pull/1")
      response.stub(:head     => head)

      response
    end

    before do
      Github.stub(:pull_request_for_sha).with(project, sha).and_return(response)
    end

    it "has an id" do
      subject.id.should == '1'
    end

    it "has a user" do
      subject.user.should == 'collaborator'
    end

    it "has a branch" do
      subject.branch.should == 'branch'
    end
  end
end
