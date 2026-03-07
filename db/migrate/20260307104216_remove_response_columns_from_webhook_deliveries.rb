class RemoveResponseColumnsFromWebhookDeliveries < ActiveRecord::Migration[8.1]
  def change
    remove_column :webhook_deliveries, :attempts, :integer
    remove_column :webhook_deliveries, :last_response_code, :integer
    remove_column :webhook_deliveries, :last_response, :text
    remove_column :webhook_deliveries, :status, :integer
  end
end
