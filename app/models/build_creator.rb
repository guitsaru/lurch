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
    pull_request = begin
      Github.pull_request_for_sha(build.project, build.sha)
    rescue
      nil
    end

    return if pull_request.nil?

    build.pull_request_id     = pull_request.html_url.split('/').last
    build.pull_request_user   = pull_request.head.repo.owner.login
    build.pull_request_branch = pull_request.head.ref
  end
end
