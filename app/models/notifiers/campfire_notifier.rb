class CampfireNotifier
  include Notifier

  def notify(build)
    return unless build.finished?

    text = if build.succeeded?
      "Build succeeded on #{repo_id(build)}: #{build_url(build)}"
    elsif build.failed?
      "Build failed on #{repo_id(build)}: #{build_url(build)}"
    end

    Campfire.speak(text)
  end

  def build_url(build)
    lurch_url = Setting.by_key('lurch_url').to_s

    "#{lurch_url}/projects/#{build.project.jenkins_id}/builds/#{build.id}"
  end

  def repo_id(build)
    repo_id = build.repo

    if build.repo.gsub('/', '-') != build.project.jenkins_id
      repo_id += " (#{build.project.jenkins_id})"
    end

    repo_id
  end
end

