class Contentr::PageTabulatrData < Tabulatr::Data
  buttons do |b, r|
    b.button :eye, r.preview_path if r.respond_to?(:preview_path)
    b.button :pencil, contentr.edit_admin_page_path(id: r.id)
    b.submenu do |s|
      s.button :times, contentr.admin_page_path(r.id), label: I18n.t('action.delete'), method: :delete, data: { confirm: I18n.t('action.are_you_sure')}
    end
  end

  actions do
    if record.visible?
      fa_icon :eye
    else
      fa_icon :'eye-slash'
    end
  end

  column :name
end
