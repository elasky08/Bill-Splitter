$(document).ready(function() {	
	var $addItemArea = $('#add-item-area');
	var request;
	$('#show-add-item').click(function() {
		$addItemArea.find('input').attr('disabled', false);
		$('#add-item').attr('disabled', false);
		$addItemArea.slideDown('fast').find('input').focus();
	});

	$('#add-item').click(function() {
		$addItemArea.find('input').attr('disabled', true);
		$('#add-item').attr('disabled', true);
		request = $.post(); //TODO
	});

	$('#cancel-add-item').click(function() {
		request.abort();
		$addItemArea.slideUp('fast').find('input').val('');
	});

});