<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<script>
    var PAGE_MASTER =
        (function() {
            var xsdFormsPath = location.origin + "${pageContext.request.contextPath}" + "/resources/xsd-forms/",
                addEntryPath = location.origin + "${pageContext.request.contextPath}" + "/add-entry",
                dcTypes = [
                    "Software",
                    "Datasets",
                    "Data-augmented Publications",
                    "Web Services",
                    "Data Formats",
                    "Standard Identifiers"
                ],
                subtypesList = {
                    "softwareTypes": [
                        "Software",
                        "Disease transmission models",
                        "Population dynamics model",
                        "Data-format converters",
                        "Data visualizers",
                        "Disease forecasters",
                        "Disease transmission tree estimators",
                        "Modeling platforms",
                        "Pathogen evolution models",
                        "Phylogenetic tree constructors",
                        "Synthetic ecosystem constructors",
                        "Data service"
                    ],
                    "datasetsTypes": [
                        "Dataset"
                    ],
                    "dataAugmentedPublicationsTypes": [
                        "Data-augmented publications"
                    ],
                    "webServicesTypes": [
                        "Web services"
                    ],
                    "dataFormatsTypes": [
                        "Data format"
                    ],
                    "standardIdentifiersTypes": [
                        "Standard Identifier"
                    ]
                };

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
                            form,
                            XSD_FORM = formFrame.contentWindow.XSD_FORM;

                        if(formDocument.document) {
                            formDocument = formDocument.document;
                        }

                        form = formDocument.getElementsByTagName("form")[0];
                        XSD_FORM.makeReadable();

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
                                            return;
                                        },
                                        "xml"
                                    );
                                }
                            }

                            return;
                        };

                        return;
                    };

                    dcOptions = document.getElementById("dc-options");

                    for(i = 0; i < dcTypes.length; i++) {
                        option = document.createElement("option");
                        option.text = dcTypes[i];
                        //TODO: capitalize words after hyphens
                        option.value = dcTypes[i].charAt(0).toLowerCase() + dcTypes[i].substr(1);
                        option.value = option.value.replace(/[- ]/g, "") + "Types";

                        /**/
                        option.disabled = true;
                        if(dcTypes[i] === "Software") {
                            option.disabled = false;
                        }
                        /**/

                        dcOptions.add(option);
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
                    document.getElementById("entry-type").textContent = subtype;
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

                    for(i = 0; i < subtypesList[subtype].length; i++) {
                        option = document.createElement("option");
                        option.text = subtypesList[subtype][i];
                        option.value = subtypesList[subtype][i].toLowerCase().replace(/ /g, "-");
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

                <select id="dc-options" required class="form-control" name="typeText" onchange="PAGE_MASTER.displaySubtypes(this.value);">
                    <option value="" selected>Please select entry type</option>
                </select>

                <select id="subtype-options" required hidden class="form-control" name="typeText" onchange="PAGE_MASTER.displayForm(this.value);">
                </select>
            </fieldset>
        </form>

        <iframe id="form-frame" height="500px" style="width:100%;"></iframe>
    </div>
</div>

<script>
    PAGE_MASTER.initialize();
</script>
