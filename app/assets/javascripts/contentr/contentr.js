Contentr = {
  area: null,
  modal: null,
  editing: false,
  current_path: null,
  content_block: null,
  modalMarkup: '<div id="contentr-edit-modal" class="modal fade" data-backdrop="static"><div class="modal-dialog"><div class="modal-content"></div></div></div>',
  //
  error_if: function(bool, msg) {
      if (bool) thow('[Contentr Error] ' + msg);
    },
  // initialize Contentr area editing
  init: function() {
      var modal = $('#contentr-edit-modal');
      if(modal.length == 0) {
        var m = $(Contentr.modalMarkup);
        $('body').append(m);
        modal = $('#contentr-edit-modal');
      }
      Contentr.modal = modal;
      var areas = $('.contentr-show.contentr-area');
      areas.each(function(i, area) {
        area = $(area);
        var name = area.data('contentrAreaName');
        var a = area.find("a.edit-area");
        var href = a.attr('href');
        var content_block = area.data('contentBlock');
        a.unbind('click');
        a.bind('click', Contentr.loadAreaEditor(name, href, content_block));
      });
      modal.on('click',  'a.add-paragraph',      Contentr.addNewParagraph);
      modal.on('click',  '.save-paragraph-btn',  Contentr.saveParagraph);
      modal.on('submit', 'form.paragraph',       Contentr.saveParagraph)
      modal.on('click',  'a.paragraph-edit-btn', Contentr.editParagraph);
      modal.on('click',  'a.contentr-remote',    Contentr.executeAndReplaceBox);
      modal.on('click',  'a.contentr-abort',     Contentr.abortEdit);
      modal.on('click',  'a#show-published-btn-all',   Contentr.showAllParagraphs);
      modal.on('click',  'a#show-unpublished-btn-all', Contentr.showAllParagraphs);
      modal.on('hidden.bs.modal', function () {
        if(!$('body').hasClass('test')){
          window.location.reload();
        }
      });
    },
  // use status flags
  startEditing: function() {
      if (Contentr.editing) {
        alert("Bitte die Bearbeitung erst abschließen.");
        return false;
      }
      Contentr.editing = true;
      return true;
    },
  endEditing: function() {
      Contentr.editing = false;
    },
  // produce callback to edit an area
  loadAreaEditor: function(name, href, content_block) {
      Contentr.content_block = content_block;
      Contentr.current_path = href;
      return function(event) {
        event.preventDefault();
        $.ajax(href, {
          data: {
            content_block_id: Contentr.content_block
          },
          success: function(data) {
            Contentr.modal.find('.modal-content').html(data);
            Contentr.modal.modal();
            Contentr.initAreaEditor();
          }
        });
        return false;
      }
    },
  initAreaEditor: function() {
      Contentr.editing = false;
      Contentr.modal.find(".existing-paragraphs").sortable({
        itemSelector: ".paragraph-box",
        containerSelector: 'div.existing-paragraphs',
        handle: '.handle',
        onDrop: Contentr.resortParagraphs
      });
    },
  // post the new order to the server
  resortParagraphs: function ($item, container, _super, event) {
      if(!Contentr.startEditing()) return false;
      var list = $($item.parents('.existing-paragraphs').first());
      var url = list.data('reorderPath');
      var ids = list.children().map(function(){
        return $(this).data('paragraphId');
      }).toArray().join(',');

      $.ajax({
        type: "PATCH",
        url: url,
        data: {
          paragraph_ids: ids,
          content_block_id: Contentr.content_block
        },
        error: function(msg) {
          alert("Error: Please try again.");
          Contentr.endEditing();
        },
        success: Contentr.endEditing
      });
      _super($item);
    },
  // add a new paragraph
  addNewParagraph: function() {
      if(!Contentr.startEditing()) return false;
      var m = Contentr.modal;
      var option = m.find('select#choose-paragraph-type option:selected');
      $.get(option.data('path'), function(data) {
        m.find('.existing-paragraphs').append(data);
      });
    },
  // saves a previously edited or newly created paragraph
  saveParagraph: function() {
      var form = $($(this).parents('form').first());
      var data = form.serializeArray();
      data.push({name: 'content_block_id', value: Contentr.content_block});
      $.ajax(form.attr('action'), {
        type: form.attr('method'),
        data: data,
        success: function(data) {
          form.replaceWith(data);
          Contentr.endEditing();
        },
        error: function(data) {
          Contentr.endEditing();
        }
      });
      form.find('.panel-body').html('<i class="fa fa-spinner fa-spin"></i>');
      return false;
    },
  // edit a paragraph
  editParagraph: function() {
      if(!Contentr.startEditing()) return false;
      var a = $(this);
      var box = a.parents('.paragraph-box');
      var url = a.attr('href');
      $.ajax(url, {
        data: { content_block_id: Contentr.content_block },
        success: function(data){box.replaceWith(data);}
      });
      return false;
    },
  executeAndReplaceBox: function() {
      var a = $(this);
      var href = a.attr('href');
      var panel = $(a.parents('.panel').first());
      var target = null;
      if (a.data('target')) {
        target = panel.find(a.data('target'));
      }
      var method = a.data('method') || 'get';
      var cnf = a.data('confirm');
      if(cnf && !confirm(cnf)) { return; }
      if (href == '#') {
        if (target) {
          target.html('');
        } else {
          panel.remove();
        }
        Contentr.endEditing();
        return false;
      }
      if(!Contentr.startEditing()) return false;
      $.ajax(href, {
        data: {
          _method: method,
          content_block_id: Contentr.content_block
        },
        type: method,
        success: function(data) {
          if (target) {
            target.html(data);
          } else {
            panel.replaceWith(data);
          }
          Contentr.endEditing();
        }
      });
      return false;
    },
  abortEdit: function() {
      var a = $(this);
      var href = a.attr('href');
      var form = $(a.parents('form').first());
      var method = a.data('method') || 'get';
      var cnf = a.data('confirm');
      if(cnf && !confirm(cnf)) { return; }
      if (href == '#') {
        form.remove();
        Contentr.endEditing();
        return false;
      }
      $.ajax(href, {
        data: {
          _method: method,
          content_block_id: Contentr.content_block
        },
        type: method,
        success: function(data) {
          form.replaceWith(data);
          Contentr.endEditing();
        }
      });
      return false;
    },
  showAllParagraphs: function() {
      if(!Contentr.startEditing()) return false;
      var a = $(this);
      var href = a.attr('href');
      var form = $(a.parents('form').first());
      $.get(href, function(data){
        $.each(data, function(id, content){
          $('.panel-body[data-paragraph-id="'+id+'"]').html(content)
        });
        Contentr.endEditing();
      });
      return false;
    }
}
