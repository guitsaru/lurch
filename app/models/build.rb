class Build < ActiveRecord::Base
  attr_accessible :jenkins_id, :sha, :status

  belongs_to :project

  after_create :send_to_jenkins

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
