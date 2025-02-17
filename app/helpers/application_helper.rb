module ApplicationHelper
  def status_color_class(status)
    case status
    when "confirmed"
      "text-green-500"
    when "cancelled"
      "text-red-500"
    else
      "text-yellow-500"
    end
  end
end
