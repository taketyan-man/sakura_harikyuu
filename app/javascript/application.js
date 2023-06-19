// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import jquery from "jquery"
window.$ = jquery
//= require jquery
//= require jquery_ujs
//$(function(){
  //alert("jQuery 動いた！")
//})

$(function() {
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
});