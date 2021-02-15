import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = ['category']

  connect() {
    super.connect()
  }

  reflexSuccess(element, reflex, noop, reflexId) {
    this.flash('Hooray!', `Successfully deleted a category!`, 'success')
  }

  delete_category() {
    this.stimulate('Category#delete', this.categoryTarget.dataset.id)
  }

}
