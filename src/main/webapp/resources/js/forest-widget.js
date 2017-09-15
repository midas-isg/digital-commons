/*
 Forest Widget
 */

"use strict";

var FOREST_WIDGET_CREATOR =
    (function() {
        var ballotBox = "inherit",
            checkedBox = "#AAAAFF",
            boldCheck = "#AAFFAA";

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
                    parentNode.span.style.backgroundColor = truth ? checkedBox: ballotBox;
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
                    currentNode.span.style.backgroundColor = truth ? checkedBox: ballotBox;
                }

                for(i = 0; i < currentNode.data.children.length; i++) {
                    queue.push(currentNode.data.children[i]);
                }
            }

            return;
        }

        function Node(label, id, parent, dataInstance) {
            var thisNode = this,
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

            if(parent) {
                this.data.parent = parent;
                this.depth = parent.depth + 15;
                this.element.style.textIndent = this.depth + "px";
            }

            this.input = document.createElement("input");
            this.input.id = "node-" + this.data.id;
            this.input.type = "checkbox";
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
                    thisNode.span.style.backgroundColor = boldCheck;

                    for(i = 0; i < dataInstance.userSelectedNodes.length; i++) {
                        if(dataInstance.userSelectedNodes[i] === thisNode.data) {
                            return;
                        }
                    }

                    dataInstance.userSelectedNodes.push(thisNode.data);
                }
                else {
                    thisNode.span.style.backgroundColor = ballotBox;

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

            this.span = document.createElement("span");
            this.span.innerHTML = this.data.label;

            this.span.style.backgroundColor = ballotBox;

            this.element.appendChild(this.input);
            this.element.appendChild(this.span);

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
                        width: width ? width: "100%",
                        height: height ? height: "100%",
                        widgetBody: widgetBody,
                        optionsBody: optionsBody,
                        forestContainer: forestContainer
                    };

                widgetBody.className = "widget-body";
                forestContainer.className = "forest-container";
                forestBody.className = "forest-body";
                optionsBody.className = "options-body";

                widgetBody.style.width = dataInstance.width;
                widgetBody.style.height = dataInstance.height;

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
                    var diff = (widgetBody.offsetHeight - widgetBody.clientHeight) << 1,
                        neoSize = widgetBody.clientHeight - (optionsBody.offsetHeight + diff);

                    forestContainer.style.height = neoSize + "px";

                    return;
                }

                window.addEventListener("resize", resize);

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