class Contentr::MenuTabulatrData < Tabulatr::Data
  buttons do |b, r|
    b.button :pencil, contentr.edit_admin_menu_path(r.id)
  end

  column :name
  column :sid

  column :context_tags, table_column_options: { filter: false, sortable: false } do |m|
    m.context_tags.map(&:name).join(' & ')
  end
end
