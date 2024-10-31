module Webhooks
  class Response
    delegate :status, :body, to: :response

    def initialize(response)
      @response = response
    end

    def success?
      status.between?(200, 299)
    end

    def failure?
      !success?
    end

    private

    attr_reader :response
  end
end
