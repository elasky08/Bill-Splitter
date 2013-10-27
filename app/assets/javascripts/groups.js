$(document).ready(function() {	
	var $addItemArea = $('#add-item-area');
	var MAX_LENGTH = 20;
	var request;

	$('#show-add-item').click(function() {
		disableInput(false);
		$addItemArea.slideDown('fast').find('#item-name').focus();
	});

	$('#add-item').click(function() {
		var itemName = $('#item-name').val();
		var itemCost = extractCost($('#item-cost').val());
		if (itemName.length === 0 || itemName.length > MAX_LENGTH) {
			$('.alert').text('Name must be 1-20 characters in length').fadeIn();
		} else if (isNaN(itemCost)) {
			$('.alert').text('Cost must be a valid number').fadeIn();
		} else {
			itemCost = parseFloat(itemCost);
			disableInput(true);
			request = $.post(
				getURL() + '/items/',
				{ item: { name: itemName, cost: itemCost }},
				function(data) {
					$addItemArea.find('input').val('');
					disableInput(false);
					newRow(data.name, data.cost);
				},
				'json'
			);
		}
	});

	$('#cancel-add-item').click(function() {
		if (request) {
			request.abort();
		}
		$addItemArea.slideUp('fast').find('input').val('');
		$('.alert').hide();
	});

	$addItemArea.find('input').focus(function() {
		$('.alert').fadeOut();
	});

	$('.get-bill').click(function() {
		getBillSummary();
	});

	var getURL = function() {
		var url = window.location.pathname;
		if (url.slice(-1) === '/') {
			url = url.substring(0, url.length - 1);
		} 
		return url;
	}

	var disableInput = function(isDisabled) {
		$addItemArea.find('input').attr('disabled', isDisabled);
		$('#add-item').attr('disabled', isDisabled);
	};

	var extractCost = function(costString) {
		var modifiedCostString = costString.trim();
		if (modifiedCostString.charAt(0) === "$") {
			modifiedCostString = modifiedCostString.substring(1).trim();
		}
		return modifiedCostString;
	};

	var newRow = function(name, cost) {
		var costStr = '$' + parseFloat(cost).toFixed(2);
		var $tr = $('<tr />').append($('<td />').text(name)).append($('<td />').text(costStr));
		$('#group-items').append($tr);
	};

	var getBillSummary = function() {
		$.get(getURL() + '/cost/', function(data) {
			populateBillSummary(data);
			$('#bill-modal').modal();
		}, 'json');
	};

	var populateBillSummary = function(cost) {
		$('#item-total').text(cost.toFixed(2));
		computeBillSummary();
	};

	var computeBillSummary = function() {
		var subtotal = parseFloat($('#item-total').text());
		var tax = parseFloat($('#tax-pct').val());
		var tip = parseFloat($('#tip-pct').val());
		var numPeople = parseInt($('#num-people').val());
		var total = subtotal * (1 + tax / 100 + tip / 100);
		var split = total / numPeople;	
		$('#total-bill').text(total.toFixed(2));
		$('#split-cost').text(split.toFixed(2));
	};
});