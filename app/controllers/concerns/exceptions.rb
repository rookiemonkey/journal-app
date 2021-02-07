
module Exceptions
  module JournalErrors

    # no need to define initialize and super
    # just renaming standard error to something

    class CreateJournalError < StandardError; end
    class UpdateJournalError < StandardError; end

  end
end