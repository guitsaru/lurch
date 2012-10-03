class Setting < ActiveRecord::Base
  attr_accessible :key, :value

  def self.by_key(key)
    Setting.find_by_key(key).try(:value)
  end
end
