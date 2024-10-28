class CreateWebhooks < ActiveRecord::Migration[7.2]
  def change
    create_table :webhooks do |t|
      t.string :url, null: false

      t.timestamps
    end
  end
end
