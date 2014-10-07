class Contentr::ContentBlockTabulatrData < Tabulatr::Data
  buttons do |b, r|
    b.button :pencil, contentr.edit_admin_content_block_path(id: r.id)
    unless r.partial.present?
      b.submenu do |s|
        s.button :list, contentr.admin_content_block_paragraphs_path(content_block_id: record.id), label: I18n.t('.contentr.content_block.paragraphs')
      end
    end
  end

  column :name
  association :usages, :count, table_column_options: {sortable: false, filter: false, header: I18n.t('.content_block.paragraphs.usages')}
end
