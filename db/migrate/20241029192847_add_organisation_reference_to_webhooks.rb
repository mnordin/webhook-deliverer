class AddOrganisationReferenceToWebhooks < ActiveRecord::Migration[7.2]
  def change
    # Note: Unsafe migration to add a null false constraint to a new column on an existing table
    # if you have existing data.
    add_reference :webhooks, :organisation, null: false, foreign_key: true
  end
end
