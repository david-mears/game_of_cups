import alertModal from "./alertModal";

const allegianceMessage = (playerId, data) => {
  const totalNumberOfEvilKnights = data['evil_player_ids'].length

  if (data['evil_player_ids'].includes(playerId)) {
    let otherEvilPlayerNames = [];
    let playerIndex;
    let i;
    for (i = 0; i < data['evil_player_ids'].length; i++) {
      otherEvilPlayerNames.push(data['evil_player_names'][i]);
      if (data['evil_player_ids'][i] === playerId) {
        playerIndex = i
      };
    };
    otherEvilPlayerNames.splice(playerIndex, 1);
    const listOfTheOtherEvilPlayers = [
      otherEvilPlayerNames.slice(0, (otherEvilPlayerNames.length - 1)).join(', '),
      otherEvilPlayerNames[otherEvilPlayerNames.length - 1]
    ].join(' & ')

    const task = `Corrupt Arthur to your side, then have him drink of the Holy Grail.`
    return (otherEvilPlayerNames.length === 0) ?
      `You are the only <span class="newthought">evil</span> player (for now). ${task}`
      :
      `You are <span class="newthought">evil</span> (for now), along with ${listOfTheOtherEvilPlayers}. ${task}`
  } else if (data['arthur_id'] === playerId) {
    return `You are <span class="newthought">good</span> (for now).
            Worm out the ${totalNumberOfEvilKnights} evil knight${(totalNumberOfEvilKnights > 1) ? `s` : ``}
            and drink from the Holy Grail to gain from its power. Whom to trust?`;
  } {
    return `You are <span class="newthought">good</span> (for now).
            Worm out the ${totalNumberOfEvilKnights} evil knight${(totalNumberOfEvilKnights > 1) ? `s` : ``}
            and learn which cup is the Holy Grail, before Arthur is corrupted.`;
  }
};

const doGameStartUpdate = (data, currentPlayerId) => {
  const arthurMessage = (data['arthur_id'] === currentPlayerId) ?
    `You are <span class="newthought">King Arthur</span>.`
    :
    `Arthur is <span class="newthought">${data['arthur_name']}</span>`

  alertModal(`<p>The game is begun!</p>
                          <p>${arthurMessage}</p>
                          <p>${allegianceMessage(currentPlayerId, data)}</p>
                          <p>
                            <a href="${window.location}">
                              <button>Forth!</button>
                            </a>
                          </p> `, false);
}

export default doGameStartUpdate
