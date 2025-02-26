class ItemSerializer
  def self.format_items(items)
    { data:
      items.map do |item|
        {
          id: item.id.to_s,
          type: "item",
          attributes: {
            name: item.name,
            description: item.description,
            unit_price: item.unit_price,
            merchant_id: item.merchant_id,
          }
        }
      end
    }
  end

  def self.format_single(item)
    { data: {
        id: item.id.to_s,
        type: "item",
        attributes: {
          name: item.name,
          description: item.description,
          unit_price: item.unit_price,
          merchant_id: item.merchant_id,
        }
      }
    }
  end
end