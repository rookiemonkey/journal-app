import toggleModal from './utilities/toggleModal';

const deleteButtons = [...document.querySelectorAll('[data-categorydelete-btn]')]
const closeButtons = [...document.querySelectorAll('.modal-close')]
const cancelButtons = [...document.querySelectorAll('.modal-cancel')]

// opening the modal
for (const button of deleteButtons) {
  button.onclick = () => toggleModal('category', button.dataset.categorydeleteBtn, true)
}

// closing the modal using x button
for (const button of closeButtons) {
  button.onclick = () => toggleModal('category', button.dataset.categoryclosemodalId, false)
}

// closing the modal using cancel button
for (const button of cancelButtons) {
  button.onclick = () => toggleModal('category', button.dataset.categorycancelmodalId, false)
}