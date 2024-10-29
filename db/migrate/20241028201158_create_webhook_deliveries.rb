class CreateWebhookDeliveries < ActiveRecord::Migration[7.2]
  def change
    create_table :webhook_deliveries do |t|
      t.integer :status, default: 0, null: false
      t.integer :attempts, default: 0, null: false
      t.integer :last_response_code
      t.text :last_response
      t.json :payload, null: false
      t.string :url, null: false
      t.references :webhook_subscription, null: false, foreign_key: true

      t.timestamps
    end
  end
end
