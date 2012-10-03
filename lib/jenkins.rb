class Jenkins
  include HTTParty

  def initialize
    self.class.base_uri(Setting.by_key('jenkins_url'))

    @auth = {
      :username => Setting.by_key('jenkins_user'),
      :password => Setting.by_key('jenkins_password')
    }
  end

  def create_job(project)
    repo = project.repo
    name = project.jenkins_id
    callback_url = Setting.by_key('lurch_url').to_s + '/jenkins'
    callback_url = 'http://' + callback_url unless callback_url =~ /https?:\/\//

    template = File.read(File.join(Rails.root, 'config', 'default.xml.erb'))
    config = ERB.new(template).result(binding)

    options = {
      :query => {:name => name},
      :basic_auth => @auth,
      :headers => {'Content-Type' => 'application/xml'},
      :body => config
    }

    self.class.post('/createItem', options)
  end

  def create_build(build)
    project = build.try(:project)
    return unless project

    options = {:body => {'LURCH_SHA1' => build.sha, 'LURCH_ID' => build.id}}

    self.class.post("/job/#{project.jenkins_id}/buildWithParameters/api/json",
                    options)
  end
end
