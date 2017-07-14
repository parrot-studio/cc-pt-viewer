// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery
//= require jquery-ui
//= require fastclick
//= require jquery-ui-touch-punch/jquery.ui.touch-punch
//= require jquery-touchswipe/jquery.touchSwipe
//= require bootstrap-switch/dist/js/bootstrap-switch
//= require bootstrap-sprockets

$(function(){
  FastClick.attach(document.body);

  $(document).on("keypress", function(e) {
    return !(e.which === 13 || e.keyCode === 13);
  });

  if (window.innerWidth < 768) {
    $("#ads").hide();
  }
});
