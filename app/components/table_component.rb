class TableComponent < ViewComponent::Base
  renders_many :headers, HeaderComponent
  renders_many :rows, RowComponent

  def initialize(class_names: [], tbody_class_names: [], html: {})
    @class_names = class_names
    @tbody_class_names = tbody_class_names
    @html = html
  end

  private

  attr_reader :html

  def css_classes
    @class_names
  end

  def tbody_css_classes
    @tbody_class_names
  end
end
