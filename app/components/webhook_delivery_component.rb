class WebhookDeliveryComponent < ViewComponent::Base
  def initialize(webhook_delivery:)
    @webhook_delivery = webhook_delivery
  end

  def row_class
    case webhook_delivery.status
    when "failure"
      "bg-red-200"
    when "success"
      "bg-green-200"
    else
      "bg-slate-200"
    end
  end

  private

  attr_reader :webhook_delivery
end
