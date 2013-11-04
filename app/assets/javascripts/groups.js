// PRIMARY AUTHOR: Charles Liu (cliu2014)

// Reload groups list every few seconds.
$(document).ready(function() {
	var REFRESH_INTERVAL = 5000;

	if ($('#groups-list').length) {
		setInterval(function() {
			$.get('/groups.js');
		}, REFRESH_INTERVAL);
	}
});

$(document).on('click', '#create-group-link', function (event) {
    $("#new-group-modal").modal();
});

$(document).on('click', '#edit-group-link', function (event) {
    $("#edit-group-modal").modal();
});

$(document).on('click', '#view-group-link', function (event) {
    $("#view-group-modal").modal();
});

$(document).on('click', '#memberships-link', function (event) {
    $("#memberships-modal").modal();
});

$(document).on('click', '#new-item-link', function (event) {
    $("#new-item-modal").modal();
});