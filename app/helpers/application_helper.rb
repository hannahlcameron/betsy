module ApplicationHelper
  def readable_date(date)
    ("<span class='date'>" + date.strftime("%b %d, %Y") + "</span>").html_safe
  end
end
