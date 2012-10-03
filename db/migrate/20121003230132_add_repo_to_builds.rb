class AddRepoToBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :repo, :string
  end
end
