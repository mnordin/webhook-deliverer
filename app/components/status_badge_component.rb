class StatusBadgeComponent < ViewComponent::Base
  def initialize(status:)
    @status = status
  end

  private
  attr_reader :status


  def status_css_classes
    {
      failure: "bg-red-200 text-red-700 inset-ring-red-500/10",
      success: "bg-green-200 text-green-700 inset-ring-green-500/10"
    }.fetch(status.to_sym, "bg-slate-200")
  end
end
