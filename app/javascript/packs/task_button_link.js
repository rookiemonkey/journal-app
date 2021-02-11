
const buttons = [...document.querySelectorAll('.to_clipboard_task')]

for (let button of buttons) {

  button.onclick = () => {
    const { host, protocol } = window.location

    navigator.clipboard.writeText(`${protocol}//${host}${button.dataset.url}`)

    toastr.success('Copied to clipboard', 'Hooray!', {
      closeButton: true,
      progressBar: true,
      positionClass: 'toast-top-center'
    })
  }

}