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
      alertModal(data['description']);
    } else {
      window.location.reload();
    }
  }
})

