class GithubController < ApplicationController
  protect_from_forgery :except => :create

  def create
    params[:payload] ||= '{}'
    payload    = JSON.parse(params[:payload])
    repository = payload['repository']['name']
    owner      = payload['repository']['owner']['name']
    sha        = payload['after']

    project    = Project.find_by_repo("#{owner}/#{repository}")

    project.builds.create(:sha => sha)

    head :created
  end
end
