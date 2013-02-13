require 'spec_helper_without_rails'

module HTTParty; end
require 'models/project_creator'
require 'jenkins'
require 'github'

describe ProjectCreator do
  let(:project) do
    stub(:save! => true, :valid? => true, :repo => "guitsaru/lurch", :jenkins_id= => true)
  end

  subject { ProjectCreator.new(project) }

  context "create!" do
    it "creates a jenkins job" do
      Jenkins.any_instance.should_receive(:create_job).with(project)

      subject.create!
    end

    it "creates a github hook" do
      Github.should_receive(:add_hook).with(project)

      subject.create!
    end

    it "sets the jenkins id" do
      project.should_receive(:jenkins_id=).with("guitsaru-lurch")

      subject.create!
    end

    it "does nothing if project isn't valid" do
      project.stub(:valid? => false)

      subject.create!.should be_nil
    end
  end
end
