class ResponseCodeBadgeComponent < ViewComponent::Base
  def initialize(response_code:)
    @response_code = response_code
  end

  private

  attr_reader :response_code

  def status
    case response_code
    when 200..299 then "success"
    when Integer then "failure"
    else "pending"
    end
  end
end
