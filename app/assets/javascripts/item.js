$(document).on('shown', '#edit-item-modal', function() {
	console.log('here1');
	if ($('#item_group_expense').is(':checked')) {
		$('.edit-users').hide();
	}
});

$(document).on('change', '#item_group_expense', function() {
	$('#item_group_expense').is(':checked') ? $('.edit-users').slideUp() : $('.edit-users').slideDown();
});
