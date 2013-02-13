class ProjectsController < ApplicationController
  def index
    @projects = Project.order("updated_at desc")
  end

  def show
    @project = Project.find_by_jenkins_id(params[:id])
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find_by_jenkins_id(params[:id])
  end

  def create
    @project = Project.new(params[:project])

    begin
      ProjectCreator.new(@project).create!
    rescue
      render(:action => "new") and return
    end

    redirect_to(@project, :notice =>'Project was successfully created.')
  end

  def update
    @project = Project.find_by_jenkins_id(params[:id])

    begin
      ProjectCreator.new(@project).update_attributes!(params[:project])
    rescue
      render action: "edit" and return
    end

    redirect_to(@project, :notice => 'Project was successfully updated.')
  end

  def destroy
    @project = Project.find_by_jenkins_id(params[:id])
    @project.destroy

    redirect_to(projects_url)
  end
end
