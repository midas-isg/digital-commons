/*
	Forest Widget
*/

"use strict";

var FOREST_WIDGET_CREATOR =
    (function() {
        var checkedBox = "included",
            boldCheck = "selected",
            straightPipe = "&#9475;",
            pipeSpace = "&emsp;",
            LPipe = "&#9494;",
            forkPipe = "&#9507;",
            spacer = "&emsp;",
            ascendantIcon = "<div class='ancestors'><span>Ancestors</span></div>",
            descendantIcon = "<div class='descendants'><span class='ancestors'>" + spacer + "</span><span>Descendants</span></div>",
            selfIcon = "<div class='self'><span class='ancestors'>" + spacer + "</span><span class='descendants'>" + spacer + "</span><span>Self</span></div>";

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
                parentNode.ancestorsInput.checked = truth;

                if(truth) {
                    parentNode.rowDiv.classList.add(checkedBox);
                }
                else if(!parentNode.descendantsInput.checked) {
                    parentNode.rowDiv.classList.remove(checkedBox);
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
                currentNode.descendantsInput.checked = truth;

                if(truth) {
                    currentNode.rowDiv.classList.add(checkedBox);
                }
                else  if(!currentNode.ancestorsInput.checked) {
                    currentNode.rowDiv.classList.remove(checkedBox);
                }

                for(i = 0; i < currentNode.data.children.length; i++) {
                    queue.push(currentNode.data.children[i]);
                }
            }

            return;
        }

        function applyToAllNodes(forest, method) {
            var toVisit = [],
                currentNode,
                i,
                j;

            for(i = 0; i < forest.length; i++) {
                toVisit.push(forest[i]);
            }

            while(toVisit.length > 0) {
                currentNode = toVisit.shift();

                method(currentNode);

                for(j = 0; j < currentNode.data.children.length; j++) {
                    toVisit.push(currentNode.data.children[j]);
                }
            }

            return;
        }

        function createCheckboxes(node, dataInstance) {
            var i,
                ancestorSpan = document.createElement("span"),
                descendantSpan = document.createElement("span"),
                selfSpan = document.createElement("span");

            ancestorSpan.classList = "ancestors";
            descendantSpan.classList = "descendants";
            selfSpan.classList = "self";

            node.span = document.createElement("span");

            node.rowDiv = document.createElement("div");
            node.spanDiv = document.createElement("div");
            node.inputDiv = document.createElement("div");

            node.inputDiv.classList.add("checkbox-div");
            node.spanDiv.classList.add("span-div");

            node.ancestorsInput = document.createElement("input");
            node.ancestorsInput.hidden = dataInstance.headerBody.hidden;
            node.descendantsInput = document.createElement("input");
            node.descendantsInput.hidden = dataInstance.headerBody.hidden;
            node.selfInput = document.createElement("input");

            node.span.innerHTML = node.data.label;

            function enlistCurrentNode() {
                for(i = 0; i < dataInstance.userSelectedNodes.length; i++) {
                    if(dataInstance.userSelectedNodes[i] === node.data) {
                        return;
                    }
                }

                dataInstance.userSelectedNodes.push(node.data);

                return;
            }

            function delistCurrentNode() {
                for(i = 0; i < dataInstance.userSelectedNodes.length; i++) {
                    if(dataInstance.userSelectedNodes[i] === node.data) {
                        dataInstance.userSelectedNodes.splice(i, 1);
                        break;
                    }
                }

                return;
            }

            node.ancestorsInput.type = "checkbox";
            node.ancestorsInput.disabled = true;
            node.ancestorsInput.onchange = function() {
                node.data.includeAncestors = node.ancestorsInput.checked;
                toggleAncestors(node, node.data.includeAncestors);

                if(node.data.includeAncestors) {
                    enlistCurrentNode();
                }
                else if((!node.data.userSelected) && (!node.data.includeDescendants)) {
                    delistCurrentNode();
                }

                return;
            }

            node.descendantsInput.type = "checkbox";
            node.descendantsInput.disabled = true;
            node.descendantsInput.onchange = function() {
                node.data.includeDescendants = node.descendantsInput.checked;
                toggleDescendants(node, node.data.includeDescendants);

                if(node.data.includeDescendants) {
                    enlistCurrentNode();
                }
                else if((!node.data.userSelected) && (!node.data.includeAncestors)) {
                    delistCurrentNode();
                }

                return;
            }

            node.selfInput.id = "node-" + node.data.id;
            node.selfInput.type = "checkbox";
            node.selfInput.value = node.data.id;
            node.selfInput.onchange = function() {
                node.data.userSelected = this.checked;

                if(node.data.userSelected) {
                    enlistCurrentNode();
                    node.rowDiv.classList.add(boldCheck);
                }
                else if((!node.data.includeAncestors) && (!node.data.includeDescendants)) {
                    delistCurrentNode();
                    node.rowDiv.classList.remove(boldCheck);
                }

                return;
            }

            ancestorSpan.appendChild(node.ancestorsInput);
            descendantSpan.appendChild(node.descendantsInput);
            selfSpan.appendChild(node.selfInput);
            node.inputDiv.appendChild(ancestorSpan);
            node.inputDiv.appendChild(descendantSpan);
            node.inputDiv.appendChild(selfSpan);

            node.spanDiv.appendChild(node.span);
            node.rowDiv.appendChild(node.inputDiv);
            node.rowDiv.appendChild(node.spanDiv);
            node.element.appendChild(node.rowDiv);

            return;
        }

        function regenerateNodeLabels(node, dataInstance) {
            var i,
                pipeArray = [],
                pipeString,
                parent,
                currentNode = node,
                toVisit = [];

            while(currentNode.data.parent) {
                currentNode = currentNode.data.parent;
            }

            if(dataInstance.forest[dataInstance.forest.length - 1] === currentNode) {
                pipeArray.push("");
            }
            else {
                pipeArray.push(straightPipe);
            }

            for(i = 0; i < currentNode.data.children.length; i++) {
                toVisit.push(currentNode.data.children[i]);
            }

            while(toVisit.length > 0) {
                currentNode = toVisit.pop();
                parent = currentNode.data.parent;

                while(pipeArray.length < (currentNode.depth + 1)) {
                    pipeArray.push(pipeSpace);
                }

                pipeString = "";
                for(i = 0; i < currentNode.depth; i++) {
                    pipeString += pipeArray[i];
                }

                if(parent.data.children[parent.data.children.length - 1] === currentNode) {
                    pipeArray[currentNode.depth] = pipeSpace;
                    currentNode.span.innerHTML = "<span>" + pipeString + LPipe + "</span>" + currentNode.data.label;
                }
                else {
                    pipeArray[currentNode.depth] = straightPipe;
                    currentNode.span.innerHTML = "<span>" + pipeString + forkPipe + "</span>" + currentNode.data.label;
                }

                for(i = 0; i < currentNode.data.children.length; i++) {
                    toVisit.push(currentNode.data.children[i]);
                }
            }

            return;
        }

        function Node(label, id, parent, dataInstance) {
            var thisNode = this;

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

            createCheckboxes(this, dataInstance);

            if(parent) {
                this.data.parent = parent;
                this.depth = parent.depth + 1;
                regenerateNodeLabels(this, dataInstance);
            }

            return;
        }

        function ForestWidget(parentElementID, width, height) {
            var thisForestWidget = this;

            (function() {
                var parentElement = document.getElementById(parentElementID),
                    widgetBody = document.createElement("div"),
                    headerBody = document.createElement("form"),
                    forestContainer = document.createElement("form"),
                    forestBody = document.createElement("div"),
                    forest = [],
                    dataInstance = {
                        userSelectedNodes: [],
                        includeAncestors: false,
                        includeDescendants: false,
                        width: width ? width: "100%",
                        height: height ? height: "100%",
                        headerBody: headerBody,
                        widgetBody: widgetBody,
                        forest: forest
                    };

                widgetBody.className = "widget-body";
                widgetBody.style.width = dataInstance.width;
                widgetBody.style.height = dataInstance.height;

                headerBody.className = "header-body";
                headerBody.hidden = true;
                headerBody.innerHTML = "<div>" + ascendantIcon + descendantIcon + selfIcon + "</div>";

                forestContainer.className = "forest-container";
                forestBody.className = "forest-body";
                forestContainer.appendChild(forestBody);

                widgetBody.appendChild(headerBody);
                widgetBody.appendChild(forestContainer);
                parentElement.appendChild(widgetBody);

                function resize() {
                    var diff = (widgetBody.offsetHeight - widgetBody.clientHeight) << 1,
                        neoSize = widgetBody.clientHeight - (headerBody.offsetHeight + diff);

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

                function displayCheckboxes(node) {
                    node.ancestorsInput.hidden = false;
                    node.descendantsInput.hidden = false;

                    return;
                }

                thisForestWidget.addNodeByReference = function(node, parent) {
                    forestBody.appendChild(node.element);

                    if(!parent) {
                        forest.push(node);
                    }
                    else {
                        node.ancestorsInput.disabled = false;
                        parent.descendantsInput.disabled = false;
                        node.data.parent = parent;
                        node.depth = parent.depth + 1;
                        parent.data.children.push(node);
                        regenerateNodeLabels(node, dataInstance);

                        parent.element.appendChild(node.element);

                        if(headerBody.hidden) {
                            headerBody.hidden = false;
                            applyToAllNodes(forest, displayCheckboxes);
                        }
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
                        node.ancestorsInput.disabled = false;
                        node.data.parent.descendantsInput.disabled = false;
                        node.data.parent.data.children.push(node);
                        regenerateNodeLabels(node, dataInstance);
                        node.data.parent.element.appendChild(node.element);

                        if(headerBody.hidden) {
                            headerBody.hidden = false;
                            applyToAllNodes(forest, displayCheckboxes);
                        }
                    }

                    resize();

                    return node;
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