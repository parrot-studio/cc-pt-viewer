// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
// require jquery_ujs
// require turbolinks
//= require bootstrap
//= require_tree .


(function(document, $) {
  var selected = false;
  var JOB_NAME = {
    F: '戦',
    K: '騎',
    A: '弓',
    M: '魔',
    P: '僧'
  };

  var job_name_for_view = function(job) {
    return JOB_NAME[job];
  };

  var init_data = function() {
    var ul, li;
    ul = $("#characters");
    $.getJSON('/datas', {}, function(data) {
      $.each(data, function(i, d) {
        li = $('<li class="listed-character"><div class="character">' + job_name_for_view(d.job_type) + '・' + d.title + '' + d.name + '</div></li>');
        ul.append(li);
      });
    });
  };

  $(function() {
    init_data();

    $(document).on('click touch', 'li.listed-character', function(e) {
      var sc = $("#selected-character");
      sc.empty();
      sc.append($(e.target).text());
      selected = true;
    });

    $("div.selected-character").on('click touch', function(e) {
      if (!selected) {
        return false;
      }
      var d = $(e.target);
      var sc = $("#selected-character");
      d.empty();
      d.append(sc.text());
      sc.empty();
      selected = false;
    });
  });
})(document, jQuery);
