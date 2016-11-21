module SearchHelper

  def highlight(hit, stored)
    if hit.highlight(stored) 
      hit.highlight(stored).format { |word| "<span class='highlight'>#{word}</span>" }.html_safe 
    else
      nil
    end
  end
end
