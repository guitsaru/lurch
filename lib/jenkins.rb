class Jenkins
  include HTTParty

  def initialize
    self.class.base_uri(Setting.find_by_key('jenkins_url').value)

    @auth = {
      :username => Setting.find_by_key('jenkins_user').value,
      :password => Setting.find_by_key('jenkins_password').value
    }
  end

  def create_job(project)
    repo = project.repo
    name = project.jenkins_id
    callback_url = 'http://google.com'

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
end
