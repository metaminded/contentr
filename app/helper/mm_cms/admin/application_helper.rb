module MmCms::Admin::ApplicationHelper

  def main_menu_item(options = {:title => nil, :link => '#', :link_options => {}, :selected => false})
    content_tag(:li, :class => "#{(options[:selected] ? 'selected' : '')}") do
      link_to options[:title], options[:link], options[:link_options]
    end
  end

  def avatar_url(options = {:email => '', :size => 48})
    gravatar_id = Digest::MD5.hexdigest(options[:email])
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{options[:size]}"
  end

  def page_tree
    _page_tree(MmCms::Page.roots.asc(:position))
  end

  private

  def _page_tree(nodes)
    if (nodes.present? and nodes.length > 0)
      content_tag(:ul) do
        nodes.each do |n|
          concat(content_tag(:li, 'data-path' => n.path, 'data-id' => n.id) { link_to(n.name, '#') + _page_tree(n.children) })
        end
      end
    end
  end

end