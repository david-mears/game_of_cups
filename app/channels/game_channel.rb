class GameChannel < ApplicationCable::Channel
  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    game = Game.find_by(slug: params[:slug])
    stream_for game # Which means 'subscribe to this stream in particular'
  end

  def unsubscribed
    stop_all_streams
  end
end
