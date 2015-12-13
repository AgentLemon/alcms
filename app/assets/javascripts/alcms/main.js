(function($) {
  window.Alcms = {};

  $(function() {
    $body = $('body');
    $wrapper = $('<div/>').addClass('alcms-editables').append($body.children());
    $body.empty().append($wrapper);

    $('.alcms-editable').each(function() {
      var $this = $(this);
      $this.attr('contenteditable', true);
      CKEDITOR.inline(this).on('change', function() { $this.removeClass('initial').addClass('draft unsaved'); });
    })
  });
})(jQuery);
