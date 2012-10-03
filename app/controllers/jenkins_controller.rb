class JenkinsController < ApplicationController
  protect_from_forgery :except => :create

  # Sample Payload
  #
  # {
  #   "name":"JobName",
  #   "url":"JobUrl",
  #   "build":{
  #             "number":1,
  #             "phase":"STARTED",
  #             "status":"FAILED",
  #             "url":"job/project/5",
  #             "fullUrl":"http://ci.jenkins.org/job/project/5"
  #             "parameters":{"branch":"master"}
  #           }
  # }
  def create
    payload = Payload.new(request.body.read)
    build   = Build.find(payload.build_id)
    sha     = payload.sha

    build.jenkins_id = payload.jenkins_id
    if payload.started?
      build.status = 'started'
    elsif payload.completed?
      build.status = payload.status
    end

    build.save

    head :ok
  end

  class Payload
    attr_accessor :data

    def initialize(json)
      @data = JSON.parse(json)
    end

    def build
      data['build']
    end

    def build_id
      build['parameters']['LURCH_ID']
    end

    def jenkins_id
      build['number']
    end

    def sha
      build['parameters']['LURCH_SHA1']
    end

    def started?
      build['phase'] == 'STARTED'
    end

    def completed?
      build['phase'] == 'FINISHED'
    end

    def status
      build['status'].downcase
    end
  end
end
