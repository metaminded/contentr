(function($) {
  
  MMCMS.pageTree = (function () {
    var that;
    var privateVariable;
    
    function privateFunction(x) {
      
    }
    
    return {
      init: function () {
        that = this;
        
        that.load();
        
        $('#page-tree a.page').live('click', function (e) {
          var parent_id = $(this).attr('data-id');
          if (parent_id !== undefined) {
            that.load(parent_id);
          }
        })
      },
      
      load: function (parent_id) {
        $.ajax({
          async: true,
          type: 'get',
          url: './pages/navigation',
          data: {
            'parent_id': parent_id
          },
          success: function (r) {
            $('#page-tree').html(r);
          }
        });
      }
    }
  }());
  
    
  $(function() {
    
    MMCMS.pageTree.init();
 
  });
  
})(jQuery)