(function($) {
  window.Alcms = {};

  $(function() {
    $('body').addClass('alcms-editables');

    Alcms.editor = new MediumEditor('.alcms-editable', {
      placeholder: false,
      toolbar: {
        static: true,
        updateOnEmptySelection: true,
        relativeContainer: $('.alcms-editor.editor-container')[0]
      }
    });

    Alcms.editor.subscribe('editableInput', function(event, editable) {
      $(editable).removeClass('initial').addClass('draft unsaved');
    });
  });
})(jQuery);
