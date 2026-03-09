class WebhookDeliveriesController < ApplicationController
  def index
    @webhook_deliveries = WebhookDelivery.includes(:webhook_delivery_attempts).order(id: :desc)
  end

  def show
    @webhook_delivery = WebhookDelivery.includes(:webhook_delivery_attempts).find(params[:id])
  end
end
