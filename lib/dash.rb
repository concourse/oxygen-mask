module Dash
  def dash_route(path = '')
    URI.join ATC_URL, path
  end
end
