module WebhookDeliveries
  class TableComponent < ViewComponent::Base
    renders_one :headers
    renders_many :rows

    def initialize(webhook_deliveries:)
      @webhook_deliveries = webhook_deliveries
    end

    private

    attr_reader :webhook_deliveries
  end
end
