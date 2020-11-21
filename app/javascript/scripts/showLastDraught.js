const alertModal = (message) => {
  const mainPage = document.getElementsByTagName('article')[0];
  mainPage.classList.remove('unBackgrounded');
  mainPage.classList.add('backgrounded');

  const preExistingModals = document.getElementsByClassName('modal');
  let i;
  for (i = 0; i < preExistingModals.length; i++) {
    preExistingModals[i].classList.remove('slideIn');
  };

  indexOfNewModal = Date.now();
  const newModal = `<div class="modal slideIn" id="modal${indexOfNewModal}" style="z-index: ${indexOfNewModal};">
                      <button class="closeModalButton" id="closeModal${indexOfNewModal}Button">✖</button>
                      <p>${message}</p>
                    </div>`
  document.getElementById('modalCollection').insertAdjacentHTML('afterbegin', newModal)

  document.getElementById(`closeModal${indexOfNewModal}Button`).addEventListener('click', (e) => {
    buttonId = e.target.id
    indexOfModalToClose = buttonId.match(/\d+/)[0]
    const modalToClose = document.getElementById(`modal${indexOfModalToClose}`)
    modalToClose.classList.remove('slideIn')
    modalToClose.classList.add('slideOut')
    if (document.getElementsByClassName('modal').length === document.getElementsByClassName('slideOut').length) {
      mainPage.classList.remove('backgrounded');
      mainPage.classList.add('unBackgrounded');
    };
  });
};

window.addEventListener('load', function() {
  const lastDraught = window.localStorage.getItem('last_draught')
  if (lastDraught != null) {
    alertModal(lastDraught)
  }
  window.localStorage.clear()
})
