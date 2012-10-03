class Build < ActiveRecord::Base
  attr_accessible :jenkins_id, :sha, :status

  belongs_to :project

  before_create :send_to_jenkins

  protected
  def send_to_jenkins
    response = Jenkins.new.create_build(self)

    if response.try(:success?)
      self.status = 'building'
    else
      self.status = 'error'
    end
  end
end
