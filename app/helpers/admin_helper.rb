module AdminHelper
  def link_to_edit(url, html_options = {})
    html_options.reverse_merge!(class: "button-green edit")
    link_to url, html_options do
      icon 'edit', t('edit_button')
    end
  end

  def link_to_destroy(url, html_options = {})
    html_options.reverse_merge!(confirm: 'Tem certeza?', method: :delete, class: "button-red delete")
    link_to url, html_options do
      icon 'times', t('delete_button')
    end
  end
end
