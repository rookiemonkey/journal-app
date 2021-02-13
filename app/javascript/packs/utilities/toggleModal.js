
export default function toggleModal(resource, id, toOpen) {

  const modal = document.querySelector(`[data-${resource}modal-id="${id}"]`)

  if (toOpen) modal.classList.add('is-active')

  if (!toOpen) modal.classList.remove('is-active')

}