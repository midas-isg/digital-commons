function clearAndHideEditControlGroup(controlGroup) {
    var inputElements = $(controlGroup).closest(".control-group")[0].getElementsByTagName("input");
    for (var ie=0; ie < inputElements.length; ie++) {
        if (inputElements[ie].type === "text") {
            inputElements[ie].value = null;
        }
        if (inputElements[ie].type === "number") {
            inputElements[ie].value = null;
        }
    }
    var textareaElements = $(controlGroup).closest(".control-group")[0].getElementsByTagName("textarea");
    for (var tae=0; tae < textareaElements.length; tae++) {
        if (textareaElements[tae].type === "textarea") {
            textareaElements[tae].value = null;
        }
    }
    var selectElements = $(controlGroup).closest(".control-group")[0].getElementsByTagName("select");
    for (var se=0; se < selectElements.length; se++) {
        if (selectElements[se].type === "select-one") {
            selectElements[se].value = null;
        }
    }

    $(controlGroup).closest(".control-group").hide();
}
