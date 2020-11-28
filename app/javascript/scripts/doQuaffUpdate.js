import alertModal from "./alertModal";
import doGameIsOverUpdate from "./doGameIsOverUpdate";

const doQuaffUpdate = (data, currentPlayerId) => {
  const originalPlayerAllegiance = document.getElementById('allegiance').innerText.toLowerCase()
  const playerAllegiance = (data['evil_player_ids'].includes(currentPlayerId)) ? 'evil' : 'good'
  const notPlayerAllegiance = (data['evil_player_ids'].includes(currentPlayerId)) ? 'good' : 'evil'
  const allegianceChanged = (originalPlayerAllegiance !== playerAllegiance)

  const body = document.getElementsByTagName('body')[0];
  body.classList.remove(notPlayerAllegiance);
  body.classList.add(playerAllegiance);

  document.getElementById('allegiance').innerText = playerAllegiance;

  const gameIsOver = (data['status'] === 'finished');

  if (gameIsOver) {
    doGameIsOverUpdate(data, currentPlayerId)
  };

  const playerIsQuaffer = (data['quaffer_id'] === currentPlayerId)
  const newDraught = `${playerIsQuaffer ? 'You' : data['quaffer_name']}
                      drank
                      ${playerIsQuaffer ? data['cup_name'] : `cup ${data['cup_label']}`}
                      ${(allegianceChanged && playerIsQuaffer) ?
                        `and turned <span class="newthought">${playerAllegiance}</span>`
                      :
                        ``
                      }`
  alertModal(`<p>
            ${data['image']}
            <br/>
            ${newDraught}
          </p>
          ${gameIsOver ? '<p>Game over!</p>' : ''}  
        `);

  const draughtsLog = document.getElementById('draughts');
  draughtsLog.innerHTML += (newDraught + '</br>')
  draughtsLog.scrollTop = draughtsLog.scrollHeight // Scroll to newest entry

  if (playerIsQuaffer) {
    document.getElementById(`cup_${data['cup_label']}_label`).innerHTML = `<i>
            ${data['cup_label']} - ${data['cup_name']}
          </i>`
  }
}

export default doQuaffUpdate;