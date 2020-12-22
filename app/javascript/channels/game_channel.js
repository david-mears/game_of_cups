import consumer from "./consumer"

import doGameStartUpdate from "../scripts/doGameStartUpdate"
import doNewPlayerUpdate from "../scripts/doNewPlayerUpdate"
import doQuaffUpdate from "../scripts/doQuaffUpdate"
import alertModal from "../scripts/alertModal"


// This file is only run on page loads triggered by page refreshes or directly entering a url in the url address bar
// and it is not run when a user navigates between pages.

// As a result, navigating to a game by typing things into forms and clicking buttons will not run
// this file, and a player will not be subscribed to the channel for their game.

// Therefore, somewhat like the strategy used in the below link, let's wrap up the call to 'create'
// and make sure it's run every time turbolinks reloads. (Turbolinks loading appears to the user like a
// page loading, but under the hood it's just replacing the page content and window location - but
// does not trigger a function attached to page onload.)

// https://philippe.bourgau.net/how-to-subscribe-to-an-actioncable-channel-on-a-specific-page-with-custom-data/

const unsubscribeAndResubscribe = () => {
  // Unsubscribe players from all games, in case the current subscription is for a different
  // game (one they've left). This prevents the problem of being subscribed to two games at once.

  consumer.subscriptions.subscriptions.forEach(subscription => {
    subscription.unsubscribe();
  });

  consumer.subscriptions.create({ channel: "GameChannel", 
                                  slug: window.location.pathname.split('/').filter(word => word.length > 1)[1]}, {

    received(data) {
      const playerData = document.getElementById('playerInfo').dataset
      const currentPlayerId = parseInt(playerData.playerId);

      if (data['event'] === 'new_player') {
        doNewPlayerUpdate(data);
      } else if (data['event'] === 'cup_quaffed') {
        doQuaffUpdate(data, currentPlayerId)
      } else if (data['event'] === 'game_started') {
        doGameStartUpdate(data, currentPlayerId)
      } else if (data['event'] === 'heartbeat') {
        lastSeenHeartbeatNumber = data['number']
      }
    }
  })
}

window.addEventListener('turbolinks:load', function() {
  unsubscribeAndResubscribe()
  numberOfUnsuccessfulPings = 0;
})

// Periodically find out if connection has dropped.

window.setInterval(ping, 1000);

function ping() {
  const slug = window.location.pathname.split('/').filter(word => word.length > 1)[1]

  if (slug === "" || slug === "new" || slug === undefined) {
    return false;
  } else {
    let thisPingsHeartbeatNumber = lastSeenHeartbeatNumber;

    if (thisPingsHeartbeatNumber === previousPingsHeartbeatNumber) {
      numberOfUnsuccessfulPings++
    }

    if (numberOfUnsuccessfulPings > 1 && document.getElementsByClassName('badConnection').length === 0) {
      alertModal(`<p class="badConnection">Thine internet is ill connected</p>
      <p>
        <a href="${window.location}">
          <button>Reload!</button>
        </a>
      </p> `, false)
    }

    previousPingsHeartbeatNumber = thisPingsHeartbeatNumber;
  }
}

let lastSeenHeartbeatNumber;
let previousPingsHeartbeatNumber;
let numberOfUnsuccessfulPings;