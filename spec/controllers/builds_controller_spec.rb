require 'spec_helper'

describe BuildsController do
  context "index" do
    context "with no specified project" do
      it "assigns builds" do
        build = stub
        Build.stub(:paginated_by_date => [build])

        get :index

        assigns(:builds).should == [build]
      end
    end

    context "with specified project" do
      it "assigns builds" do
        build   = stub
        scope   = stub(:paginated_by_date => [build])
        project = stub(:builds => scope)

        Project.stub(:find_by_jenkins_id).with('1').and_return(project)

        get :index, :project_id => 1

        assigns(:builds).should == [build]
      end
    end
  end

  context "show" do
    context "with no specified project" do
      it "assigns the build" do
        build = stub
        Build.stub(:find).with('1').and_return(build)

        get :show, :id => 1

        assigns(:build).should == build
      end
    end

    context "with specified project" do
      it "assigns build" do
        build   = stub
        scope   = stub
        project = stub(:builds => scope)

        scope.stub(:find).with('1').and_return(build)
        Project.stub(:find_by_jenkins_id).with('1').and_return(project)

        get :show, :id => 1, :project_id => 1

        assigns(:build).should == build
      end
    end

  end
end
