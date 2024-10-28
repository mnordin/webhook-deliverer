class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :work_email, null: false
      t.string :personal_email
      t.string :job_title
      t.date :first_day_of_work
      t.references :manager, null: true, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end
  end
end
