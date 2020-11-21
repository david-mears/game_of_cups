window.addEventListener('load', function() {
  const mainPage = document.getElementsByTagName('article')[0];
  const modalsCollection = document.getElementById('modalCollection');
  let indexOfNewModal = 0;

  document.getElementById('addModalButton').addEventListener('click', () => {
    mainPage.classList.remove('unBackgrounded');
    mainPage.classList.add('backgrounded');

    const preExistingModals = document.getElementsByClassName('modal');
    let i;
    for (i = 0; i < preExistingModals.length; i++) {
      preExistingModals[i].classList.remove('slideIn');
    };

    indexOfNewModal += 1;
    const newModal = `<div class="modal slideIn" id="modal${indexOfNewModal}" style="z-index: ${indexOfNewModal};">
                        <button class="closeModalButton" id="closeModal${indexOfNewModal}Button">✖</button>
                        <p>I am the ${indexOfNewModal}th notification box you see</p>
                      </div>`
    modalsCollection.insertAdjacentHTML('afterbegin', newModal)

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
  })
})
