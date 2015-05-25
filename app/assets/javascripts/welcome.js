// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('ready page:load', function() {
  $('.shortorder-form button').on('click', function(e) {
    e.preventDefault();
    window.location.href = '/orders/new?name=' + $('#inputname').val() + '&quantity=' + $('#inputquantity').val();
  });
});