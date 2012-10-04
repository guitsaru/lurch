module GitHub
  class HTTP
    def self.github
      login    = Setting.by_key('github_username')
      password = Setting.by_key('github_password')
      github   = Octokit::Client.new(:login => login, :password => password)
    end

    def self.add_hook(project)
      hook_url = Setting.by_key('lurch_url').to_s + '/github'
      hook_url = 'http://' + hook_url unless hook_url =~ /https?:\/\//

      options  = {:url => hook_url}
      params   = {:events => ["push", "pull_request"], :active => true}

      github.create_hook(project.repo, 'web', options, params)
    end

    def self.pull_request_for_sha(project, sha)
      pull_requests = github.pull_requests(project.repo)
      pull_requests.select { |r| r['head']['sha'] =~ /^#{sha}/ }.first
    end

    def self.update_repo_status_for_build(build)
      build_url = "#{Setting.by_key('lurch_url').to_s}/projects/#{build.project.id}/builds/#{build.id}"
      status_text = build.failed? ? "Build failed: #{build_url}" : "Build passed: #{build_url}"

      github.create_status(build.project.repo, build.sha, build.status, :description => status_text)

      pull_request = pull_request_for_sha(build.project, build.sha)

      if build.failed? && pull_request
        creator  = pull_request['head']['user']['login']
        comment = "@#{creator} #{status_text}"

        github.add_comment(build.project.repo, pull_request['number'], comment)
      end
    end
  end

  class Test
    def self.add_hook(project)
      true
    end

    def self.pull_request_for_sha(project, sha)
    end
  end
end

Github = if Rails.env.test?
           GitHub::Test
         else
           GitHub::HTTP
         end
