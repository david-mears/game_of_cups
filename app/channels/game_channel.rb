class GameChannel < ApplicationCable::Channel
  # Called when the consumer has successfully
  # become a subscriber to this channel.
  def subscribed
    stream_from "games"
    # stream_from "game_#{params[:game_id]}"
    # or:
    # game = Game.find(params[:game_id])
    # stream_for game
    # TODO: find out what a 'room' is and whether I should use one to distinguish
    # streams of info about different games.
    # https://guides.rubyonrails.org/action_cable_overview.html#subscriber
    # https://guides.rubyonrails.org/action_cable_overview.html#streams
    # https://guides.rubyonrails.org/action_cable_overview.html#passing-parameters-to-channels
    #
    # HackerNoon: 'This becomes apparent when you involve the Channel’s stream_frommethod. Where the first argument is the string that will match what a later broadcast will publish too. Also, Rails and ActionCable come with a better helper method stream_forif you are working directly with model and objects. This will handle serialization of object ids.'
  end
end
