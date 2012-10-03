module ApplicationHelper
  def flash_message
    content = ''

    %w(notice warning error).each do |type|
      if flash[type.intern]
        content += content_tag(:div, :class => 'alert alert-block') do
          link_to('x', '#', :class => 'close', :'data-dismiss' => 'alert') +
          content_tag(:h4, "#{type.titleize}!", :class => 'alert-heading') +
          flash[type.intern]
        end
      end
    end

    content.html_safe
  end
end
