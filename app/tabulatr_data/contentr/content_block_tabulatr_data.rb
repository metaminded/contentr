class Contentr::ContentBlockTabulatrData < Tabulatr::Data
  buttons do |b, r|
    b.button :pencil, contentr.edit_admin_content_block_path(id: r.id)
    if r.usages.none?
      b.button :times, contentr.admin_content_block_path(r.id), label: I18n.t('action.delete'), method: :delete, data: { confirm: I18n.t('action.are_you_sure')}
    end
    unless r.partial.present?
      b.submenu do |s|
        s.button :list, contentr.admin_area_paragraphs_path(record.class.name, record.id, 'main'), label: I18n.t('.contentr.content_block.paragraphs')
      end
    end
  end

  column :name
  association :usages, :count, table_column_options: {sortable: false, filter: false, header: I18n.t('.content_block.paragraphs.usages')}
end
