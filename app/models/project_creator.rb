class ProjectCreator
  attr_reader :project

  def initialize(project)
    @project = project
  end

  def create!
    return unless project.valid?

    set_jenkins_id
    project.save!
    create_jenkins_job
    create_github_hook
  end

  def update!(attributes)
    project.update_attributes!(attributes)
  end

  def create_jenkins_job
    Jenkins.new.create_job(project)
  end

  def create_github_hook
    Github.add_hook(project)
  end

  def set_jenkins_id
    project.jenkins_id = project.repo.gsub('/', '-')
  end
end
