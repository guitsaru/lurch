require 'set'
require 'active_support/core_ext/class/attribute_accessors'

class NotifierManager
  cattr_accessor(:notifiers) { Set.new }

  def self.add_notifier(notifier)
    notifiers.add(notifier)
  end

  def self.notify_all(build)
    notifiers.each { |n| n.notify(build) }
  end
end
