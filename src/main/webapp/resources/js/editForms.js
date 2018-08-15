function clearAndHideEditControlGroup(controlGroup, id) {
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
/*
    var geometryElements = $(controlGroup).closest(".control-group")[0].getElementsByTagName("select");
    for (var ge=0; tae < geometryElements.length; ge++) {
        if (geometryElements[ge].type === "select") {
            geometryElements[geometryElements].selected(null);
        }
    }
*/
}
