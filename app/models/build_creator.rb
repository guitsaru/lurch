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
    update_pull_request_status
    notify_campfire
  end

  def notify_campfire
    return unless build.finished?

    text = nil
    build_url = "#{Setting.by_key('lurch_url').to_s}/projects/#{build.project.jenkins_id}/builds/#{build.id}"

    repo_id = build.repo
    repo_id += " (#{build.project.jenkins_id})" if build.repo.gsub('/', '-') != build.project.jenkins_id

    if build.succeeded?
      text = "Build succeeded on #{repo_id}: #{build_url}"
    elsif build.failed?
      text = "Build failed on #{repo_id}: #{build_url}"
    end

    Campfire.speak(text)
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

  def update_pull_request_status
    return unless build.finished?

    Github.update_repo_status_for_build(build)
  end
end
