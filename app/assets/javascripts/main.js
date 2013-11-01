$(document).on('click', 'button[data-dismiss="modal"]', function () {
    var modal = $(this).parents(".modal-content");
    modal.find("input[type=text], textarea").val("");
});

$(document).on('click', 'button[data-destroy="modal"]', function () {
    var modal = $(this).parents(".modal");
    modal.modal('hide');
    modal.find(".modal-content").empty();
});