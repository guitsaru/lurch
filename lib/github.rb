module GitHub
  class HTTP
    def self.add_hook(project)
      hook_url = Setting.by_key('lurch_url').to_s + '/github'
      hook_url = 'http://' + hook_url unless hook_url =~ /https?:\/\//
      login    = Setting.by_key('github_username')
      password = Setting.by_key('github_password')
      github   = Octokit::Client.new(:login => login, :password => password)

      options  = {:url => hook_url}
      params   = {:events => ["push"], :active => true}

      github.create_hook(project.repo, 'web', options, params)
    end
  end

  class Test
    def self.add_hook(project)
      true
    end
  end
end

Github = if Rails.env.test?
           GitHub::Test
         else
           GitHub::HTTP
         end
