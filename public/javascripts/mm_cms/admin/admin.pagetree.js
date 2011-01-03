(function($) {
  
  MMCMS.pageTree = (function () {
    /*var privateVariable;
    
    function privateFunction(x) {
      
    }*/
    
    var current_page_id = null;
    
    var that = {
      init: function () {
        that.loadNavigation();
      },
      
      loadNavigation: function (parent_id, is_back_nav) {
        $.ajax({
          async: true,
          type: 'get',
          url: './pages/navigation',
          data: {
            'parent_id': parent_id
          },
          success: function (r) {
            $('#page-tree').html(r);
            // Load the first page in the list
            var first_page_id = $('#page-tree a.page:first').attr('data-id');
            that.loadPage(first_page_id);
          }
        });
      },
      
      loadPage: function (page_id) {
        $.ajax({
          async: true,
          type: 'get',
          url: './pages/' + page_id + '/edit',
          data: {
          },
          success: function (r) {
            // show the current page
            $('#page-content').html(r);
            // after the page has been loaded remember the
            // 'current page id' for later reference
            current_page_id = $('#page-content #page').attr('data-id');
            // fire current page changed event
            $('#page-tree').trigger('page-changed.pagetree', current_page_id);
          }
        });
      },
      
      selectPage: function (page_id) {
        $('#page-tree li').removeClass('selected');
        var page = $('#page-tree a.page[data-id='+page_id+']');
        if (page) {
          $(page).closest('li').addClass('selected').append('<div class="marker"></div>');
        }
      },
      
      updatePage: function () {
        
      }
    }
    
    // handle navigation
    $('#page-tree a.page').live('click', function (e) {
      e.preventDefault();
      
      var page_id = $(this).attr('data-id');
      var has_children = $(this).attr('data-children');
      
      if (page_id) {
        if (has_children) {
          that.loadNavigation(page_id);
        } else {
          that.loadPage(page_id);
        }
      }
    });
    
    // handle back navigation
    $('#page-tree a.backlink').live('click', function (e) {
      e.preventDefault();
      
      var parent_id = $(this).attr('data-id');
      that.loadNavigation(parent_id, true);
    });
    
    // handle 'current page changed' event
    $('#page-tree').live('page-changed.pagetree', function (e, current_page_id) {
      that.selectPage(current_page_id);
    });
    
    // handle page editor submit
    $('#page-content .page-editor').live('submit', function (e) {
      e.preventDefault();
      $(this).ajaxSubmit({
        success: function (r) {
          $('#page-content').html(r);
        }
      }); 
    });
    
    // handle template change
    $('#page-content .page-editor #page_template').live('change', function (e) {
      e.preventDefault();
      var template = $(this).val();
      
      var r = confirm('Are you sure?');
      if (r) {
        $.ajax({
          async: true,
          type: 'put',
          url: './pages/' + current_page_id + '/set_template',
          data: {
            'template': template
          },
          success: function (r) {
            that.loadPage(current_page_id);
          }
        });
      }
    });
    
    // finally return
    return that;
  }());
  
  // On DOM ready, load the page tree navigation
  $(function() {
    MMCMS.pageTree.init();
  });
  
})(jQuery)