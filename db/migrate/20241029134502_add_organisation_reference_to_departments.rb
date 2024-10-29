class AddOrganisationReferenceToDepartments < ActiveRecord::Migration[7.2]
  def change
    # Note: Unsafe migration if you already have existing data
    add_reference :departments, :organisation, null: true, foreign_key: true
  end
end
