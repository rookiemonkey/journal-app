
module Exceptions
  module JournalErrors

    # no need to define initialize and super
    # just renaming standard error to something

    class CreateError < StandardError; end
    class UpdateError < StandardError; end

  end
end