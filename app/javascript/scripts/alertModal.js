const closeModal = (index, mainPage) => {
  const modalToClose = document.getElementById(`modal${index}`);
  modalToClose.classList.remove('slideIn');
  modalToClose.classList.add('slideOut');
  if (document.getElementsByClassName('modal').length === document.getElementsByClassName('slideOut').length) {
    mainPage.classList.remove('backgrounded');
    mainPage.classList.add('unBackgrounded');
  };
}

const alertModal = (message, withCloseButton = true) => {
  const mainPage = document.getElementsByTagName('article')[0];
  mainPage.classList.remove('unBackgrounded');
  mainPage.classList.add('backgrounded');

  const preExistingModals = document.getElementsByClassName('modal');
  let i;
  for (i = 0; i < preExistingModals.length; i++) {
    preExistingModals[i].classList.remove('slideIn');
  };

  const indexOfNewModal = Date.now();
  const button = withCloseButton ? `<button class="closeModalButton" id="closeModal${indexOfNewModal}Button">✖</button>` : ``
  const newModal = `<div class="modal slideIn" id="modal${indexOfNewModal}" style="z-index: ${indexOfNewModal};">
                      ${button}
                      ${message}
                    </div>`
  document.getElementById('modalCollection').insertAdjacentHTML('afterbegin', newModal)

  document.getElementById(`closeModal${indexOfNewModal}Button`).addEventListener('click', (e) => {
    const buttonId = e.target.id;
    closeModal(buttonId.match(/\d+/)[0], mainPage);
  });
};

export default alertModal