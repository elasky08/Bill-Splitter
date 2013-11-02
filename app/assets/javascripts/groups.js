// // PRIMARY AUTHOR: Charles Liu (cliu2014)


$(document).on('click', '#create-group-link', function (event) {
    $("#new-group-modal").modal();
});

$(document).on('click', '#edit-group-link', function (event) {
    $("#edit-group-modal").modal();
});

$(document).on('click', '#memberships-link', function (event) {
    $("#memberships-modal").modal();
});

$(document).on('click', '#new-item-link', function (event) {
    $("#new-item-modal").modal();
});

// $(document).ready(function() {
	
// 	var $addItemArea = $('#add-item-area');
// 	var MAX_LENGTH = 20;
// 	var request;

// 	// Bind click handler to the add item button. Make it show the input fields to add an item
// 	$('#show-add-item').click(function() {
// 		disableInput(false);
// 		$addItemArea.slideDown('fast').find('#item-name').focus();
// 	});

// 	// When an item is added, first check that the length is valid (between 1-20), and that the cost is a number
// 	// If valid inputs, perform the AJAX request to add the item, and add the line to the table
// 	$('#add-item').click(function() {
// 		var itemName = $('#item-name').val();
// 		var itemCost = extractCost($('#item-cost').val());

// 		// Validate length of itemname
// 		if (itemName.length === 0 || itemName.length > MAX_LENGTH) {
// 			$('#add-item-error').text('Name must be 1-20 characters in length').fadeIn();
// 		} else if (isNaN(itemCost)) { // Validate cost is a number
// 			$('#add-item-error').text('Cost must be a valid number').fadeIn();
// 		} else {
// 			itemCost = parseFloat(itemCost);
// 			disableInput(true);
// 			request = $.post(
// 				getURL() + '/items/',
// 				{ item: { name: itemName, cost: itemCost }},
// 				function(data) {
// 					$addItemArea.find('input').val('');
// 					disableInput(false);
// 					newRow(data.id, data.name, data.cost);
// 				},
// 				'json'
// 			);
// 		}
// 	});

// 	// When the cancel button is clicked, abort any requests that have not come back, and hide the add item area
// 	$('#cancel-add-item').click(function() {
// 		if (request) {
// 			request.abort();
// 		}
// 		$addItemArea.slideUp('fast').find('input').val('');
// 		$('#add-item-error').hide();
// 	});

// 	// Hide errors when the user clicks/focuses into an input field
// 	$addItemArea.find('input').focus(function() {
// 		$('#add-item-error').fadeOut();
// 	});

// 	$('#get-bill').click(function() {
// 		getBillSummary();
// 	});

// 	$('#recompute-bill').click(function() {
// 		computeBillSummary();
// 	});
	
// 	// Hide errors when the user clicks/focuses into an input field
// 	$('#bill-modal input[type="text"]').focus(function() {
// 		$('#invalid-bill-input-error').fadeOut();
// 	});

// 	// When the delete link is clicked, do an AJAX request to delete the item from the group
// 	// Callback returns false so that the link is not followed
// 	$('#group-items').on('click', '.delete-item', function() {
// 		var url = $(this).attr('href');
// 		var $line = $(this).parents('tr');
// 		$.post(url, { _method: 'delete' }, function() {
// 			$line.fadeOut(function() {
// 				$line.remove();
// 			});
// 		});
// 		return false;
// 	});

// 	// Gets the current url path without the domain or any additional params:
// 	// For example, returns /groups/1
// 	// The URL path returned by this function will not have the trailing '/'
// 	var getURL = function() {
// 		var url = window.location.pathname;
// 		if (url.slice(-1) === '/') {
// 			url = url.substring(0, url.length - 1);
// 		} 
// 		return url;
// 	};

// 	var disableInput = function(isDisabled) {
// 		$addItemArea.find('input').attr('disabled', isDisabled);
// 		$('#add-item').attr('disabled', isDisabled);
// 	};

// 	// Get the cost from the input field
// 	// Handles the case where there are spaces on both sides, as well as if the user inputs a dollar sign
// 	var extractCost = function(costString) {
// 		var modifiedCostString = costString.trim();
// 		if (modifiedCostString.charAt(0) === "$") {
// 			modifiedCostString = modifiedCostString.substring(1).trim();
// 		}
// 		return modifiedCostString;
// 	};

// 	// Create a new row in the group's table; called when an item is added
// 	var newRow = function(id, name, cost) {
// 		var costStr = '$' + parseFloat(cost).toFixed(2);
// 		var $deleteLink = $('<td />').append($('<a />').attr('href', getURL() + '/items/' + id).text('Delete').addClass('delete-item'));
// 		var $tr = $('<tr />').append($('<td />').text(name)).append($('<td />').text(costStr)).append($deleteLink);
// 		$('#group-items').append($tr);
// 	};

// 	// Get the bill summary
// 	// Figures out the sum of item costs via an AJAX call,then populates the tax and tip field 
// 	// to calculate an even split
// 	// Note that we assume 7.25% tax, 15% tip, and 4 people splitting by default
// 	var getBillSummary = function() {
// 		$.get(getURL() + '/cost/', function(data) {
// 			populateBillSummary(data);
// 			$('#bill-modal').modal();
// 		}, 'json');
// 	};

// 	// The callback for the bill summary AJAX request, followed by calculations using default tax/tip
// 	var populateBillSummary = function(cost) {
// 		$('#item-total').text(cost.toFixed(2));
// 		computeBillSummary();
// 	};

// 	// Computes the total bill and split costs based on the input fields
// 	// Validates the inputs, then does the necessary computations
// 	// Note that the tip is calculated relative to the subtotal.
// 	var computeBillSummary = function() {
// 		var subtotal = parseFloat($('#item-total').text());
// 		var tax = $('#tax-pct').val();
// 		var tip = $('#tip-pct').val();
// 		var numPeople = $('#num-people').val();
// 		// Validate all inputs are proper numbers
// 		if (isNaN(tax) || isNaN(tip) || isNaN(numPeople)) {
// 			$('#invalid-bill-input-error').fadeIn();
// 		}
// 		tax = parseFloat(tax);
// 		tip = parseFloat(tip);
// 		numPeople = parseInt(numPeople); 
// 		var total = subtotal * (1 + tax / 100 + tip / 100);
// 		var split = total / numPeople;	
// 		$('#total-bill').text(total.toFixed(2));
// 		$('#split-cost').text(split.toFixed(2));
// 	};
// });