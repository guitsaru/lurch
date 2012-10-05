class Build < ActiveRecord::Base
  attr_accessible :jenkins_id, :sha, :status, :repo

  belongs_to :project, :touch => true
  validates  :project_id, :presence => true

  before_create :check_for_pull_request
  after_create :send_to_jenkins
  after_update :update_pull_request_status
  after_save   :notify_campfire

  def jenkins_url
    return '' unless project
    "#{project.jenkins_url}/#{jenkins_id || 'lastBuild'}"
  end

  def jenkins_console_url
    jenkins_url + "/console"
  end

  def started?
    status == 'started'
  end

  def pending?
    status == 'pending'
  end

  def finished?
    failed? || succeeded?
  end

  def failed?
    status == "failure"
  end

  def succeeded?
    status == "success"
  end

  def commit_url
   "https://github.com/#{self.repo}/commit/#{self.sha}" 
  end

  def pull_request_url
    return unless pull_request_id

    "https://github.com/#{project.repo}/pulls/#{pull_request_id}"
  end

  def ref
    pull_request_id ? [pull_request_user, pull_request_branch].join(':') : sha[0..30]
  end

  def ref_url
    pull_request_url || commit_url
  end

  protected
  def check_for_pull_request
    pull_request = Github.pull_request_for_sha(project, sha)
    return unless pull_request

    self.pull_request_id     = pull_request.html_url.split('/').last
    self.pull_request_user   = pull_request.head.repo.owner.login
    self.pull_request_branch = pull_request.head.ref
  end

  def send_to_jenkins
    response = Jenkins.new.create_build(self)

    if response
      self.status = 'pending'
    else
      self.status = 'error'
    end

    self.save
  end

  def update_pull_request_status
    return unless finished?

    response = Github.update_repo_status_for_build(self)
  end

  def notify_campfire
    text = nil
    build_url = "#{Setting.by_key('lurch_url').to_s}/projects/#{self.project.jenkins_id}/builds/#{self.id}"

    repo_id = self.repo
    repo_id += " (#{self.project.jenkins_id})" if self.repo.gsub('/', '-') != self.project.jenkins_id

    if succeeded?
      text = "Build succeeded on #{self.repo}: #{build_url}"
    end

    if failed?
      text = "Build failed on #{self.repo}: #{build_url}"
    end

    Campfire.speak(text) if text
  end
end
