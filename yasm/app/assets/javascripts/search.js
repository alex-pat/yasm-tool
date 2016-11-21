$(document).on("turbolinks:load", function () {
    $("#search-form").keyup(search);

    $(function(){
        $('.pagination a').attr('data-remote', 'true')
    });

    $(".toggle").change(search);
    $(".toggle").mouseleave(function () {
        $(this).removeClass("focus");
    })
});

function search() {
    var search_form = $("#search-form");
    var classes = $.makeArray($(".toggle.active").map(function(i, button) {
        return $(button).attr("name");
    }));
    $.get({
        url: search_form.attr("url"),
        data: {
            query: search_form.val(),
            classes: classes
        }
    });
}
