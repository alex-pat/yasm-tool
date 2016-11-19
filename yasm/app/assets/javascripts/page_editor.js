$(document).on('turbolinks:load', function() {
    $(".component-thumbnail").draggable({
        revert: "invalid",
        containment: "document",
        helper: "clone",
        cursor: "move"
    });
    $('.layout-thumbnail-button').click(change_layout);
    $("textarea[data-provide='markdown']").markdown();
    set_actions_to_blocks();
    set_actions_to_components();
    set_actions_to_tables();
    jQuery.fn.pop = [].pop;
    jQuery.fn.shift = [].shift;
});

function set_actions_to_blocks() {
    $(".components-list ul#complist").sortable({
        connectWith: ".connectedSortable",
        cancel: "input,textarea,button,select,option,.table-field",
        update: function(event, ui) {
            return set_attributes_to_components();
        }
    });

    $(".block").droppable({
        accept: ".component-thumbnail",
        drop: function(event, ui) {
            return create_new_component_form($(this).attr("position"), $(ui.draggable).attr('kind'));
        }
    });
};

function set_actions_to_components() {
    set_onchange_form_action($(".form-control"));

    $(".form-component").each(function(index, element) {
        return $(element).attr("data-order", index);
    });
    set_attributes_to_components();
    set_attributes_to_input();
    $('.rm-component-button').click(function() {
        return destroy_component($(this));
    });
};

function change_layout() {
    $(".form-layout").remove();
    var layout_type = $(this).attr("layout");
    new_layout = $(".form-layout-sample-" + layout_type).first().clone();
    new_layout.removeClass("form-layout-sample-" + layout_type);
    new_layout.removeClass("form-layout-sample");
    new_layout.addClass("form-layout");
    new_layout.attr("layout", layout_type);
    $("#components-panel-body").append(new_layout);
    set_actions_to_blocks();
    $(".layout-type").attr("value", layout_type);
};

function create_new_component_form(position, content_type) {
    var new_component = $(".form-component-sample-" + content_type).first().clone();
    new_component.removeClass("form-component-sample-" + content_type);
    new_component.removeClass("form-component-sample");
    new_component.addClass("form-component");
    new_component.attr("kind", content_type);
    $(".form-layout .block[position='"+ position + "'] ul#complist").append(new_component);
    $(new_component).wrap('<li class="list-group-item"></li>');
    $('.destroy-component-button').click(function() {
        return destroy_component($(this));
    });
    set_actions_to_components();
    if (content_type === "text") {
        new_component.find("textarea").markdown();
    } else if (content_type === "table") {
        set_actions_to_tables(new_component.find(".table-editable"));
    }
};

function set_attributes_to_input(div_with_input, input_order) {
    var content_type = $(div_with_input).attr("kind");
    var position = $(div_with_input).closest($(".block")).attr("position");
    var hidden_input = $(div_with_input).find(".hidden-input").first();
    var id_input = $(div_with_input).find(".id-input");
    $(div_with_input).attr("data-order", input_order);
    hidden_input.attr("name", "components[" +
                      position + "][" +
                      input_order + "][" +
                      ($(div_with_input).attr("kind")) + "]");
    if (id_input.length) {
        id_input.attr("name",  "components[" +
                      position + "][" +
                      input_order + "][id]");
    }
    return set_onchange_form_action($(div_with_input));
};

function set_attributes_to_components() {
    return $(".form-component").each(function(index, element) {
        return set_attributes_to_input(element, index);
    });
};

function destroy_component(pressed_button) {
    pressed_button.closest($(".list-group-item")).remove();
    $(".form-component").each(function(index, element) {
        return $(element).attr("data-order", index);
    });
    set_attributes_to_components();
};

function set_onchange_form_action(component_form) {
    return $(component_form).keyup(function() {
        var content_type = $(this).attr("kind");
        var position = $(this).closest($(".block")).attr("position");
        var order = $(this).attr("data-order");
        var text = $(this).find(".form-control").first().val();
        if (content_type === "video") {
            text = getYouTubeId(text);
        }
        return $("input[name='components["
                 + position + "]["
                 + order + "]["
                 + content_type + "]']").attr('value', text);
    });
};

function getYouTubeId(url) {
    var regExp = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/;
    var match = url.match(regExp);
    if (match && match[2].length === 11) {
        return match[2];
    } else {
        return 'dQw4w9WgXcQ?autoplay=1';  // Rick Astley - Never Gonna Give You Up
    }
};

function insert_link(component, url) {
    var textarea = $(component).closest($('.form-group')).find('textarea').first();
    textarea.val(textarea.val() + url );
    textarea.change();
    set_attributes_to_components();
}

function set_table_input() {
    var table = $(this).closest($(".table-editable"));
    var rows = table.find('tr:not(:hidden)');
    var headers = [];
    var data = [];

    $(rows.shift()).find('th:not(:empty)').each(function () {
        headers.push($(this).text().toLowerCase());
    });
    
    rows.each(function () {
        var td = $(this).find('td');
        var h = {};
        
        headers.forEach(function (header, i) {
            h[header] = td.eq(i).text();   
        });
        
        data.push(h);
    });
    var data_source = {
        "chart": {
            "caption": table.find(".table-title").text()
        },
        "data": data        
    };

    var input_value = table.find("option:selected").attr("value") + "\n" + JSON.stringify(data_source);

    var position = $(this).closest($(".block")).attr("position");
    var order = $(this).closest($(".form-component")).attr("data-order");

    return $("input[name='components["
             + position + "]["
             + order + "][table]']").attr('value', input_value);
}

function set_actions_to_tables(table) {
    if (table === undefined) {
        table = $(".table-editable");
    }
    table.find(".table-add").click(function () {
        var new_line = table.find('tr.hide').clone(true).removeClass('hide table-line');
        table.find('table').append(new_line);
    });

    table.find('.table-remove').click(function () {
        $(this).parents('tr').detach();
    });

    table.find('.table-up').click(function () {
        var row = $(this).parents('tr');
        if (row.index() === 1) return; 
        row.prev().before(row.get(0));
    });

    table.find('.table-down').click(function () {
        var row = $(this).parents('tr');
        row.next().after(row.get(0));
    });

    table.find("select").change(set_table_input);

    table.find(".table-field").keyup(set_table_input);
}
