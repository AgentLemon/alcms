(function($) {
  window.Alcms = {};

  $(function() {
    var $body = $('body');
    var $wrapper = $('<div/>').addClass('alcms-editables').append($body.children());
    $body.empty().append($wrapper);

    $('.alcms-editable:not(.alcms-readonly)').each(function() {
      var $this = $(this);
      $this.attr('contenteditable', true);
      CKEDITOR.inline(this).on('change', function() {
        $this.removeClass('initial').addClass('draft unsaved');
        window.Alcms.unsaved = true;
      });
    })

    $(window).on('beforeunload', function() {
      return window.Alcms.unsaved ? 'You have unsaved changes!' : undefined;
    });
  });
})(jQuery);
