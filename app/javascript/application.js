// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
import "controllers"
import jquery from "jquery"
window.$ = jquery
//= require jquery
//= require jquery_ujs
$(function () {
    $('.btn').on('click', function(){
      $('.menu-content').fadeIn();
    });
    $('.btn-close').on('click', function(){
      $('.menu-content').fadeOut();
    });
    $('.gnav_link').on('click', function(){
      var id = $(this).attr('href');
      var position = $(id).offset().top;
      $('.menu-content').fadeOut();
      $('html body').scrollTop(position);
    });

    $('#click').on('click', function(){
      var thisCount = $("#count").html();
        thisCount = Number(thisCount);
        thisCount = thisCount + 1;
      if (thisCount > 9){
        $('.right').hide();
        $('.host-link').show();
      };
      $("#count").html(thisCount);
    });

    $('.host-nav').on('click', function(){
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
  $('#delete-btn').on('click', function() {
    $('.delete-box').show();
  });

  $('#delete-content-out').on('click', function(){
    $('.delete-box').hide();
  });

  $('#delete_check').on('change', function(){
    var $button = $('#host_button')
    if($(this).is(':checked')) {
      $button.removeClass('button-disabled');
      $button.addClass('show-delete');
      $button.prop('disabled', false);
    }else {
      $button.removeClass('show-delete');
      $button.addClass('button-disabled');
      $button.prop('disabled', true);
    }
  })
});
