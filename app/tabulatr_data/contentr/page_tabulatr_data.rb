if Object.const_defined? 'Tabulatr'
  class Contentr::PageTabulatrData < Tabulatr::Data
    search :name

    buttons do |b, r|
      b.button :tv, r.preview_path if r.respond_to?(:preview_path)
      b.button :pencil, contentr.edit_admin_page_path(id: r.id)
      b.submenu do |s|
        if r.published?
          s.button :'eye-slash', contentr.admin_page_path(id: r, 'page[published]' => '0'),
            data: {method: :patch}, label: 'Seite verbergen'
        else
          s.button :'eye', contentr.admin_page_path(id: r, 'page[published]' => '1'),
            data: {method: :patch}, label: 'Seite anzeigen/veröffentlichen'
        end
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
end
