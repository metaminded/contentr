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
    }).bind("move_node.jstree", function (e, data) {
      data.rslt.o.each(function (i) {
        var page_id    = $(this).attr('data-id');
        var parent_id  = data.rslt.np.attr('data-id');
        var sibling_id = data.rslt.or.attr('data-id');
        //var position  = data.rslt.cp + i;
        
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
        
  		  /*$.ajax({
  		  	async : false,
  		  	type: 'POST',
  		  	url: "./server.php",
  		  	data : { 
  		  		"operation" : "move_node", 
  		  		"id" : $(this).attr("id").replace("node_",""), 
  		  		"ref" : data.rslt.np.attr("id").replace("node_",""), 
  		  		"position" : data.rslt.cp + i,
  		  		"title" : data.rslt.name,
  		  		"copy" : data.rslt.cy ? 1 : 0
  		  	},
  		  	success : function (r) {
  		  		if(!r.status) {
  		  			$.jstree.rollback(data.rlbk);
  		  		}
  		  		else {
  		  			$(data.rslt.oc).attr("id", "node_" + r.id);
  		  			if(data.rslt.cy && $(data.rslt.oc).children("UL").length) {
  		  				data.inst.refresh(data.inst._get_parent(data.rslt.oc));
  		  			}
  		  		}
  		  		$("#analyze").click();
  		  	}
  		  });*/
  	  });
  	});
  });
  
})(jQuery)