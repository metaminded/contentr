if Object.const_defined? 'Tabulatr'
  class Contentr::MenuTabulatrData < Tabulatr::Data
    buttons do |b, r|
      b.button :pencil, contentr.edit_admin_menu_path(r.id)
      b.submenu do |s|
        s.button :times, contentr.admin_menu_path(r.id), label: I18n.t('action.delete'), method: :delete, data: { confirm: I18n.t('action.are_you_sure') }
      end
    end

    column :name
    column :sid

  end
end
