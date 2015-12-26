(function($) {
  $(function() {
    function doAction(url, method) {
      Alcms.toggleLoading(true);
      $.ajax({
        url: url,
        type: method,
        contentType: 'application/json',
        accepts: 'application/json',
        success: function(response) {
          document.location.reload();
        },
        error: function() {
          Alcms.toggleLoading(false);
          Alcms.notify('danger', 'Error occured!');
        }
      });
    }

    function clone() {
      var $this = $(this);
      doAction($this.data('url'), 'post');
    }

    function destroy() {
      if (confirm('Are you sure you want to delete block?')) {
        var $this = $(this);
        doAction($this.data('url'), 'delete');
      }
    }

    $(document).on('click', '.alcms-clone', clone);
    $(document).on('click', '.alcms-destroy', destroy);
  });
})(jQuery);
