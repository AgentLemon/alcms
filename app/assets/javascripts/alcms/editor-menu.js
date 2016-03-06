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

    function getNames(blocks) {
      var $td = $("<td/>").addClass("alcms-blocks-names left");
      $.each(blocks, function(name, block) {
        var $div = $("<div/>").addClass("alcms-editor-block alcms-bottom-text");

        //var $checkbox = $('<input type="checkbox" checked/>');
        //$checkbox.on('change', function() {
        //  $('.alcms-editable[data-block-name="' + name + '"]').toggleClass('no-highlight', !$checkbox.is(':checked'))
        //});
        //$div.append($checkbox).append("&nbsp;");

        var $a = $('<a href="javascript:void(0)">');
        $a.text(name);
        $a.on('click', function() {
          $('html, body').animate({
            scrollTop: $('.alcms-editable[data-block-name="' + name + '"]:first').offset().top - 300
          })
        });
        $div.append($a);
        $td.append($div);
      });
      return $td;
    }

    function getStarts(blocks) {
      var $td = $("<td/>").addClass("alcms-blocks-starts");
      $.each(blocks, function(name, block) {
        var $div = $("<div/>").addClass("alcms-editor-block alcms-bottom-text");
        $div.append($('<input id="starts_at" class="date-value alcms-datetime">').val(normalizeTime(block.starts)));
        $div.attr('data-block-name', name);
        $td.append($div);
      });
      $td.initAlcmsDates();
      return $td;
    }

    function getExpires(blocks) {
      var $td = $("<td/>").addClass("alcms-blocks-expires");
      $.each(blocks, function(name, block) {
        var $div = $("<div/>").addClass("alcms-editor-block alcms-bottom-text");
        $div.append($('<input id="expires_at" class="date-value alcms-datetime">').val(normalizeTime(block.expires)));
        $div.attr('data-block-name', name);
        $td.append($div);
      });
      $td.initAlcmsDates();
      return $td;
    }

    function getTimeline(blocks) {
      var marks = [];
      $.each(blocks, function(name, block) {
        $.each(block.versions, function(index, version) {
          if (version.starts_at_draft != 'n/a' && marks.indexOf(version.starts_at_draft) === -1) {
            marks.push(version.starts_at_draft)
          }
          if (version.expires_at_draft != 'n/a' && marks.indexOf(version.expires_at_draft) === -1) {
            marks.push(version.expires_at_draft)
          }
        });
      });
      marks = $.map(marks, function(item) { return new Date(item); }).sort();
      return marks;
    }

    function getVersions(blocks) {
      getTimeline(blocks);

      var $td = $("<td/>").addClass("alcms-blocks-versions");
      $.each(blocks, function(name, block) {
        var $div = $("<div/>").addClass("alcms-editor-block");
        var timeline = $div.timeline(getTimeline(blocks));
        $.each(block.versions, function(index, version) {
          timeline.add(new Date(version.starts_at_draft), new Date(version.expires_at_draft));
        });
        $td.append($div);
      });
      return $td;
    }

    function getButtons(blocks) {
      var $td = $("<td/>").addClass("alcms-blocks-buttons");
      $.each(blocks, function(name, block) {
        var $div = $("<div/>").addClass("alcms-editor-block alcms-bottom-text");
        var $clone = $('<button class="alcms-clone btn btn-xs btn-success">').text('Clone');
        var $destroy = $('<button class="alcms-destroy btn btn-xs btn-danger">').text('Delete');

        if (block.urls.clone) {
          $clone.attr('data-url', block.urls.clone);
        } else {
          $clone.addClass('disabled').attr('disabled', 'disabled');
        }

        if (block.urls.destroy) {
          $destroy.attr('data-url', block.urls.destroy);
        } else {
          $destroy.addClass('disabled').attr('disabled', 'disabled');
        }

        $div.append($clone).append('&nbsp;').append($destroy);
        $td.append($div);
      });
      return $td;
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

    // todo: set 'changed' class
    // todo: add data-block-header to names div
    // todo: set initial classes depended on this data attribute
    // todo: create function for building

    $(document).on('saveSuccess', function() {
      $blocks.empty();
      var blocks = gatherBlocks();
      //$.each(blocks, function(key, value) {
      //  $blocks.append(getBlockElement(key, value.starts, value.expires, value.changed, value.versions, value.urls))
      //})
      var $tr = $("<tr/>");
      $tr.append(getNames(blocks));
      $tr.append(getStarts(blocks));
      $tr.append(getExpires(blocks));
      $tr.append(getVersions(blocks));
      $tr.append(getButtons(blocks));
      $blocks.append($tr);
    });
    $(document).trigger('saveSuccess');
  });
})(jQuery);
