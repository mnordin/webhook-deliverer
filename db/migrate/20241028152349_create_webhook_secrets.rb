class CreateWebhookSecrets < ActiveRecord::Migration[7.2]
  def change
    create_table :webhook_secrets do |t|
      t.string :secret, null: false
      t.boolean :active, default: false, null: false
      t.datetime :last_used_at, null: true
      t.references :webhook, null: false, foreign_key: true

      t.timestamps
    end

    add_index :webhook_secrets, [:webhook_id, :secret], unique: true
  end
end
