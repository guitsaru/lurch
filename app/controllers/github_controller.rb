class GithubController < ApplicationController
  def create
    params[:payload] ||= '{}'
    payload = JSON.parse(params[:payload])
    sha     = payload['after']

    Build.create(:sha => sha)

    render :head => :ok
  end
end
