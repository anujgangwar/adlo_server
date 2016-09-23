#
# Custom error Module to do meaningful error handling
#
module CustomErrors
  #
  # Class InvalidDataError extended to standard error class of Ruby
  #
  class InvalidDataError < StandardError
    attr_accessor :failed_action, :message
    def initialize(message="")
      @failed_action = InvalidDataError
      @message = message
    end
  end
end
