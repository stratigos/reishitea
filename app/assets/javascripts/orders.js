// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// require network-related js here
//= require orders-event-listener

// behavioral js here

var updateOrderData = function(data) {
  console.log('UPDATE ORDER DATA', data);
}


$(document).on('ready page:load', function() {
  // Only run the following block if on index page.
  if($('div#orders-index-content')) {
    subscribeToOrders(updateOrderData);
  }
});