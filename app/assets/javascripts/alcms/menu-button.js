(function($) {
  $(function() {
    var $btn = $('.js-alcms-open-menu');
    var $menu = $('.alcms-editor.alcms-menu');
    var $container = $('.alcms-editables');

    $btn.on('click', function() {
      $.each([$menu, $btn, $container], function() { $(this).toggleClass('opened'); })
    })
  });
})(jQuery);
