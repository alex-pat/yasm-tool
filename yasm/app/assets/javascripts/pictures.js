var $existBtn;

function setImage(event_target, public_id, url) {
    var search_element = setSearchElement(event_target);
    var picture = search_element.find("#picture");
    setPicture(picture, public_id, url);
    setHiddenInputAttributes(search_element, public_id, url)
}

function setSearchElement(event_target) {
    var element = $(event_target).first().closest(".form-component");
    if (element.length === 0) {
        return $("#avatar").first();
    } else {
        return element;
    }
}

function setPicture(picture, public_id, url) {
    picture.empty();
    picture.append("<img src=" + url
        + " id="
        + public_id
        + " class='avatar img-responsive img-rectangle img-thumbnail'><br/>");
}

function setHiddenInputAttributes(search_element, public_id, url) {
    if (search_element.attr("id") !== "avatar") {
        search_element.find(".hidden-input").first().attr("value", public_id);
        set_attributes_to_components();
        set_attributes_to_input();
    } else {
        $(".hidden-input").first().attr("value", url);
    }
}

function launchEditor(picture) {
    var id = picture.attr("id");
    featherEditor.launch({
        image: id,
        url: picture.attr("src")
    });
    return false;
}

var featherEditor = new Aviary.Feather({
    apiKey: '0728ddae97b84c04bcd6adf4ef7fd5dc',
    apiVersion: 3,
    theme: 'light',
    tools: ['resize', 'crop', 'brightness', 'contrast', 'orientation', 'effects'],
    appendTo: '',
    onSave: function(imageID, newURL) {
        var img = document.getElementById(imageID);
        img.src = newURL;
        var url = $("#update-path").attr("url");
        var sendable = {'public_id': imageID, 'new_url': newURL};
        $.ajax({
            type: "POST",
            url: url,
            dataType: 'json',
            data: sendable
        });
    },

    onError: function(errorObj) {
        alert(errorObj.message);
    }
});


$(document).click(function (event) {
    if ($(event.target).closest("#upload").length) {
        cloudinary.openUploadWidget({ cloud_name: 'task4testcloud',
                                      upload_preset: 'ycx2wuob',
                                      theme: 'white'},
                                    function(error, result) {
                                        var url = $("#upload-path").attr("url");
                                        var sendable = {'public_id': result[0]["public_id"]};
                                        $.ajax({
                                            type: "POST",
                                            url: url,
                                            dataType: 'json',
                                            data: sendable
                                        });
                                        setImage(event.target,
                                            result[0]["public_id"],
                                            result[0]["url"]
                                        );
                                    });
    }
});

$(document).on('turbolinks:load', function() {
    $("div.pictures div div img").click(function (event) {
        var modal_body = $("#pictureModal div div div.modal-body");
        modal_body.empty();
        var picture = $(event.target).clone();
        modal_body.append(picture);
    });

    $.getScript("http://widget.cloudinary.com/global/all.js");

    $("#existModal").on('show.bs.modal', function (e) {
        $existBtn = e.relatedTarget;
        console.log($existBtn);
    });
});
