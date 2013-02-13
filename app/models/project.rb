class Project < ActiveRecord::Base
  attr_accessible :jenkins_id, :repo

  validates :repo, :presence => true
  validates :jenkins_id, :presence => true, :uniqueness => true

  has_many :builds, :dependent => :destroy

  def to_param
    jenkins_id
  end

  def last_build
    builds.order('created_at DESC').first
  end

  def jenkins_url
     base = Setting.by_key('jenkins_url').to_s.chomp('/')
     base = "http://#{base}" unless base =~ /https?:\/\//

    "#{base}/job/#{jenkins_id}"
  end
end
