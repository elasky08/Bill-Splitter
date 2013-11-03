// PRIMARY AUTHOR: Charles Liu (cliu2014)

$(document).ready(function() {
	if ($('#groups-list').length) {
		setInterval(function() {
			$.get('/groups.js');
		}, 5000);
	}
});

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