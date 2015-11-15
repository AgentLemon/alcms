(function($) {
  Alcms.toggleLoading = function(visibility) {
    $('.alcms-notification.alcms-loading').toggle(visibility);
  }

  Alcms.notify = function(type, message) {
    var $note = $('<div>').addClass('alcms-notification');
    $note.addClass('alcms-' + type);
    $note.text(message);
    $('.alcms-notification.alcms-loading').after($note);
    $note.on('click', function() { $note.remove(); });
    setTimeout(function() { $note.click() }, 5000);
  }
})(jQuery);
