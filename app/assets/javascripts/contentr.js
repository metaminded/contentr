//= require jquery

(function($) {
  
  $(function() {
    
    // mark all areas on the page as content frontend editable
    $('div.contentr.area').addClass('contentr-fe');
    // mark each paragraph as frontent ediable
    $('div.contentr.paragraph').addClass('contentr-fe');
    
  });
  
})(jQuery);