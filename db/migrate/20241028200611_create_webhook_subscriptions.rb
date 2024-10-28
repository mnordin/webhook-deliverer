class CreateWebhookSubscriptions < ActiveRecord::Migration[7.2]
  def change
    create_table :webhook_subscriptions do |t|
      t.integer :event, default: 0, null: false
      t.string :relative_path
      t.references :webhook, null: false, foreign_key: true

      t.timestamps
    end
  end
end
