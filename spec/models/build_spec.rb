require 'spec_helper'

describe Build do
  it { should belong_to(:project) }
  it { should validate_presence_of(:project_id) }

  it "paginates builds by date" do
    oldest_build  = FactoryGirl.create(:build, :created_at => 3.months.ago)
    older_build   = FactoryGirl.create(:build, :created_at => 2.months.ago)
    newer_build   = FactoryGirl.create(:build, :created_at => 1.month.ago)
    newest_build  = FactoryGirl.create(:build)

    Build.paginated_by_date(1, 2).should == [newest_build, newer_build]
    Build.paginated_by_date(2, 2).should == [older_build, oldest_build]
  end
end
