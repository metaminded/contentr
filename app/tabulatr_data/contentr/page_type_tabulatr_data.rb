class Contentr::PageTypeTabulatrData < Tabulatr::Data
  search :name
  # column :edit, table_column_options: {header: '', sortable: false,  filter: false, width: '30px'} do |rec|
  #  "#" # edit_link edit_backend_tariff_path(rec)
  # end
  # column :destroy, table_column_options: {header: '', sortable: false,  filter: false, width: '30px', classes: 'hidden-phone hidden-tablet'} do |rec|
  #   link_to "<div class='btn btn-danger'><i class='fa fa-trash-o'></i></div>".html_safe, "", method: :delete, id: rec.id, data: {delete: true, name: "der Tarif '#{rec.title}'"}
  # end
  column :name
end
