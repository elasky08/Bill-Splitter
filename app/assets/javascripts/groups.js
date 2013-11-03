// PRIMARY AUTHOR: Charles Liu (cliu2014)

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