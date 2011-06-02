//= require jquery
//= require contentr/fancybox

(function($) {
  
  $(function() {
    // setup overlay for contentr admin
    $('a[rel=contentr-fancybox]').contentr_fancybox({
      'width': '90%',
			'height': '90%',
			'autoScale': false,
			'transitionIn': 'none',
			'transitionOut': 'none',
			'type': 'iframe'
    });
  });
  
})(jQuery);