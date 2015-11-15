(function($) {
  $(function() {
    $save = $('.alcms-save');
    $publish = $('.alcms-publish');

    function collectData() {
      var blocks = {};
      $.each($('.alcms-editable'), function() {
        var $this = $(this);
        var block_name = $this.data('block');
        
        blocks[block_name] = blocks[block_name] || {
          id: $this.data('block-id'),
          name: block_name,
          texts_attributes: []
        };
        
        blocks[block_name].texts_attributes.push({
          id: $this.data('text-id'),
          name: $this.data('text'),
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
      });
    })
  });
})(jQuery);
