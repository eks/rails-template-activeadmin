module ApplicationHelper
  def error_messages_for(resource)
    render 'shared/error_messages', resource: resource
  end

  def flash_messages
    flash.collect do |key, msg|
      content_tag(:p, msg, id: key, class: "flash-message")
    end.join.html_safe
  end
  
  def analytics(site_id, site_url)
    html = <<-ANALYTICS
    <script>
      (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
      m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
      })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

      ga('create', '#{site_id}', '#{site_url}');
      ga('send', 'pageview');
    </script>
    ANALYTICS
    html.html_safe
  end

  def dispatcher_route
    controller_name = controller_path.gsub(/\//, "_")
    "#{controller_name}##{action_name}"
  end

  def translate_attribute(model, attribute)
    model.human_attribute_name(attribute)
  end
  alias_method :ta, :translate_attribute
end
