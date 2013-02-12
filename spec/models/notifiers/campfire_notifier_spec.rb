require 'spec_helper_without_rails'

module Notifier; end

require 'campfire'
require 'models/notifiers/campfire_notifier'


describe CampfireNotifier do
  let(:build) { stub }

  it "does nothing if the build isn't finished" do
    build.stub(:finished? => false)

    subject.notify(build).should be_nil
  end

  it "notifies campfire on a successfull build" do
    build.stub(:finished? => true)
    build.stub(:succeeded? => true)

    subject.stub(:build_url => "http://example.com")
    subject.stub(:repo_id => "br/br")

    Campfire.should_receive(:speak).with("Build succeeded on br/br: http://example.com")

    subject.notify(build)
  end
end
