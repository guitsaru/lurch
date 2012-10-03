class Build < ActiveRecord::Base
  attr_accessible :jenkins_id, :sha, :status

  belongs_to :project

  after_create :send_to_jenkins

  def jenkins_url
    "#{project.jenkins_url}/#{jenkins_id || 'lastBuild'}"
  end

  def jenkins_console_url
    jenkins_url + "/console"
  end

  protected
  def send_to_jenkins
    response = Jenkins.new.create_build(self)

    if response
      Rails.logger.info(response)
      self.status = 'building'
    else
      self.status = 'error'
    end

    self.save
  end
end
