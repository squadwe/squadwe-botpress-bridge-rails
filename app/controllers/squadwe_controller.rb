class SquadweController < ApplicationController
  def webhook
    Squadwe::ReceiveEvent.call(event: params)
    .on_success { |result| render(200, json: result.data) }
    .on_failure { |result| render(500, json: result.data) }
  end
end
