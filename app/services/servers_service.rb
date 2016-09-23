#
# Service class to perform the logical operations and return the proper response to the controller
# 
class ServersService < ApplicationController
  #
  # Global Variable to store the new connection and it's details
  # 
  # @example [hash] { connId: {
  #      19: 60,
  #      20: 45
  #   }
  # }
  #
  $connections=Hash.new
  #
  # Global Variable to store the if a connection is killed
  # 
  # @example [hash] {
  #    19: true,
  #    20: true
  # }
  #
  $killed=Hash.new



  #
  # This service function will keep the request running for provided timeout time on the server side.
  # After the successful completion of the provided time it returns the response
  #
  # @param [hash] [connId & timeout]
  #
  # @return [JSON]] [200 ok/400 bad_request]
  #
  def index(params)
    server_response_decorator = ServersResponseDecorator.new
    begin
      validate_new_connection_request(params)
    rescue CustomErrors::InvalidDataError=>e
      return server_response_decorator.create_response_bad_request(e.message)
    end
    connId=params[:connId].to_s
    timeout = params[:timeout].to_i
    $connections[connId]={
      timeout: timeout,
      start_time: Time.zone.now.to_i
    }
    current_time = Time.zone.now.to_i
    start_time = $connections[connId][:start_time]
    while (current_time - start_time <= timeout)
      if $killed[connId] == true
        status = 1
        break
      end
      current_time = Time.zone.now.to_i
    end
    $connections.delete(connId)
    if status == 1
      $killed.delete(connId)
      return server_response_decorator.create_success_response("killed")
    else
      return server_response_decorator.create_success_response
    end
  end

  # 
  # Service function returns all the running requests on the server with their time left for completion.
  #
  # @return [JSON] [timeout remaining for all the connections]
  #
  def status
    server_response_decorator = ServersResponseDecorator.new
    status=Hash.new
    $connections.each do |key,value|
      timeout=value[:timeout]
      start_time = value[:start_time]
      current_time = Time.zone.now.to_i
      if (current_time - start_time) >= timeout
        $connections.delete(key)
      else
        status[key]= (timeout - (current_time-start_time))
      end
    end
    return server_response_decorator.create_server_status_response(status)
  end

  #
  # Service function will finish the running request with provided connId and if not found returns an
  # error message
  #
  # @param [hash] [connId which is to be killed]
  #
  # @return [JSON] [200 ok/400 bad_request]
  #
  def kill(params)
    server_response_decorator = ServersResponseDecorator.new
    if(params[:connId].blank?)
      return server_response_decorator.create_response_bad_request("connId is required, Bad request")
    end
    connId=params[:connId].to_s
    $connections.each do |key, value|
      timeout = value[:timeout]
      start_time = value[:start_time]
      current_time = Time.zone.now.to_i
      if (current_time - start_time) >= timeout
        $connections.delete(key)
      end
      if(key == connId)
        $killed[connId] = true
      end
    end
    status=Hash.new
    status[:status]="invalid connection id "+params[:connId].to_s
    if $killed[connId]
      return server_response_decorator.create_success_response
    else
      return server_response_decorator.create_server_status_response(status)
    end
  end

  private

    #
    # Private service function to validate the incoming request for new connection
    #
    # @param [hash] [should have two keys: connId & timeout]
    # 
    # @return [array] [if required params are present returns null array]
    # @raise [InvalidDataError] [If any of the two error is not present it raises error]
    #
    def validate_new_connection_request(params)
      error_array = []
      error_array.push('connId') if params[:connId].blank?
      error_array.push('timeout') if params[:timeout].blank?
      # If required fields are not present return with bad request response
      if error_array.present?
        error_string = error_array.join(', ')
        raise CustomErrors::InvalidDataError.new(error_string+" fields must be present, Bad request")
      end
    end
end