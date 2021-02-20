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
      arr = err.attribute.to_s.upcase.split('_')

      field = ''
      arr.each do |phrase|
        
        if field == ''
          field = phrase
          next
        end

        field << " #{phrase}"
      end

      hash[field] = err.message
    end

    hash
  end

  def task_label(task)
    status = :''
    message = :''

    deadline = Time.new(task.deadline.year, task.deadline.month, task.deadline.day)

    (status = :'success' and message = :'Completed') if task.completed
    (status = :'danger' and message = :'Overdue!') if deadline.past? and !task.completed
    (status = :'light' and message = :'Pending') if deadline.future? and !task.completed
    (status = :'warning' and message = :'Due Today!') if deadline.today? and !task.completed

    html = <<-HTML
      <span class="tile-status py-1 px-2 completed-#{status}">
        <span class="has-text-#{status}">#{message}</span>
      </span>
    HTML

    { html: html, message: message, status: status }
  end

end
