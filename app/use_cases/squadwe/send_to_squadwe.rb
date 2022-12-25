require 'faraday'

class Squadwe::SendToSquadwe < Micro::Case
  attributes :event
  attribute :botpress_response

  def call!
    account_id = event['account']['id']
    conversation_id = event['conversation']['id']
    squadwe_endpoint = event['squadwe_endpoint'] || ENV['SQUADWE_ENDPOINT']
    squadwe_bot_token = event['squadwe_bot_token'] || ENV['SQUADWE_BOT_TOKEN']

    if botpress_response_choise_options?(botpress_response)
      return Squadwe::SendToSquadweRequest.call(
        account_id: account_id, conversation_id: conversation_id, 
        squadwe_endpoint: squadwe_endpoint, squadwe_bot_token: squadwe_bot_token,
        body: build_choise_options_body(botpress_response)
      )
    else
      return Squadwe::SendToSquadweRequest.call(
        account_id: account_id, conversation_id: conversation_id, 
        squadwe_endpoint: squadwe_endpoint, squadwe_bot_token: squadwe_bot_token,
        body: { content: botpress_response['text'] }
      )
    end
  end

  def botpress_response_choise_options?(botpress_response)
    botpress_response['type'] == 'single-choice'
  end

  def build_choise_options_body(botpress_response)
    { content: botpress_response['text'], content_type: 'input_select', content_attributes: { items: botpress_response['choices'].map { | option | { title: option['title'], value:  option['value'] } } }  }
  end
end