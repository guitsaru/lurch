class BuildsController < ApplicationController
  def index
    @builds = scope.order("created_at DESC")

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

  def destroy
    @build = scope.find(params[:id])
    @build.destroy

    respond_to do |format|
      format.html { redirect_to builds_url }
      format.json { head :no_content }
    end
  end

  protected
  def scope
    if params[:project_id]
      Project.find(params[:project_id]).builds
    else
      Build
    end
  end
end
