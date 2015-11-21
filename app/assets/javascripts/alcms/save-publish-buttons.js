(function($) {
  $(function() {
    $save = $('.alcms-save');
    $publish = $('.alcms-publish');

    function getBlockParams(id, name) {
      var $tr = $('.alcms-editor .tbl-blocks tr[data-block-name="' + name + '"]');
      return {
        id: id,
        name: name,
        starts_at_draft: $tr.find('#starts_at').val(),
        expires_at_draft: $tr.find('#expires_at').val(),
        texts_attributes: []
      }
    }

    function collectData() {
      var blocks = {};
      $.each($('.alcms-editable'), function() {
        var $this = $(this);
        var block_name = $this.data('block-name');
        
        blocks[block_name] = blocks[block_name] || getBlockParams($this.data('block-id'), block_name);
        
        blocks[block_name].texts_attributes.push({
          id: $this.data('text-id'),
          name: $this.data('text-name'),
          content_draft: $this.html().replace(/ +/g, ' ')
        });
      });
      return $.map(blocks, function(value, key) { return value; });
    }

    function save(url, callback) {
      Alcms.toggleLoading(true);
      $.ajax({
        url: url,
        type: 'post',
        data: JSON.stringify({
          blocks: collectData()
        }),
        contentType: 'application/json',
        accepts: 'application/json',
        success: function(response) {
          Alcms.toggleLoading(false);
          callback && callback(response);
        },
        error: function() {
          Alcms.toggleLoading(false);
          Alcms.notify('danger', 'Error during save!');
        }
      });
    }

    $('.alcms-save').on('click', function() {
      save($(this).data('url'), function() {
        Alcms.notify('success', 'Successfully saved!');
        $('.alcms-editable.unsaved').removeClass('unsaved');
        $('.alcms-editable.initial').removeClass('initial').addClass('draft');
      });
    });

    $('.alcms-publish').on('click', function() {
      save($(this).data('url'), function() {
        Alcms.notify('success', 'Successfully published!');
        $('.alcms-editable.draft').removeClass('draft').removeClass('unsaved');
        $('.alcms-editable.initial').removeClass('initial');
        $('.alcms-editor .tbl-blocks tr.changed').removeClass('changed');
      });
    })
  });
})(jQuery);
