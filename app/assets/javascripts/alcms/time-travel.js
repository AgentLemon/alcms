(function($) {
  $(function() {
    var $date = $('.alcms-editor #alcms-time-travel');

    var dateVal = $date.val();
    Alcms.currentDate = dateVal ? new Date(dateVal) : new Date();

    function getParams() {
      var params = {};
      var search = location.search.substr(1) || "";
      search.split('&').forEach(function(item) {
        var tmp = item.split('=');
        params[tmp[0]] = decodeURIComponent(tmp[1]);
      });
      return params;
    }

    $('.alcms-editor .js-time-travel-go').on('click', function() {
      var params = getParams();
      var value = $date.val();
      if (value) {
        params['alcms_date'] = value;
      } else {
        delete params['alcms_date'];
      }
      
      Alcms.toggleLoading(true);
      location.href = location.origin + location.pathname + '?' + $.param(params) + location.hash;
    });
  });
})(jQuery);
