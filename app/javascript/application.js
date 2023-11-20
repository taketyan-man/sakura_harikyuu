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

    $('.host-nav').click(function(){
      var index = $('.host-nav').index(this);
      $('.nav-active').removeClass('nav-active');
      $(this).addClass('nav-active');
      if(index == 0){
        $('.booking-check').hide();
        $('.schedule').show();
      }else if(index == 1){
        $('.booking-check').show();
        $('.schedule').hide();
      };
    });
});
