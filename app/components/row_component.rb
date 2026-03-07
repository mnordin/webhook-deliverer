class RowComponent < ViewComponent::Base
  renders_many :cells, CellComponent

  def initialize(html: {})
    @html = html
  end

  private

  def html_attributes
    @html
  end
end
