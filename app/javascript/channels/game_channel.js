import consumer from "./consumer"
import doGameStartUpdate from "../scripts/doGameStartUpdate"
import doNewPlayerUpdate from "../scripts/doNewPlayerUpdate"
import doQuaffUpdate from "../scripts/doQuaffUpdate"

consumer.subscriptions.create({ channel: "GameChannel", 
                                slug: window.location.pathname.split('/').filter(word => word.length > 1)[1]}, {

  received(data) {
    console.log(data)

    const playerData = document.getElementById('playerInfo').dataset
    const currentPlayerId = parseInt(playerData.playerId);

    if (data['event'] === 'new_player') {
      doNewPlayerUpdate(data);
    } else if (data['event'] === 'cup_quaffed') {
      doQuaffUpdate(data, currentPlayerId)
    } else if (data['event'] === 'game_started') {
      doGameStartUpdate(data, currentPlayerId)
    }
  }
})

