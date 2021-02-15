import ApplicationController from './application_controller'

export default class extends ApplicationController {
  static targets = ['task']

  connect() {
    super.connect()
  }

  reflexSuccess(element, reflex, noop, reflexId) {
    this.flash('Hooray!', `Successfully toggled a task's completed status!`, 'success')
  }

  complete_task() {
    this.stimulate('Task#complete', this.taskTarget.dataset.tid)
  }

}
