class TableComponent < ViewComponent::Base
  renders_many :headers
  renders_many :rows, RowComponent

  def initialize(html: {})
    @html = html
  end

  private

  def html_attributes
    @html
  end
end
