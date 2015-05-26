/**********************************
* Require network-related JS here.
***********************************/
//= require orders-event-listener

/****************************************
* Define behavioral JS for Orders below.
*****************************************/

/**
 * Adds a new Order info to the list of recent Orders.
 * @param order Object
 *  Expects properties: { name, city, country, quantity }
 */
var updateRecentOrdersList = function(order) {
  // Add new order to the recent orders list.
  
  // Container for each Order property to be displayed, set to hidden so it
  //  can fade in after being added to its parent.
  var recentDiv = $(document.createElement('div')).addClass('recent-order list-group');
  recentDiv.html(
    '<p class="list-group-item list-group-item-success">Name: ' + order.name + '</p>'
    + '<p class="list-group-item">City: ' + order.city + '</p>'
    + '<p class="list-group-item">Country: ' + order.country + '</p>'
    + '<p class="list-group-item">Quantity: ' + order.quantity + '</p>'
  );
  recentDiv.hide();

  // Add the recent Order to the top of the list.
  $('div.recent-orders').prepend($(document.createElement('hr')));
  $('div.recent-orders').prepend(recentDiv);

  // Fade the new Order in.
  recentDiv.fadeIn('slow');

  // Fade out and remove least-recent order in the list.
  $('div.recent-order').last().fadeOut('fast', function() {
    $(this).remove();
    $('div.recent-orders hr').last().remove();
  });
}

/**
 * Increments the 'Reishi Teas Sold' Today and All Time counters.
 */
var updateTeasSoldCounts = function() {
  // Grab containers for counters.
  var recentSoldSpan = $('.recent-units-sold span');
  var allSoldSpan    = $('.alltime-units-sold span');

  // Grab values from counters.
  var todaySoldVal = recentSoldSpan.text();
  var allSoldVal   = allSoldSpan.text();

  // Hide current data (so updated value can animate back into view)
  recentSoldSpan.hide();
  allSoldSpan.hide();

  // Increment count. This could also be implemented with a NoSQL solution like
  //  Redis in order to retain more accurate values, without the need to access
  //  the application's persistent datastore. 
  todaySoldVal++;
  allSoldVal++;

  // Update the counter containers' values.
  recentSoldSpan.text(todaySoldVal);
  allSoldSpan.text(allSoldVal);

  // Animate the updated values onto the screen.
  recentSoldSpan.fadeIn();
  allSoldSpan.fadeIn();
}

/**
 * Takes a 'recent Order' Pusher data JSON as input, and calls functions for
 *  updating the recent Orders list, and the counts of Orders sold and shipped.
 * @param data Object
 *  JSON containing an Order with some metadata.
 */
var updateOrderData = function(data) {
  if (data.order) {
    updateRecentOrdersList(data.order);
    updateTeasSoldCounts();
  }
}

/**
 * Check if the orders/index template is loaded, then call the
 *  appropriate function for subscribing to Pusher events.
 */
$(document).on('ready page:load', function() {
  if($('div#orders-index-content')) {
    if (typeof subscribeToOrders === 'function') {
      subscribeToOrders(updateOrderData);
    }
  }
});