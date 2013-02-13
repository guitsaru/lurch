class BuildCreator
  attr_reader :build

  def initialize(build)
    @build = build
  end

  def create!
    update_pull_request_information
    build.save!
    send_to_jenkins
    build.save!
  end

  def save!
    build.save!
    NotifierManager.notify_all(build)
  end

  def send_to_jenkins
    response = Jenkins.new.create_build(build)

    if response
      build.status = 'pending'
    else
      build.status = 'error'
    end
  end

  def update_pull_request_information
    begin
      pull_request = PullRequest.new(build.project, build.sha)
    rescue PullRequest::NotFoundException
      return
    end

    build.pull_request_id     = pull_request.id
    build.pull_request_user   = pull_request.user
    build.pull_request_branch = pull_request.branch
  end
end
