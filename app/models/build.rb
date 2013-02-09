class Build < ActiveRecord::Base
  attr_accessible :jenkins_id, :sha, :status, :repo

  belongs_to :project, :touch => true
  validates  :project_id, :presence => true

  def self.paginated_by_date(page=1, per_page=50)
    order('created_at DESC').page(page || 1).per(per_page)
  end

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

    "https://github.com/#{project.repo}/pull/#{pull_request_id}"
  end

  def ref
    pull_request_id ? [pull_request_user, pull_request_branch].join(':') : sha[0..30]
  end

  def ref_url
    pull_request_url || commit_url
  end
end
