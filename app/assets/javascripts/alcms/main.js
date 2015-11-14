(function($) {
  $(function() {
    window.Alcms = {};

    $('body').addClass('alcms-editables');

    Alcms.editor = new MediumEditor('.alcms-editable', {
      placeholder: false,
      toolbar: {
        static: true,
        updateOnEmptySelection: true,
        relativeContainer: $('.alcms-editor.editor-container')[0]
      }
    });
  });
})(jQuery);
