class AddPullRequestIdToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :pull_request_id, :integer
    add_column :builds, :pull_request_user, :string
    add_column :builds, :pull_request_branch, :string
  end
end
