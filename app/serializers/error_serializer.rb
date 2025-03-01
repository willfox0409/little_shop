class ErrorSerializer
  def self.new(message, status)
    {
      errors: [
        {
          status: status,
          message: message
        }
      ]
    }
  end
end