function site_init() {
    
    $("#star-input").rating({
        min: 0,
        max: 5,
        step: 1,
        size:'xs',
        showCaption: false,
        showClear: false
    });
    $("#star-input").on('rating.change', function(event, value, caption) {
        var data = {
            user: $(event.target).attr("user"),
            stars: value
        };
        var url = $(event.target).attr("url");
        $.ajax({
            type: "POST",
            url: url,
            dataType: "json",
            data: data,
            success: function (data) {
                $("#rating").text("Rating: " + data);
            }
        });

    });
    var theme_selector = $("select");
    var theme_name = theme_selector.find(":selected").text();
    var theme = 'https://bootswatch.com/' + theme_name + '/bootstrap.min.css';

    theme_selector.change(function () {
        theme_name = theme_selector.find(":selected").text();
        theme = 'https://bootswatch.com/' + theme_name + '/bootstrap.min.css';
        frames['preview'].document.head.firstElementChild.setAttribute('href', theme);
    });

    var cloud = $("#cloud");
    if (cloud.length) {
        $.get ({
            url: cloud.attr("url"),
            dataType: "json",
            success: function(data) {
                cloud.jQCloud(data);
            }
        })
    }

    var tags = $("#magicsuggest");
    if (tags.length) {
        var params = { site_id: tags.attr("site_id") };
        $.get ({
            url: tags.attr("url"),
            dataType: "json",
            data: params,
            success: function (data) {
                tags.magicSuggest({
                    data: data["all_tags"],
                    name: "site[tag_list]",
                    value: data["site_tags"]
                });
            }
        });
    }

}

$(document).on('turbolinks:load', site_init);
