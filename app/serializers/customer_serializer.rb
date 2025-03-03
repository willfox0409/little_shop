class CustomerSerializer
  def self.format_customers(customers)
    { data:
      customers.map do |customer|
        {
          id: customer.id.to_s,
          type: "customer",
          attributes: {
            first_name: customer.first_name,
            last_name: customer.last_name
          }
        }
      end
    }
  end
end
