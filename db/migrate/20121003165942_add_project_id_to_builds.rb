class AddProjectIdToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :project_id, :integer
  end
end
