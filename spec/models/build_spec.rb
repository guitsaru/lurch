require 'spec_helper'

describe Build do
  it { should belong_to(:project) }
  it { should validate_presence_of(:project_id) }
end
