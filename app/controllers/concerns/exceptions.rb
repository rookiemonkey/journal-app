
module Exceptions
  module JournalErrors

    # no need to define initialize and super
    # just renaming standard error to something

    class NotFoundJournalError < StandardError; end
    class CreateJournalTaskError < StandardError; end
    class CreateJournalError < StandardError; end
    class UpdateJournalError < StandardError; end
    class CreateTaskError < StandardError; end
    class UpdateTaskError < StandardError; end

  end
end