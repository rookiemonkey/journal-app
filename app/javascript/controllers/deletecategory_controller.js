import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = ['category']

  connect() {
    super.connect()
  }

  delete_category() {
    this.stimulate('Category#delete', this.categoryTarget.dataset.id)
  }

}
