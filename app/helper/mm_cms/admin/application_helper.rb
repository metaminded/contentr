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

end