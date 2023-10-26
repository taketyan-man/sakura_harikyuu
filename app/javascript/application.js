// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
import "controllers"
import jquery from "jquery"
window.$ = jquery
//= require jquery
//= require jquery_ujs
$(function () {
    $('.btn').click(function(){
      $('.menu-content').fadeIn();
    });
    $('.btn-close').click(function(){
      $('.menu-content').fadeOut();
    });
    $('.gnav_link').click(function(){
      var id = $(this).attr('href');
      var position = $(id).offset().top;
      $('.menu-content').fadeOut();
      $('html body').scrollTop(position);
    });

    $('#click').click(function(){
      var thisCount = $("#count").html();
        thisCount = Number(thisCount);
        thisCount = thisCount + 1;
      if (thisCount > 9){
        $('.right').hide();
        $('.host-link').show();
      };
      $("#count").html(thisCount);
  });
});

  // $('.menu_select').change(function(){
    //var r = $('#menu option:selected').val();
    //if (r){
      //$('#submit').show();
    //}else {
      //$('#submit').hide();
    //}
  //});
