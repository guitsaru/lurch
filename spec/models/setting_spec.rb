require 'spec_helper'

describe Setting do
  it "should have the by_key helper" do
    Setting.create(:key => 'key', :value => 'value')

    Setting.by_key('key').should == 'value'
  end
end

