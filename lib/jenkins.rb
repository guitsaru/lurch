class JenkinsHTTP
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

    options = {
      :basic_auth => @auth,
      :query      => {
        :json => {
          :parameter => [
            {:name => 'LURCH_SHA1', :value => build.sha},
            {:name => 'LURCH_REPO', :value => build.repo},
            {:name => 'LURCH_ID',   :value => build.id}
          ]}.to_json
      }
    }

    self.class.post("/job/#{project.jenkins_id}/build",
                    options)
  end
end

class MockJenkins
  def create_job(project)
  end

  def create_build(build)
  end
end

Jenkins = if !defined?(Rails) || Rails.env.test?
            MockJenkins
          else
            JenkinsHTTP
          end
