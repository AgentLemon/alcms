(function($) {
  $(function() {
    var $blocks = $('.alcms-editor.menu .scrollable-container .tbl-blocks tbody');

    function getBlockElement(name, starts, expires, versions) {
      var $tr = $('<tr/>');
      var $a = $('<a href="javascript:void(0)">');
      $a.text(name);
      $a.on('click', function() {
        $('html, body').animate({
          scrollTop: $('.alcms-editable[data-block="' + name + '"]:first').offset().top - 300
        })
      });
      $tr.append($('<td class="left"/>').append($a));
      
      $tr.append($('<td/>').text(starts));
      $tr.append($('<td/>').text(expires));
      
      var $checkbox = $('<input type="checkbox" checked/>');
      $checkbox.on('change', function() {
        $('.alcms-editable[data-block="' + name + '"]').toggleClass('no-highlight', !$checkbox.is(':checked'))
      });
      $tr.append($('<td/>').append($checkbox));

      $tr.append($('<td/>').text('Current'));

      $tr.append(
        $('<td/>')
          .append($('<button class="btn btn-xs btn-success">').text('Clone'))
          .append('&nbsp;')
          .append($('<button class="btn btn-xs btn-danger">').text('Delete'))
      )

      return $tr;
    }

    function gatherBlocks() {
      var blocks = {};
      $.each($('.alcms-editable'), function() {
        var $this = $(this);
        var name = $this.data('block');
        if (!blocks[name]) {
          blocks[name] = {
            starts: 'n/a',
            expires: 'n/a',
            versions: []
          }
        }
      });
      return blocks;
    }

    $blocks.empty();
    var blocks = gatherBlocks();
    $.each(blocks, function(key, value) {
      $blocks.append(getBlockElement(key, value.starts, value.expires, value.versions))
    })
  });
})(jQuery);
