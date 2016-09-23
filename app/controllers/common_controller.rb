class CommonController < ApplicationController

  #
  # Action:: Not Found
  # This action is hit when no route found
  # --- 404 ---
  #
  def not_found
    response = {
      error: { message: "Page not found" },
    }
    
    render json: response, status: 404
  end

end
