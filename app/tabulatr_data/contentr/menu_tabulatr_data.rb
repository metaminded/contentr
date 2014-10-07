class Contentr::MenuTabulatrData < Tabulatr::Data
  buttons do |b, r|
    b.button :pencil, contentr.edit_admin_menu_path(r.id)
  end

  column :name
  column :sid

end
