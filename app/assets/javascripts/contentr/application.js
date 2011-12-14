//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require contentr/overlay

(function($) {
  
  $(function() {
    // setup overlay for contentr admin
    $('a[rel=contentr-overlay]').contentr_overlay({
      width: '90%',
			height: '90%',
			close: function() {
			  location.reload();
			}
    });
    
    // make paragraphs sortable
    $('.contentr-area').sortable({ 
      items: '.paragraph',
      handle: '.toolbar .handle',
      update: function(event, ui) {
        var ids = $('.contentr-area').sortable('serialize');
        var current_page = $(this).closest('.contentr-area').attr('data-contentr-page');
        var area_name = 'body';
        $.ajax({
          type: "PUT",
          url: "/contentr/admin/pages/"+current_page+"/area/"+area_name+"/paragraphs/reorder",
          data: ids,
          error: function(msg) {
            alert("Error: Please try again.");
          }
        });
      } 
    });
  });
  
})(jQuery);