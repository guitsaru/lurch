class Build < ActiveRecord::Base
  attr_accessible :jenkins_id, :sha, :status, :repo

  belongs_to :project
  validates  :project_id, :presence => true

  after_create :send_to_jenkins
  after_update :update_pull_request_status

  def jenkins_url
    return '' unless project
    "#{project.jenkins_url}/#{jenkins_id || 'lastBuild'}"
  end

  def jenkins_console_url
    jenkins_url + "/console"
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

  protected
  def send_to_jenkins
    response = Jenkins.new.create_build(self)

    if response
      self.status = 'building'
    else
      self.status = 'error'
    end

    self.save
  end

  def update_pull_request_status
    return unless finished?

    response = Github.update_repo_status_for_build(self)
  end
end
