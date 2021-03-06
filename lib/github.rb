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
      status_text = if build.failed?
                      "Build failed: #{lurch_url_for_build(build)}"
                    else
                      "Build passed: #{lurch_url_for_build(build)}"
                    end

      github.create_status(build.project.repo, build.sha, build.status, :description => status_text)

      create_github_comment_for_build(build, status_text)
    end

    def create_github_comment_for_build(build, text)
      return unless build.failed?

      begin
        pull_request = PullRequest.new(build.project, build.sha)
      rescue PullRequest::NotFoundException
        github.create_commit_comment(build.project.repo, build.sha, text)
      end

      creator  = pull_request.user
      comment = "@#{creator} #{text}"

      github.add_comment(build.project.repo, pull_request.id, comment)
    end

    def self.lurch_url_for_build(build)
      base_url = Setting.by_key('lurch_url').to_s

      "#{base_url}/projects/#{build.project.jenkins_id}/builds/#{build.id}"
    end

    def self.current_sha_for(project)
      github.commit(project.repo, 'master').sha
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

Github = if !defined?(Rails) || Rails.env.test?
           GitHub::Test
         else
           GitHub::HTTP
         end
