(function($) {
  $.fn.initAlcmsDates = function() {
    var $this = $(this);
    var params = {
      format: 'Y-m-d H:i'
    };

    if ($this.is(".alcms-datetime")) {
      $this.datetimepicker(params);
    } else {
      $this.find(".alcms-datetime").datetimepicker(params);
    }
  };

  $(function() {
    $("body").initAlcmsDates();
  });
})(jQuery);
