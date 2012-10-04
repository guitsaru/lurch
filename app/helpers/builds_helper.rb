module BuildsHelper
  def build_bootstrap_class(build)
    if build.succeeded?
      'success'
    elsif build.failed?
      'error'
    elsif build.started?
      'info'
    elsif build.pending?
      'warning'
    end
  end
end
