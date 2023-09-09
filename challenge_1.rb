# frozen_string_literal: true

class NavigateUntilTheEnd
  require 'faraday'

  attr_accessor :connection, :response, :message_body

  INITIAL_URL = 'https://www.letsrevolutionizetesting.com/challenge'
  GO_ON_MESSAGE = 'This is not the end'
  MESSAGE_KEY = 'message'
  FOLLOW_KEY = 'follow'
  REQUEST_HEADERS = { accept: 'application/json' }

  def initialize
    @connection = lambda do |url|
      Faraday.new(url: url, headers: REQUEST_HEADERS) do |faraday|
        faraday.response :json
      end
    end
  end

  def start
    communicate

    while message_body.eql?( GO_ON_MESSAGE )
      print '#'
      communicate( response.body[ FOLLOW_KEY ] )
    end

    puts "\n" + message_body
  end

  private

  def communicate(url = INITIAL_URL)
    @response = @connection.call(url).get
    @message_body = @response.body[ MESSAGE_KEY ]
  end
end

NavigateUntilTheEnd.new.start
