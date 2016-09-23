class ServersController < ApplicationController
  # GET api/request/
  #
  # This API will keep the request running for provided timeout time on the server side.
  # After the successful completion of the provided time it returns the response
  #
  # Request::
  #    * connId: ID of new connection(required)
  #    * timeout: time in seconds for which the API should run(required)
  #
  # Response::
  #    * 200 ok: If API runs properly/gets killed in between.
  #    * 400 bad_request: If required params of the request is missing
  #
  def index
    servers_service = ServersService.new
    response = servers_service.index(params)
    render json: response[:body], status: response[:status]
  end

  # GET api/serverStatus
  # 
  # This API returns all the running requests on the server with their time left for completion.
  #
  # Response::
  #    * 200 ok: With the details of each connId
  #
  def status
    servers_service = ServersService.new
    response = servers_service.status
    render json: response[:body], status: response[:status]
  end

  # PUT api/kill
  #
  # This API will finish the running request with provided connId and if not found returns an
  # error message
  #
  # Request::
  #    * connID: ID of connection which needs to be killed
  #
  # Response::
  #    * 200 ok: When connection is killed/no connection found.
  #    * 400 bad_request: If connID param is missing in the request
  #
  def kill
    servers_service = ServersService.new
    response = servers_service.kill(params)
    render json: response[:body], status: response[:status]
  end
end