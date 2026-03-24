class TableComponent < ViewComponent::Base
  renders_many :headers, Table::HeaderComponent
  renders_many :rows, Table::RowComponent

  def initialize(class_names: [], tbody_class_names: [], html: {}, tbody_html: {})
    @class_names = class_names
    @tbody_class_names = tbody_class_names
    @html = html
    @tbody_html = tbody_html
  end

  private

  attr_reader :html, :tbody_html

  def css_classes
    @class_names
  end

  def tbody_css_classes
    @tbody_class_names
  end
end
