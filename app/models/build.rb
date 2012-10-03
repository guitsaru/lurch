class Build < ActiveRecord::Base
  attr_accessible :jenkins_id, :sha, :status

  belongs_to :project

  before_create :send_to_jenkins

  protected
  def send_to_jenkins
    if Jenkins.new.create_build(self)
      self.status = 'building'
    else
      self.status = 'error'
    end
  end
end
