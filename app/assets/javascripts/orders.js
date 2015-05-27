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

  // Fade out and remove least-recent order in the list, as long as list has
  // at least five recent Orders.
  if ($('div.recent-order').length > 5) {
    $('div.recent-order').last().fadeOut('fast', function() {
      $(this).remove();
      $('div.recent-orders hr').last().remove();
    });
  }
}

/**
 * Increments the 'Reishi Teas Sold / Shipped' Today and All Time counters.
 * @param order Object
 *  Expects properties: { quantity }
 * @param recentSelector String
 *  CSS Selector for the container of the recent / today value.
 * @param alltimeSelector String
 *  CSS Selector for the container of the alltime / total value.
 */
var updateTeasCounts = function(order, recentSelector, alltimeSelector) {
  // Grab containers for counters.
  var recentSpan = $(recentSelector);
  var allSpan    = $(alltimeSelector);

  // Grab values from counters.
  var todayVal = recentSpan.text();
  var allVal   = allSpan.text();

  // Hide current data (so updated value can animate back into view)
  recentSpan.hide();
  allSpan.hide();

  // Increment count. This could also be implemented with a NoSQL solution like
  //  Redis in order to retain more accurate values, without the need to access
  //  the application's persistent datastore. 
  todayVal = +todayVal + +order.quantity;
  allVal   = +allVal   + +order.quantity;

  // Update the counter containers' values.
  recentSpan.text(todayVal);
  allSpan.text(allVal);

  // Animate the updated values onto the screen.
  recentSpan.fadeIn();
  allSpan.fadeIn();
}

/**
 * Takes a 'recent Order' Pusher data JSON as input, and calls functions for
 *  updating the recent Orders list, and the counts of Orders sold and shipped.
 * @param data Object
 *  JSON containing an Order with some metadata.
 * @param is_order Boolean
 *  TRUE assumes data represents a recent Order, and calls appropriate page
 *   updating function.
 *  FALSE assumes data represents a recent shipment, and calls the shipment
 *   updating function.
 */
var updateOrderData = function(data, is_order) {
  if (data.order) {
    if(is_order) {
      updateRecentOrdersList(data.order);
      updateTeasCounts(data.order, '.recent-units-sold span', '.alltime-units-sold span');
    } else {
      updateTeasCounts(data.order, '.recent-units-shipped span', '.alltime-units-shipped span');
    }
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