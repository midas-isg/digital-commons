/*
	Forest Widget
*/

"use strict";

var FOREST_WIDGET_CREATOR =
    (function() {
        function ForestWidgetCreator() {
            return;
        }

        ForestWidgetCreator.prototype.create = function(parentElementID, width, height) {
            if(!parentElementID) {
                console.error("Failed to provide parent element ID to ForestWidgetCreator.create(parentElementID)");
                return null;
            }

            return new ForestWidget(parentElementID, width, height);
        }

        function toggleAncestors(parentNode, truth) {
            if(parentNode) {
                if(!parentNode.data.userSelected) {
                    parentNode.input.checked = truth;
                    parentNode.graphicBox.innerHTML = truth ? "&#9745;": "&#9744;";
                }

                if(parentNode.data.parent) {
                    return toggleAncestors(parentNode.data.parent, truth);
                }
            }

            return;
        }

        function toggleDescendants(node, truth) {
            var i,
                queue = [],
                currentNode;

            queue.push(node);

            while(queue.length > 0) {
                currentNode = queue.shift();

                if(!currentNode.data.userSelected) {
                    currentNode.input.checked = truth;
                    currentNode.graphicBox.innerHTML = truth ? "&#9745;": "&#9744;";
                }

                for(i = 0; i < currentNode.data.children.length; i++) {
                    queue.push(currentNode.data.children[i]);
                }
            }

            return;
        }


        function Node(label, id, parent, dataInstance) {
            var thisNode = this,
                span,
                i;

            this.input;
            this.depth = 0;

            this.data = {
                id: -1,
                label: label,
                parent: null,
                children: [],
                userSelected: false,
                includeAncestors: false,
                includeDescendants: false
            };

            if(id) {
                this.data.id = id;
            }

            this.element = document.createElement("div");
            this.element.className = "node";
            this.element.style.width = "100%";

            if(parent) {
                this.data.parent = parent;
                this.depth = parent.depth + 15;
                this.element.style.textIndent = this.depth + "px";
            }

            this.input = document.createElement("input");
            this.input.id = "node-" + this.data.id;
            this.input.type = "checkbox";
            this.input.style.display = "none";
            this.input.onchange = function() {
                thisNode.data.userSelected = this.checked;
                thisNode.data.includeAncestors = dataInstance.includeAncestors;
                thisNode.data.includeDescendants = dataInstance.includeDescendants;

                if(thisNode.data.includeAncestors) {
                    toggleAncestors(thisNode.data.parent, thisNode.data.userSelected);
                }

                if(thisNode.data.includeDescendants) {
                    toggleDescendants(thisNode, thisNode.data.userSelected);
                }

                if(thisNode.data.userSelected) {
                    thisNode.graphicBox.innerHTML = "&#9949;";
                    thisNode.graphicBox.style.fontWeight = "900";

                    for(i = 0; i < dataInstance.userSelectedNodes.length; i++) {
                        if(dataInstance.userSelectedNodes[i] === thisNode.data) {
                            return;
                        }
                    }

                    dataInstance.userSelectedNodes.push(thisNode.data);
                }
                else {
                    thisNode.graphicBox.innerHTML = "&#9744;";
                    thisNode.graphicBox.style.fontWeight = "100";

                    thisNode.data.includeAncestors = dataInstance.includeAncestors;
                    thisNode.data.includeDescendants = dataInstance.includeDescendants;

                    for(i = 0; i < dataInstance.userSelectedNodes.length; i++) {
                        if(dataInstance.userSelectedNodes[i] === thisNode.data) {
                            dataInstance.userSelectedNodes.splice(i, 1);
                            break;
                        }
                    }
                }

                return;
            }

            span = document.createElement("span");
            span.innerHTML = this.data.label;

            this.graphicBox = document.createElement("label");
            this.graphicBox.style.margin = "3px 3px 3px 4px";
            this.graphicBox.innerHTML = "&#9744;";
            this.graphicBox.style.fontWeight = "100";
            this.graphicBox.onclick = function() {
                thisNode.input.checked = !thisNode.input.checked;
                thisNode.input.onchange();
            };

            this.element.appendChild(this.input);
            this.element.appendChild(this.graphicBox);
            this.element.appendChild(span);

            return;
        }

        function ForestWidget(parentElementID, width, height) {
            var thisForestWidget = this;

            (function() {
                var parentElement = document.getElementById(parentElementID),
                    widgetBody = document.createElement("div"),
                    forestContainer = document.createElement("form"),
                    forestBody = document.createElement("div"),
                    optionsBody = document.createElement("form"),
                    forest = [],
                    dataInstance = {
                        userSelectedNodes: [],
                        includeAncestors: false,
                        includeDescendants: false,
                        width: width ? width: "auto",
                        height: height ? height: "auto",
                        widgetBody: widgetBody,
                        optionsBody: optionsBody,
                        forestContainer: forestContainer
                    };

                widgetBody.className = "widget-body";
                forestContainer.className = "forest-container";
                forestBody.className = "forest-body";
                optionsBody.className = "options-body";

                widgetBody.style.width = "auto";

                if(width) {
                    widgetBody.style.width = width;
                }

                if(height) {
                    widgetBody.style.height = height;
                }

                widgetBody.style.boxSizing = "border-box";

                optionsBody.style.width = "100%";

                forestContainer.style.width = "100%";
                forestContainer.style.overflowX = "auto";
                forestContainer.style.overflowY = "auto";

                function createCheckbox(value, label) {
                    var div = document.createElement("div"),
                        input = document.createElement("input"),
                        span;

                    input.type = "checkbox";
                    input.value = value;

                    if(value === "ancestors") {
                        input.onchange = function() {
                            dataInstance.includeAncestors = input.checked;

                            return;
                        };
                    }
                    else {
                        input.onchange = function() {
                            dataInstance.includeDescendants = input.checked;

                            return;
                        };
                    }

                    div.appendChild(input);
                    span = document.createElement("span");
                    span.innerHTML = label;
                    div.appendChild(span);

                    return div;
                }

                optionsBody.appendChild(createCheckbox("ancestors", "Include ancestors"));
                optionsBody.appendChild(createCheckbox("descendants", "Include descendants"));

                widgetBody.appendChild(optionsBody);
                forestContainer.appendChild(forestBody);
                widgetBody.appendChild(forestContainer);
                parentElement.appendChild(widgetBody);

                function resize() {
                    if(dataInstance.width != "auto") {
                        //TODO: get proper width
                        forestBody.style.width = (document.getElementsByTagName("body")[0].clientWidth >> 2) + "px";
                    }

                    if(dataInstance.height != "auto") {
                        forestContainer.style.height = (widgetBody.clientHeight - (optionsBody.offsetHeight + 8)) + "px";
                    }

                    return;
                }

                thisForestWidget.createNode = function(node) {
                    if(node.id) {
                        return new Node(node.label, node.id, node.parent, dataInstance);
                    }

                    return new Node(node, null, null, dataInstance);
                }

                thisForestWidget.addNodeByReference = function(node, parent) {
                    forestBody.appendChild(node.element);

                    if(!parent) {
                        forest.push(node);
                    }
                    else {
                        node.data.parent = parent;
                        node.depth = parent.depth + 15;
                        node.element.style.textIndent = node.depth + "px";
                        parent.data.children.push(node);
                        parent.element.appendChild(node.element);
                    }

                    resize();

                    return;
                }

                thisForestWidget.addNode = function(input) {
                    var node = thisForestWidget.createNode(input);

                    forestBody.appendChild(node.element);

                    if(!node.data.parent) {
                        forest.push(node);
                    }
                    else {
                        node.data.parent.data.children.push(node);
                        node.data.parent.element.appendChild(node.element);
                    }

                    resize();

                    return node;
                }

                thisForestWidget.getModes = function() {
                    return {"includeAncestors": dataInstance.includeAncestors, "includeDescendants": dataInstance.includeDescendants};
                }

                thisForestWidget.getUserSelectedNodes = function() {
                    return dataInstance.userSelectedNodes;
                }

                return;
            })();

            return;
        }

        return new ForestWidgetCreator();
    })();