require 'faraday'

class Squadwe::SendToSquadweRequest < Micro::Case
  attributes :account_id
  attributes :conversation_id
  attribute :body

  attributes :squadwe_endpoint
  attributes :squadwe_bot_token

  def call!
    url = "#{squadwe_endpoint}/api/v1/accounts/#{account_id}/conversations/#{conversation_id}/messages"

    response = Faraday.post(url, body.to_json, 
      {'Content-Type': 'application/json', 'api_access_token': "#{squadwe_bot_token}"}
    )

    if (response.status == 200)
      Success result: JSON.parse(response.body)
    elsif (response.status == 404 && response.body.include?('Resource could not be found') )
      Failure result: { message: 'Squadwe resource could not be found' }
    elsif (response.status == 404)
      Failure result: { message: 'Invalid squadwe endpoint' }
    elsif (response.status == 401)
      Failure result: { message: 'Invalid squadwe access token' }
    else
      Failure result: { message: 'Squadwe server error' }
    end
  end
end