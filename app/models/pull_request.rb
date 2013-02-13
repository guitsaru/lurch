class PullRequest
  class NotFoundException < Exception; end

  def initialize(project, sha)
    @pull_request = Github.pull_request_for_sha(project, sha)

    raise NotFoundException if @pull_request.nil?
  end

  def id
    @pull_request.html_url.split('/').last
  end

  def user
    @pull_request.head.repo.owner.login
  end

  def branch
    @pull_request.head.ref
  end
end
