class Contentr::PageTabulatrData < Tabulatr::Data
  buttons do |b, r|
    b.button :eye, r.preview_path if r.respond_to?(:preview_path)
    b.button :pencil, contentr.edit_admin_page_path(id: r.id)
    b.submenu do |s|
      s.button :times, contentr.admin_page_path(r.id), label: I18n.t('action.delete'), method: :delete, data: { confirm: I18n.t('action.are_you_sure')}
    end
  end

  actions do
    if record.is_a? Contentr::LinkedPage
      fa_icon :link
    else
      fa_icon :'file-code-o'
    end
  end

  column :name

  column :context_tags, table_column_options: { filter: false, sortable: false } do |p|
    p.context_tags.distinct.map(&:name).join(' & ')
  end
end
