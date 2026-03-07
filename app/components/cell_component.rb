class CellComponent < ViewComponent::Base
  VARIANTS = {
    default: "cell-condensed",
    mono: "cell-condensed font-mono"
  }.freeze

  def initialize(variant: :default, html: {})
    @variant = variant
    @html = html
  end

  private

  def html_attributes
    @html.merge(class: cell_classes)
  end

  def cell_classes
    VARIANTS.fetch(@variant)
  end
end
