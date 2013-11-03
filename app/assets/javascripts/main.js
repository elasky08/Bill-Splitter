// Primary Author: Jonathan Allen (jallen01)

// Remove hash on modal close
$(document).on('hidden', '.modal', function () {
    removeHash();
    $(this).find(".validation-errors").remove();
});

// Reset form fields if data-form="reset"
$(document).on('hidden', '.modal[data-form="reset"]', function () {
    var modal = $(this);
    modal.find("input[type=text], textarea").not("input[type=hidden]").each(function (i, elem) {
        var value = modal.find("#original_" + String($(elem).attr('id'))).val();
        $(elem).val(value);
    });
});

// Reset form if data-form="temporary"
$(document).on('hidden', '.modal[data-form="temporary"]', function () {
    $(this).find("input[type=text], textarea").val("");
});

// Destroy modal if data-form="destroy"
$(document).on('hidden', '.modal[data-form="destroy"]', function () {
    $(this).remove();
});

// Register modal submit button
$(document).on('click', '.modal-form-submit', function (event) {
    $(this).parents('.modal').find(".modal-form").first().submit()
});

// Remove url hash without reloading page
// Code from http://stackoverflow.com/questions/1397329/how-to-remove-the-hash-from-window-location-with-javascript-without-page-refresh
var removeHash = function () { 
    var scrollV, scrollH, loc = window.location;
    if ("pushState" in history)
        history.pushState("", document.title, loc.pathname + loc.search);
    else {
        // Prevent scrolling by storing the page's current scroll offset
        scrollV = document.body.scrollTop;
        scrollH = document.body.scrollLeft;

        loc.hash = "";

        // Restore the scroll offset, should be flicker free
        document.body.scrollTop = scrollV;
        document.body.scrollLeft = scrollH;
    }
}