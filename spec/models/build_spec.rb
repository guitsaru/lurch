require 'spec_helper'

describe Build do
  it { should belong_to(:project) }
end
