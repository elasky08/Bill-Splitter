// Primary Author: Jonathan Allen (jallen01)

// Remove hash on modal close
$(document).on('hide', '.modal', function () {
    removeHash();
});

// Reset form if data-form="temporary"
$(document).on('hide', '.modal[data-form="temporary"]', function () {
    $(this).find("input[type=text], textarea").val("");
});

// Destroy modal content if data-form="destroy"
$(document).on('hide', '.modal[data-form="destroy"]', function () {
    $(this).modal('hide');
    $(this).find(".modal-content").empty();
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