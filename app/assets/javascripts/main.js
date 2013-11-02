// Primary Author: Jonathan Allen (jallen01)

// Remove hash on modal close
$(document).on('hide', '.modal', function () {
    removeHash();
});

// Reset form fields if data-form="reset"
$(document).on('hide', '.modal[data-form="reset"]', function () {
    var modal = $(this);
    modal.find(".validation-errors").remove();
    modal.find("input[type=text], textarea").not("input[type=hidden]").each(function (i, elem) {
        var elem = $(elem); 
        value = modal.find("#original_" + String(elem.attr('id'))).val();
        elem.val(value);
    });
});

// Reset form if data-form="temporary"
$(document).on('hide', '.modal[data-form="temporary"]', function () {
    var modal = $(this);
    modal.find("input[type=text], textarea").val("");
    modal.find(".validation-errors").remove();
});

// Destroy modal content if data-form="destroy"
$(document).on('hide', '.modal[data-form="destroy"]', function () {
    var modal = $(this);
    modal.modal('hide');
    modal.find(".modal-content").empty();
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