require 'spec_helper_without_rails'

require 'models/notifier_manager'

describe NotifierManager do
  subject { NotifierManager }
  before  { NotifierManager.notifiers.clear }
  after  { NotifierManager.notifiers.clear }

  let(:build) { stub }

  context "with no notifiers" do
    it "should not notify anything" do
      subject.notify_all(build).should == Set.new
    end
  end

  context "with notifiers" do
    it "should notify" do
      notifier_1 = stub
      notifier_2 = stub

      notifier_1.should_receive(:notify).with(build)
      notifier_2.should_receive(:notify).with(build)

      subject.add_notifier(notifier_1)
      subject.add_notifier(notifier_2)

      subject.notify_all(build)
    end
  end
end
