$.fn.timeline = function(marks) {
  var $this = $(this);
  var options = {
    cellWidth: 40,
    cellHeight: 10
  };

  function formatTime(time, options) {
    if (time) {
      return time.toJSON().replace(/T/, '<br>').replace(/:[^:]+$/, '');
    } else {
      return 'n/a';
    }
  }

  if (marks === undefined) {
    marks = $this.data('marks')
  } else {
    $this.data('marks', marks);
    $this.addClass('timeline');
    $this.empty();

    var $line = $('<div/>').addClass('line').css({ width: (marks.length + 1) * options.cellWidth + 2 });
    $this.append($line);

    $this.on('mouseenter', '.step', function() {
      var $step = $(this);
      $this.siblings('.timeline').find('.step:eq(' + $step.data('index') + ')').addClass('hover');
    });

    $this.on('mouseleave', '.step', function() {
      $this.siblings('.timeline').find('.step').removeClass('hover');
    });

    for(var i = -1; i < marks.length + 1; i++) {
      var $marker = $('<div/>').addClass('marker');
      $marker.css({ left: (i + 1) * options.cellWidth });
      $this.append($marker);
      if (i < marks.length) {
        var $step = $('<div/>').addClass('step');
        $step.data('index', i + 1);
        $step.css({ left: (i + 1) * options.cellWidth, width: options.cellWidth });

        var $labelLeft = $('<div/>').addClass('label-left').html(formatTime(marks[i], { separator: '<br>' }));
        var $labelRight = $('<div/>').addClass('label-right').html(formatTime(marks[i + 1], { separator: '<br>' }));

        $step.append($labelLeft).append($labelRight);
        $this.append($step);
      }
    }

    $this.css({ width: (marks.length + 1) * options.cellWidth });
  }

  return {
    marks: marks,
    add: function(starts, expires) {
      var getIndex = function(date, def) {
        var time = date.getTime();
        for(var i = 0; i < marks.length; i++)
          if (marks[i].getTime() == time) return i;
        return def;
      };

      var $interval = $('<div/>').addClass('interval');
      var size = $this.find('.interval').length;
      var klass = size > 0 ? size % 5 + 1 : 0;

      var sIndex = getIndex(starts, 0);
      var eIndex = getIndex(expires, marks.length);
      var left = sIndex * options.cellWidth;
      var width = (eIndex - sIndex + 1) * options.cellWidth;
      var height = 1;

      $.each($this.find('.interval'), function(index, item) {
        var $i = $(item);
        var meta = $i.data('meta');
        if ((meta.start <= eIndex) && (meta.end >= sIndex) && (meta.height >= height)) {
          height = meta.height + 1;
        }
      });

      $interval.addClass(klass === 0 ? 'interval-primary' : ('interval-' + klass));
      $interval.data('meta', { start: sIndex, end: eIndex, height: height });
      $interval.css({ left: left, width: width, height: height * options.cellHeight, zIndex: 9 - height });
      $this.append($interval);
    }
  };
};
