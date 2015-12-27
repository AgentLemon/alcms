(function($) {
  $(function() {
    var $blocks = $('.alcms-editor.alcms-menu .scrollable-container .tbl-blocks tbody');

    function normalizeTime(str) {
      var dateRegexp = /([\d\-T:]+):\d{2}/;
      return str ? str.match(dateRegexp)[1].replace('T', ' ') : null;
    }

    function getBlockElement(name, starts, expires, changed, versions, urls) {
      var $tr = $('<tr/>');
      var $a = $('<a href="javascript:void(0)">');
      $a.text(name);
      $a.on('click', function() {
        $('html, body').animate({
          scrollTop: $('.alcms-editable[data-block-name="' + name + '"]:first').offset().top - 300
        })
      });
      $tr.append($('<td class="left"/>').append($a));
      
      $tr.append($('<td/>')
        .append($('<input id="starts_at" class="date-value alcms-datetime">').val(normalizeTime(starts)))
      );
      $tr.append($('<td/>')
        .append($('<input id="expires_at" class="date-value alcms-datetime">').val(normalizeTime(expires)))
      );
      $tr.initAlcmsDates();
      
      var $checkbox = $('<input type="checkbox" checked/>');
      $checkbox.on('change', function() {
        $('.alcms-editable[data-block-name="' + name + '"]').toggleClass('no-highlight', !$checkbox.is(':checked'))
      });
      $tr.append($('<td/>').append($checkbox));

      var $versions = $('<td/>');
      $.each(versions, function(index, version) {
        var $ver = $('<div class="block-version"/>');
        $ver.html(version.starts_at_draft + '&nbsp;‒&nbsp;' + version.expires_at_draft);
        if (version.initial) {
          $ver.append('&nbsp;(initial)')
        }
        $versions.append($ver);
      });
      $tr.append($versions);

      var $clone = $('<button class="alcms-clone btn btn-xs btn-success">').text('Clone');
      var $destroy = $('<button class="alcms-destroy btn btn-xs btn-danger">').text('Delete');
      if (urls.clone) {
        $clone.attr('data-url', urls.clone);
      } else {
        $clone.addClass('disabled').attr('disabled', 'disabled');
      }
      if (urls.destroy) {
        $destroy.attr('data-url', urls.destroy);
      } else {
        $destroy.addClass('disabled').attr('disabled', 'disabled');
      }
      $tr.append($('<td/>').append($clone).append('&nbsp;').append($destroy));

      $tr.attr('data-block-name', name);
      $tr.toggleClass('changed', changed);
      $tr.find('input.date-value').on('change', function() { $tr.addClass('changed unsaved'); });
      return $tr;
    }

    function gatherBlocks() {
      var blocks = {};
      $.each($('.alcms-editable'), function() {
        var $this = $(this);
        var name = $this.data('block-name');
        var block = $this.data('block');
        if (!blocks[name]) {
          blocks[name] = {
            starts: block.starts_at_draft || block.starts_at,
            expires: block.expires_at_draft || block.expires_at,
            changed: block.starts_at_draft != block.starts_at || block.expires_at_draft != block.expires_at,
            versions: $this.data('versions'),
            urls: { clone: $this.data('clone-path'), destroy: $this.data('destroy-path') }
          }
        }
      });
      return blocks;
    }

    $(document).on('saveSuccess', function() {
      $blocks.empty();
      var blocks = gatherBlocks();
      $.each(blocks, function(key, value) {
        $blocks.append(getBlockElement(key, value.starts, value.expires, value.changed, value.versions, value.urls))
      })
    });
    $(document).trigger('saveSuccess');
  });
})(jQuery);
