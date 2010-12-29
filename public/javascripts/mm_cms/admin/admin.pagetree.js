(function($) {
  
  MMCMS.pageTree = (function () {
    /*var privateVariable;
    
    function privateFunction(x) {
      
    }*/
    
    var that;
    
    return {
      init: function () {
        that = this;
        
        that.loadNavigation();
        
        // handle navigation
        $('#page-tree a.page').live('click', function (e) {
          var page_id = $(this).attr('data-id');
          var has_children = $(this).attr('data-children');
          
          if (page_id) {
            if (has_children) {
              that.loadNavigation(page_id);
              that.loadPage(page_id);
            } else {
              that.loadPage(page_id);
            }
          }
        });
        
        // handle back navigation
        $('#page-tree a.page-back').live('click', function (e) {
          var parent_id = $(this).attr('data-id');
          that.loadNavigation(parent_id);
        });
      },
      
      loadNavigation: function (parent_id) {
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
            //var first_page_id = $('#page-tree a.page:first').attr('data-id');
            //that.loadPage(first_page_id);
          }
        });
      },
      
      loadPage: function (page_id) {
        $.ajax({
          async: true,
          type: 'get',
          url: './pages/' + page_id,
          data: {
          },
          success: function (r) {
            $('#page-content').html(r);
          }
        });
      }
    }
  }());
  
    
  $(function() {
    
    MMCMS.pageTree.init();
 
  });
  
})(jQuery)