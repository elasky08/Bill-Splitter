// PRIMARY AUTHOR: Charles Liu (cliu2014)

// Reload items list automatically every few seconds.
$(document).ready(function() {
	if ($('#items-list').length) {
		setInterval(function() {
			$.get(window.location.pathname + '.js');
		}, 5000);
	}
});

// Hide item's user list when group_expense option is checked.
$(document).on('shown', '#edit-item-modal', function() {
	if ($('#item_group_expense').is(':checked')) {
		$('.edit-users').hide();
	}
});

// Show item's user list when group_expense option is unchecked.
$(document).on('change', '#item_group_expense', function() {
	$('#item_group_expense').is(':checked') ? $('.edit-users').slideUp() : $('.edit-users').slideDown();
});
