class Project < ActiveRecord::Base
  attr_accessible :jenkins_id, :repo

  validates :repo, :presence => true
  validates :jenkins_id, :presence => true, :uniqueness => true

  before_create :create_jenkins_job
  before_validation :set_jenkins_id

  def jenkins_url
    base = Setting.find_by_key('jenkins_url').try(:value).to_s.chomp('/')
    base = "http://#{base}" unless base =~ /http:\/\//

    "#{base}/job/#{jenkins_id}"
  end

  protected
  def set_jenkins_id
    return false unless self.repo.present?

    self.jenkins_id = self.repo.gsub('/', '-')
  end

  def create_jenkins_job
    Jenkins.new.create_job(self)
  end
end
