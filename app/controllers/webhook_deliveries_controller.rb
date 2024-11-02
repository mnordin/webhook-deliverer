class WebhookDeliveriesController < ApplicationController
  def index
    @webhook_deliveries = WebhookDelivery.order(id: :desc)
  end
end
