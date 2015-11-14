(function($) {
  $(function() {
    $('body').addClass('alcms-editables');

    var editor = new MediumEditor('.alcms-editable', {
      placeholder: false,
      toolbar: {
        static: true,
        updateOnEmptySelection: true,
        relativeContainer: $('.alcms-editor.editor-container')[0]
      }
    });
  });
})(jQuery);
