class BuildsController < ApplicationController
  def index
    @builds = scope.order("created_at DESC").page(params[:page]).per(50)

    respond_to do |format|
      format.html
      format.json { render :json => @builds }
    end
  end

  def show
    @build = scope.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => @build }
    end
  end

  def create
    @project = Project.find_by_jenkins_id(params[:project_id])

    unless @project
      flash[:error] = 'You must specify a project'
      redirect_to projects_path
      return
    end

    @project.builds.create(:sha => Github.current_sha_for(@project),
                           :repo => @project.repo)

    redirect_to(project_builds_path(@project))
  end

  def destroy
    @build = scope.find(params[:id])
    @build.destroy

    respond_to do |format|
      format.html { redirect_to [@project, @build] }
      format.json { head :no_content }
    end
  end

  protected
  def scope
    if params[:project_id]
      @project = Project.find_by_jenkins_id(params[:project_id])
      @project.builds
    else
      Build
    end
  end
end
