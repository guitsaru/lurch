require 'spec_helper_without_rails'

module Notifier; end

require 'github'
require 'models/notifiers/github_notifier'


describe GithubNotifier do
  let(:build) { stub }

  it "updates the pull request status" do
    Github.should_receive(:update_repo_status_for_build).with(build)

    subject.notify(build)
  end
end
