//= require jquery
//= require contentr_fancybox

(function($) {
  
  $(function() {
    // setup overlay for contentr admin
    $('a[rel*=facebox]').fancybox({
      'width': '90%',
			'height': '90%',
			'autoScale': false,
			'transitionIn': 'none',
			'transitionOut': 'none',
			'type': 'iframe'
    });
  });
  
})(jQuery);