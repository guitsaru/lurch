class ProjectsController < ApplicationController
  def index
    @projects = Project.order("updated_at desc")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @projects }
    end
  end

  def show
    @project = Project.find_by_jenkins_id(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @project }
    end
  end

  def new
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @project }
    end
  end

  def edit
    @project = Project.find_by_jenkins_id(params[:id])
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      begin
        ProjectCreator.new(@project).create!
      rescue
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }

        return
      end

      format.html { redirect_to @project, notice: 'Project was successfully created.' }
      format.json { render json: @project, status: :created, location: @project }
    end
  end

  def update
    @project = Project.find_by_jenkins_id(params[:id])

    respond_to do |format|
      begin
        ProjectCreator.new(@project).update_attributes!(params[:project])
      rescue
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }

        return
      end

      format.html { redirect_to @project, notice: 'Project was successfully updated.' }
      format.json { head :no_content }
    end
  end

  def destroy
    @project = Project.find_by_jenkins_id(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end
end
