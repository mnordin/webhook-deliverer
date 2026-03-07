class CreateWebhookDeliveryAttempts < ActiveRecord::Migration[8.1]
  def change
    create_table :webhook_delivery_attempts do |t|
      t.integer :response_code, null: false
      t.text :response
      t.references :webhook_delivery, null: false, foreign_key: true

      t.timestamps
    end
  end
end
