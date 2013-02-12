module Notifier
  def included(base)
    NotifierManager.add_notifier(base.new)
  end
end
