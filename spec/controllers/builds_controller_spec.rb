require 'spec_helper'

describe BuildsController do
  context "index" do
    context "with no specified project" do
      let(:build) { stub }

      before do
        Build.stub(:paginated_by_date => [build])

        get :index
      end

      it { should assign_to(:builds).with([build]) }
    end

    context "with specified project" do
      let(:build)   { stub }
      let(:scope)   { stub(:paginated_by_date => [build]) }
      let(:project) { stub(:builds => scope) }

      before do
        Project.stub(:find_by_jenkins_id).with('1').and_return(project)

        get :index, :project_id => 1
      end

      it { should assign_to(:builds).with([build]) }
    end
  end

  context "show" do
    context "with no specified project" do
      let(:build) { stub }

      before do
        Build.stub(:find).with('1').and_return(build)

        get :show, :id => 1
      end

      it { should assign_to(:build).with(build) }
    end

    context "with specified project" do
      let(:build) { stub }
      let(:scope) { stub }
      let(:project) { stub(:builds => scope) }

      before do
        scope.stub(:find).with('1').and_return(build)
        Project.stub(:find_by_jenkins_id).with('1').and_return(project)

        get :show, :id => 1, :project_id => 1
      end

      it { should assign_to(:build).with(build) }
    end
  end

  context "create" do
    context "with specified project" do
      let(:build) { stub }
      let(:scope) { stub }
      let(:project) { stub(:builds => scope, :repo => stub) }

      before do
        Project.stub(:find_by_jenkins_id).with('1').and_return(project)
        Github.stub(:current_sha_for).with(project).and_return('abcdefg')
        scope.stub(:create).with(:repo => project.repo, :sha => 'abcdefg').
                            and_return(build)

        post :create, :project_id => 1
      end

      it { should redirect_to(project_builds_path(project)) }
    end

    context "with no specified project" do
      before { post :create }

      it { should set_the_flash.to("You must specify a project") }
      it { should redirect_to(projects_path) }
    end
  end

  context "destroy" do
    context "with no specified project" do
      let(:build) { stub }

      before do
        Build.stub(:find).with('1').and_return(build)
        build.should_receive(:destroy)

        delete :destroy, :id => 1
      end

      it { should redirect_to(builds_path) }
    end

    context "with specified project" do
      let(:build) { stub }
      let(:scope) { stub }
      let(:project) { stub(:builds => scope) }

      before do
        scope.stub(:find).with('1').and_return(build)
        Project.stub(:find_by_jenkins_id).with('1').and_return(project)

        build.should_receive(:destroy)

        delete :destroy, :id => 1, :project_id => 1
      end

      it { should redirect_to(project_builds_path(project)) }
    end
  end
end
