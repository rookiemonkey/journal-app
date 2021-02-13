const deleteButtons = [...document.querySelectorAll('[data-taskdelete-btn]')]
const closeButtons = [...document.querySelectorAll('.modal-close')]
const cancelButtons = [...document.querySelectorAll('.modal-cancel')]

function toggleModal(id, toOpen) {
  const modal = document.querySelector(`[data-taskmodal-id="${id}"]`)
  if (toOpen) modal.classList.add('is-active')
  if (!toOpen) modal.classList.remove('is-active')
}

// opening the modal
for (const button of deleteButtons) {
  button.onclick = () => toggleModal(button.dataset.taskdeleteBtn, true)
}

// closing the modal using x button
for (const button of closeButtons) {
  button.onclick = () => toggleModal(button.dataset.taskclosemodalId, false)
}

// closing the modal using cancel button
for (const button of cancelButtons) {
  button.onclick = () => toggleModal(button.dataset.taskcancelmodalId, false)
}