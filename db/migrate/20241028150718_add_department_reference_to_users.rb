class AddDepartmentReferenceToUsers < ActiveRecord::Migration[7.2]
  def change
    add_reference :users, :department, null: false, foreign_key: true, index: true
  end
end
