class GithubNotifier
  include Notifier

  def notify(build)
    Github.update_repo_status_for_build(build)
  end
end
