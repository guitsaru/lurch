class GithubController < ApplicationController
  protect_from_forgery :except => :create

  def create
    head :bad_request and return unless params[:payload].present?

    payload    = Payload.new(params[:payload])
    sha        = payload.sha

    project    = Project.find_by_repo(payload.main_repo)

    head(:not_found) and return unless project

    project.builds.create(:sha => sha, :repo => payload.current_repo)

    head :created
  end

  class Payload
    attr_accessor :body

    def initialize(json)
      @body = JSON.parse(json)
    end

    def pull_request
      body['pull_request']
    end

    def pull_request?
      pull_request.present?
    end

    def main_repo
      "#{owner}/#{repository}"
    end

    def owner
      body['repository']['owner']['name'] || body['repository']['owner']['login']
    end

    def repository
      body['repository']['name']
    end

    def current_repo
      if pull_request?
        body['head']['repo']['full_name']
      else
        main_repo
      end
    end

    def sha
      body['after']
    end
  end
end
