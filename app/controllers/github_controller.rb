class GithubController < ApplicationController
  protect_from_forgery :except => :create

  def create
    head :bad_request and return unless params[:payload].present?

    payload    = Payload.new(params[:payload])
    sha        = payload.sha

    project    = Project.find_by_repo(payload.main_repo)

    head(:not_found) and return unless project

    if payload.buildable?
      project.builds.create(:sha => sha, :repo => payload.current_repo)
    end

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
      body['repository']['owner']['name'] || body['pull_request']['base']['repo']['owner']['login']
    end

    def repository
      body['repository']['name']
    end

    def current_repo
      if pull_request?
        body['pull_request']['head']['repo']['full_name']
      else
        main_repo
      end
    end

    def sha
      body['after'] || body['pull_request']['head']['sha']
    end

    def buildable?
      return false if sha =~ /\A0+\z/
      return false if Build.find_by_sha(sha)
      return true unless pull_request?

      body['action'] == 'opened' || body['action'] == 'synchronize'
    end
  end
end
