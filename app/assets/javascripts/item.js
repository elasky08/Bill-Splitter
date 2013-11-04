// PRIMARY AUTHOR: Charles Liu (cliu2014)

// Reload items list automatically every few seconds.
$(document).ready(function() {
	if ($('#items-list').length) {
		var path = window.location.pathname;

		// If the address has a trailing slash, don't include it in the ajax call
		// This way, we don't get things like /groups/1/.js (which is invalid)
		if (path.slice(-1) === '/') {
			path = path.substring(0, path.length - 1);
		}
		setInterval(function() {
			$.get(path + '.js');
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

$(document).on('click', '#add-me', function() {
	var $link = $(this);
	var url = $link.attr('href');
	$.post(url, { 'email': $link.data('email') });
	return false;
});
