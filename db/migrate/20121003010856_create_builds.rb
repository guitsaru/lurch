class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.string :sha
      t.string :jenkins_id
      t.string :status

      t.timestamps
    end
  end
end
