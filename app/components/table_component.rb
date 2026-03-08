class TableComponent < ViewComponent::Base
  renders_many :headers
  renders_many :rows, RowComponent

  def initialize(class_names: [], html: {})
    @class_names = Array(class_names)
    @html = html
  end

  private
  attr_reader :html

  def css_classes
    @class_names
  end
end
