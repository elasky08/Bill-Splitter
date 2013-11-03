// PRIMARY AUTHOR: Charles Liu (cliu2014)

$(document).on('shown', '#edit-item-modal', function() {
	if ($('#item_group_expense').is(':checked')) {
		$('.edit-users').hide();
	}
});

$(document).on('change', '#item_group_expense', function() {
	$('#item_group_expense').is(':checked') ? $('.edit-users').slideUp() : $('.edit-users').slideDown();
});
