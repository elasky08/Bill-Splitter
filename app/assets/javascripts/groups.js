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
			var url = window.location.pathname;
			if (url.slice(-1) === '/') {
				url += 'items/';
			} else {
				url += '/items/';
			}
			request = $.post(
				url,
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
});