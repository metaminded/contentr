//= require jquery
//= require jquery-ui
//= require jquery_ujs

(function($) {
  
  var Contentr = {};
  
  Contentr.getContent = function(url) {
    $.get(url, function(data) {
      $("#content").html(data)      
    });
  };
  
  $(function() {
    
    if (history && history.pushState) {
      $('#content a[rel=ajax-navigate]').live('click', function(e) {
        e.preventDefault();
        history.pushState(null, document.title, this.href)
        Contentr.getContent(this.href);
      });
      
      $(window).bind('popstate', function() {
        Contentr.getContent(location.href);
      });
    }
    
    Contentr.moveMode = false;
    
    $(window).bind('contentr:enterMoveMode', function() {
      $('body').css('cursor', 'move');
      Contentr.moveMode = true;
      
    });
    
    $('#content a[rel=move]').live('click', function(e) {
      e.preventDefault();
      $(window).trigger('contentr:enterMoveMode');
    });
    
    $('#content .pagegrid tbody tr').live('hover', function() {
      if (Contentr.moveMode === true) {
        $(this).toggleClass('highlight');
      }
    });
    
  });
  
})(jQuery);
