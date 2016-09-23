#AdLo Server API

##Problem Statement 

Implement a server which should be capable of doing the following:

   - Exposes a GET API as "api/request?connId=19&timeout=80" 

 This API will keep the request running for provided time on the server side. After 

the successful completion of the provided time it should return {"status":"ok"}

   - Exposes a GET API as "api/serverStatus" 

 This API returns all the running requests on the server with their time left for 

completion. E.g {"2":"15","8":"10"} where 2 and 8 are the connIds and 15 and 10 

is the time remaining for the requests to complete (in seconds).

   - Exposes a PUT API as "api/kill" with payload as {"connId":12} 

This API will finish the running request with provided connId, so that the finished 

request returns {"status":"killed"} and the current request will return 

{"status":"ok"}. If no running request found with the provided connId on the server 

then the current request should return "status":"invalid connection Id : <connId>"}

## Rails Version
Version of rails used in this project is 4.2.5 .A gem file containing the version numbers of each gem used in this application is present. 

##Installation

To install rails in linux based system follow the following guide: http://railsapps.github.io/installrubyonrails-ubuntu.html
Windows and Mac OS users refer to: http://railsinstaller.org/en 

After Rails is setup: `git clone git@github.com:anujgangwar/adlo_server.git` and run `bundle install` and then `rails s`

##Documentation

I have done documentation Using Yardoc Gem. To generate docs run on terminal: 'yardoc'
After the docs are generated just run 'yard server' and now you can access documentation [http://localhost:8808]

##Design
I have Used Three layes to execute the Given APIs

1. Controller (It basically routes the External requests to the internal Action and which in turn calls the respective service to perform the logical operations for the proper response) Have avoided all the logical thing from controller just to avoid file getting too big when we add more APIs to it

2. Service layer (It basically does all the operations as per the requirement)

3. Decorator layer (it basically creates the proper response as per the scenarios)

4. We can add API layer in between controller & Services and move all the validation of requests to API files, There will be one file corresponding to each API

5. We can add Data Access layer which basicaly comes in between the Model and service layes, here we can write all the querries pertaining to the respective model


In this way we can make our code re-usable.

##Socket
Have used Puma gem to provide the facility of Sockets thus we can handle concurrent requests. For concurrency to happend we need to delete Rack lock in our enviroment config file `config.middleware.delete Rack::Lock`

###Example

1. [http://localhost:3000/api/request?connId=19&tiomeout=60] to create a new request.

2. [http://localhost:3000/api/serverStatus] to show the server status

3. [http://localhost:3000/api/kill] with payload as {"connId":"19"} to kill the ongoing request with id 19.

4. [http://localhost:3000/something] will throw an error page not found

