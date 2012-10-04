module BuildsHelper
  def build_bootstrap_class(build)
    return '' unless build
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

  def build_bootstrap_label_class(build)
    if build.succeeded?
      'label-success'
    elsif build.failed?
      'label-important'
    elsif build.started?
      'label-info'
    elsif build.pending?
      'label-warning'
    end
  end
end
