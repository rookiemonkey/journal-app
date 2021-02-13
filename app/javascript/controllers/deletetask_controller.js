import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = ['task']

  connect() {
    super.connect()
  }

  delete_task() {
    this.stimulate('Task#delete', this.taskTarget.dataset.tid)
  }

}
