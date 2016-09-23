#
# Decorator class to send proper response to the client
#
class ServersResponseDecorator

  #
  # Send Bad-Request response code back to user
  #
  def create_response_bad_request(message = '')
    message = message.present? ? message : 'Bad request'
    response = {
      body: { 
        status: message
      },
      status: 400
    }
    return response
  end

  #
  # Fucntion to create success response
  #
  def create_success_response
    response = {
      body: {
        status: "ok"
      },
      status: 200
    }
    return response
  end

  #
  # Fucntion to create success response with a message
  #
  def create_success_response(message='')
    message = message.present? ? message : 'ok'
    response = {
      body: {
        status: message
      },
      status: 200
    }
    return response
  end

  #
  # Function to create response for all the connections timeout time
  #
  def create_server_status_response(status)
    response = {
      body: status,
      status: 200
    }
    return response
  end
end
