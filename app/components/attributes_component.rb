class AttributesComponent < ViewComponent::Base
  renders_many :rows, lambda { |**options, &block|
    RowComponent.new(**options, &block)
  }

  class RowComponent < ViewComponent::Base
    renders_many :values, lambda { |title:, size: :info, **options, &block|
      component = AttributeComponent.new(title: title, size: size, **options)
      component.with_value(&block)
      component
    }

    def initialize(grid_cols: 4)
      @grid_cols = grid_cols
    end

    attr_reader :grid_cols
  end

  class AttributeComponent < ViewComponent::Base
    renders_one :value

    def initialize(title:, size: :info)
      @title = title
      @size = size
    end

    private

    attr_reader :title, :size

    def col_span
      case size
      when :info then "col-span-1"
      when :detail then "col-span-2"
      else "col-span-1"
      end
    end
  end
end
