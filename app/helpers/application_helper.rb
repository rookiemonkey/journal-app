module ApplicationHelper

  def date_full_words(date_object)
      date_object.strftime("%A, %d %b %Y")
  end

  def toastr_flash
    flash.each_with_object([]) do |(type, message), flash_messages|
      
      type = 'success' if type == 'notice'
      type = 'error' if type == 'alert'
      title = 'Hooray!' if type == 'notice'
      title = 'Oh snap!' if type == 'alert'

      text = "<script>
        toastr.#{type}(\"#{message}\", '#{title}', { 
            closeButton: true, 
            progressBar: true,
            positionClass: 'toast-top-center'
          })
      </script>".squish

      flash_messages << text.html_safe if message
      flash_messages.join("\n")

    end
  end

  def parse_errors(errors)
    hash = Hash.new

    errors.each do |err|
      hash[err.attribute.to_s.upcase] = err.message
    end

    hash
  end

  def task_label(is_completed)
    return '<span class="has-text-success-dark">Completed</span>' if is_completed
    return '<span class="has-text-warning-dark">Pending</span>' unless is_completed
  end

end
