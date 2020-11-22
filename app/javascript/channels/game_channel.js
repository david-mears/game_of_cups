import consumer from "./consumer"
import alertModal from "../scripts/alertModal"

consumer.subscriptions.create({ channel: "GameChannel", 
                                slug: window.location.pathname.split('/').filter(word => word.length > 1)[1]}, {
  received(data) {
    if (data['event'] === 'new_player') {
      const players = document.getElementsByClassName('player');

      let i;
      for (i = 0; i < players.length; i++) {
        const playerNameElement = document.getElementById(`playerName${i}`);
        if (playerNameElement.innerText === '') {
          playerNameElement.innerHTML = data['name'];
          break;
        };
      };

      if (data['quorate'] === true) {
        const button = document.getElementById('startButton');
        button.disabled = false;
        button.value = 'Start the game already!'
      };

    } else if (data['event'] === 'cup_quaffed') {
      const playerData = document.getElementById("playerInfo").dataset;
      const currentPlayerId = playerData.playerId;

      if (data['quaffer'] !== parseInt(currentPlayerId)) {
        alertModal(data['description']);
      };
      if (data['status'] === 'finished') {
        const arthurAllegiance = data['arthur_allegiance']
        const playerIsVictorious = data['victorious_knights'].includes(currentPlayerId)
        const playerIsArthur = (data['arthur'] === parseInt(currentPlayerId))

        const gameOverHeading = `<h1 style="margin-top: 0">The End</h1>`
        const gameOverMessage = playerIsVictorious ? `You were victorious!` : `You lost!`
        const gameOverDetails = !playerIsArthur ?
          `<p class="center">Arthur drank from the Holy Grail, sealing your fate. Arthur's allegiance is to the forces of <span class="newthought">${arthurAllegiance}</span>.</p>
           <p class="center">${gameOverMessage}</p>`
        :
          `<p class="center">You drank from the Holy Grail. Your allegiance is to the forces of <span class="newthought">${arthurAllegiance}</span>.</p>
           <p class="center">The ${arthurAllegiance} side were victorious.</p>`
        document.getElementById('endGame').innerHTML = (gameOverHeading + gameOverDetails)
      }

    } else {
      window.location.reload();
    }
  }
})

