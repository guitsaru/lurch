class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :repo
      t.string :jenkins_id

      t.timestamps
    end
  end
end
