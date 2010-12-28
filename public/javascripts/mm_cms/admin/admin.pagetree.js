(function($) {
  
  $(function() {
    // page tree menu
    $('.page-tree').jstree({ 
    	'plugins': [ 'html_data', 'themes', 'dnd', 'ui' ],
    	'themes': {
    	  'theme': 'mmcms',
    	  'url': '/stylesheets/mm_cms/admin/pagetree.css',
    	  'dots': false
    	}
    }).bind('move_node.jstree', function (e, data) {
      data.rslt.o.each(function (i) {
        var page_id    = $(this).attr('data-id');
        var parent_id  = data.rslt.np.attr('data-id');
        var sibling_id = data.rslt.or.attr('data-id');
        
        var page_path    = $(this).attr('data-path');
        var parent_path  = data.rslt.np.attr('data-path');
        var sibling_path = data.rslt.or.attr('data-path');
        
        $.ajax({
          async: false,
          type: 'put',
          url: './pages/' + page_id + '/reorder.json',
          data: {
            'parent_id': parent_id,
            'sibling_id': sibling_id
          },
          success: function (r) {
            //alert('Yo!');
          }
        });
  	  });
  	}).bind('select_node.jstree', function (e, data) {
      var page_id = data.rslt.obj.attr('data-id');
      
      if (page_id) {
        $.ajax({
          async: true,
          type: 'get',
          url: './pages/' + page_id,
          success: function (r) {
            $('#page-content').html(r)
          }
        })
      }
  	});
  });
  
})(jQuery)