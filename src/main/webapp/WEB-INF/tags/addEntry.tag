<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<script>
    var PAGE_MASTER =
        (function() {
            var XSD_FORM,
                typesListString = "${xsdForms}",
                typesList = {},
                temp,
                temp2,
                temp3,
                xsdFormsPath = location.origin + "${pageContext.request.contextPath}" + "/resources/xsd-forms/",
                addEntryPath = location.origin + "${pageContext.request.contextPath}" + "/add-entry",
                i,
                j;

            temp = typesListString.split("-");

            for(i = 0; i < temp.length; i++) {
                if(temp[i].length > 0) {
                    temp2 = temp[i].split(":");

                    if(temp2.length > 1) {
                        typesList[temp2[0]] = [];
                        temp3 = temp2[1].split(";");

                        for(j = 0; j < temp3.length; j++) {
                            if(temp3[j].length > 0){
                                typesList[temp2[0]].push(temp3[j]);
                            }
                        }
                    }
                }
            }

            function PageMaster() {
                var tab_loaded = false;

                this.setAsLoaded = function() {
                    tab_loaded = true;
                }

                this.isLoaded = function() {
                    return tab_loaded;
                }

                return;
            }

            PageMaster.prototype.initialize = function() {
                var dcOptions,
                    option,
                    i,
                    formFrame;

                if(!this.isLoaded()) {
                    formFrame = document.getElementById("form-frame");

                    formFrame.onload = function() {
                        var formFrame = document.getElementById("form-frame"),
                            formDocument = (formFrame.contentWindow || formFrame.contentDocument),
                            form;

                        XSD_FORM = formFrame.contentWindow.XSD_FORM;

                        if(formDocument.document) {
                            formDocument = formDocument.document;
                        }

                        form = formDocument.getElementsByTagName("form")[0];
                        XSD_FORM.makeReadable();

                        formDocument.getElementById("submit").classList.add("btn btn-default");
                        formDocument.getElementById("submit").onclick = function() {
                            var xmlString;

                            if(formDocument.getElementById("submit-comments").getElementsByTagName("pre")[0]) {
                                xmlString = formDocument.getElementById("submit-comments").getElementsByTagName("pre")[0].textContent;

                                if(XSD_FORM.validate()) {
                                    $.post(
                                        addEntryPath,
                                        xmlString,
                                        function onSuccess(data,status,xhr) {
                                            console.info(data);
                                            console.info(status);
                                            console.info(xhr);
                                            alert("An email request has been sent to the administrator. Approval is pending.");
                                            //document.getElementById("email-result").innerHTML = "An email request has been sent to the administrator. Approval is pending.";
                                            //document.getElementById("email-result").classList.add("alert-success");
                                            //document.getElementById("email-result").classList.add("alert-dismissible");

                                            return;
                                        },
                                        "json"
                                    );
                                }
                            }

                            return;
                        };

                        return;
                    };

                    dcOptions = document.getElementById("dc-options");

                    for(i in typesList) {
                        if(typesList.hasOwnProperty(i)){
                            option = document.createElement("option");
                            option.text = i.charAt(0).toUpperCase() + i.substring(1, i.length - 4);
                            option.value = i.charAt(0) + i.substr(1);
                            option.value = option.value.replace(/[- ]/g, "");

                            if(typesList[i].length === 0) {
                                option.disabled = true;
                            }

                            dcOptions.add(option);
                        }
                    }

                    this.setAsLoaded();
                }

                return;
            }

            PageMaster.prototype.displaySubtypes = function(subtype) {
                var subtypeOptions = document.getElementById("subtype-options"),
                    option,
                    i;

                if(subtype.length > 0) {
                    document.getElementById("entry-type").textContent =
                        subtype.charAt(0).toUpperCase() + subtype.substr(1, subtype.length - (5));

                    if(subtypeOptions.getAttributeNode("hidden")) {
                        subtypeOptions.attributes.removeNamedItem("hidden");
                    }

                    while(subtypeOptions.length > 0) {
                        subtypeOptions.remove(0);
                    }

                    option = document.createElement("option");
                    option.defaultSelected = true;
                    option.text = "Please select entry type";
                    option.value = "";
                    subtypeOptions.add(option);

                    for(i = 0; i < typesList[subtype].length; i++) {
                        option = document.createElement("option");
                        option.text = typesList[subtype][i].charAt(0) +
                            camelCase2English(typesList[subtype][i].substr(1));
                        option.value = typesList[subtype][i].replace(/ /g, "-");
                        subtypeOptions.add(option);
                    }
                }
                else if(!subtypeOptions.getAttributeNode("hidden")) {
                    subtypeOptions.attributes.setNamedItem(document.createAttribute("hidden"));
                }

                return;
            };

            PageMaster.prototype.displayForm = function(form) {
                var formFrame = document.getElementById("form-frame");

                if(form.length > 0) {
                    formFrame.src = xsdFormsPath + form + ".html";
                }
                else {
                    formFrame.src = "";
                }

                return;
            };

            //TODO: remove redundant duplicate of this function (xsd-forms-overrides) after
            // proper helper library established
            function camelCase2English(inputString) {
                var outputString = inputString.charAt(0),
                    toInsert = '',
                    i;

                for(i = 1; i < inputString.length; i++) {
                    toInsert = inputString.charAt(i);

                    if((toInsert >= 'A') && (toInsert <= 'Z')) {
                        if((inputString.charAt(i-1) < 'A') || ((inputString.charAt(i-1) > 'Z'))) {
                            toInsert = ' ' + toInsert;
                        }
                    }
                    outputString += toInsert;
                }

                return outputString;
            }

            return new PageMaster();
        })();
</script>

<div class="col-md-12 container">
    <h3 class="title-font" id="subtitle">
        Add Entry
    </h3>

    <div id="add-entry-form-section" class="font-size-16">
        <form id="add-entry-form">
            <fieldset id="universal" class="form-group">
                <legend><span id="entry-type">New</span> entry</legend>

                <select id="dc-options" required class="form-control" name="typeText" onchange="PAGE_MASTER.displaySubtypes(this.value);" style="margin-bottom: 5px;">
                    <option value="" selected>Please select entry type</option>
                </select>

                <select id="subtype-options" required hidden class="form-control" name="typeText" onchange="PAGE_MASTER.displayForm(this.value);" style="margin-bottom: 5px;">
                </select>
            </fieldset>
        </form>
        
        <iframe id="form-frame" height="450px" style="width:100%; border: none"></iframe>
        <div id="email-result" class="alert" role="alert"></div>
    </div>
</div>

<script>
    PAGE_MASTER.initialize();
</script>
