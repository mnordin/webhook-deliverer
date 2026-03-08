class CellComponent < ViewComponent::Base
  def initialize(class_names: [], html: {})
    @class_names = class_names
    @html = html
  end

  private

  attr_reader :html

  def css_classes
    @class_names
  end
end
