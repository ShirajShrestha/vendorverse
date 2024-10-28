module OrdersHelper
  def status_color_class(status)
    case status
    when "pending"
      "text-yellow-500"
    when "confirmed"
      "text-green-500"
    when "cancelled"
      "text-red-500"
    else
      "text-gray-500"
    end
  end
end
