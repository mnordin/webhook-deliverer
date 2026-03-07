module WebhookDeliveries
  class WebhookDeliveryRowComponent < ViewComponent::Base
    def initialize(webhook_delivery:)
      @webhook_delivery = webhook_delivery
    end

    private

    attr_reader :webhook_delivery

    delegate(
      :id,
      :status,
      :url,
      :attempts,
      :last_response_code,
      :last_response,
      :payload,
      to: :webhook_delivery
    )

    def status_badge
      StatusBadgeComponent.new(status:)
    end
  end
end
