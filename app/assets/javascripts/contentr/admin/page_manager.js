(function($) {
  
  Contentr.PM = function() {
    
    var mouseX, mouseY = 0;
    
    var currentPage = null;
    
    var loadPages = function(url) {
      history.pushState(null, document.title, url);
      $.get(url, function(data) {
        $("#page-manager").html(data);
        beginPageMove(currentPage, false);
      });
    };
    
    var beginPageMove = function(page, animated) {
      if (!page) return;
      
      currentPage = page;      

      var currentPageRow = $('#page-manager .pagegrid tbody tr[data-page-id='+currentPage.id+']');
      var ghost = $('#page-manager .pagegrid').append('<div id="ghost">'+currentPage.name+'</div>').find('#ghost');
      
      if (animated) {
        currentPageRow.fadeOut();
        ghost.fadeIn();
      } else {
        currentPageRow.hide();
        ghost.show();
      }
      
      updateGhostPosition();      
    };
    
    var endPageMove = function(buddyPage) {
      $.ajax({
        type: "PUT",
        url: "/contentr/admin/pages/"+currentPage.id+"/reorder/"+buddyPage.id,
        success: function(msg) {
          resetPageMove();
        },
        error: function(msg) {
          alert("Error: Page move failed. Please try again.");
          resetPageMove();
        }
      });
    };
    
    var resetPageMove = function() {
      currentPage = null;
      loadPages(window.location);
    };
    
    var updateGhostPosition = function() {
      $('#ghost').offset({top: mouseY + 5, left: mouseX});
    };
    
    return {
      init: function() {
        // listen for click events on navigation links
        $('#page-manager a[rel=pm-navigate]').live('click', function(e) {
          e.preventDefault();
          loadPages(this.href);
        });

        // listen for click events on the move tool
        $('#page-manager .pagegrid .tool.move-begin, #page-manager .pagegrid .tool.move-end').live('click', function(e) {
          e.preventDefault();
          
          var pageName = $(this).closest('tr').find('td.name a').text();
          var pageId = $(this).closest('tr').attr('data-page-id');
          if (!pageName || !pageId) return;
          var page = {id: pageId, name: pageName}
                    
          if (currentPage) {
            endPageMove(page);
          } else {
            beginPageMove(page, true);
          }
        });
        
        $('#page-manager .pagegrid tbody tr').live('hover', function() {
          // show/hide the move tool
          var moveBegin = $(this).find('.tool.move-begin');
          var moveEnd = $(this).find('.tool.move-end');
          if (currentPage) {
            moveBegin.hide();
            moveEnd.show();
          } else {
            moveBegin.show();
            moveEnd.hide();
          }
          
          // show/hide the tool container
          $(this).find('.tools').toggle();
          
          // highlight the row
          $(this).toggleClass('highlight');
        });
                
        $(document).keyup(function(e) {
          if (e.keyCode === 27 /*ESC*/) {
            resetPageMove();
          }
        });
        
        $(document).mousemove(function(e) {
          mouseX = e.pageX;
          mouseY = e.pageY;
          updateGhostPosition();
        });
        
        $(window).bind('popstate', function() {
          loadPages(location.href);
        });
      }
    };

  }();
  
  // On DOM ready
  $(function() {
    // Init Contentr PageManager
    Contentr.PM.init();
  });
  
})(jQuery);