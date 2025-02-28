class MerchantSerializer
  def self.format_merchants(merchants, count_param)
    { data:
      merchants.map do |merchant|
        merchant_data = {
          id: merchant.id.to_s,
          type: "merchant",
          attributes: {
            name: merchant.name,
          }
        }
        
        if count_param == "true"
          merchant_data[:attributes][:item_count] = merchant.item_count 
        end

        merchant_data
      end
    }
  end

  def self.format_single(merchant)
    { data: {
        id: merchant.id.to_s,
        type: "merchant",
        attributes: {
          name: merchant.name,
        }
      }
    }
  end

end