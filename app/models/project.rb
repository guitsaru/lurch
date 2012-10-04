class Project < ActiveRecord::Base
  attr_accessible :jenkins_id, :repo

  validates :repo, :presence => true
  validates :jenkins_id, :presence => true, :uniqueness => true

  has_many :builds, :dependent => :destroy

  before_create :create_jenkins_job
  after_create  :create_github_hook
  before_validation :set_jenkins_id

  def last_build
    builds.order('created_at DESC').first
  end

  def jenkins_url
     base = Setting.by_key('jenkins_url').to_s.chomp('/')
     base = "http://#{base}" unless base =~ /https?:\/\//

    "#{base}/job/#{jenkins_id}"
  end

  protected
  def set_jenkins_id
    return unless self.repo.present?
    return self.jenkins_id if self.jenkins_id.present?

    self.jenkins_id = self.repo.gsub('/', '-')
  end

  def create_jenkins_job
    Jenkins.new.create_job(self)
  end

  def create_github_hook
    Github.add_hook(self)
  end
end
