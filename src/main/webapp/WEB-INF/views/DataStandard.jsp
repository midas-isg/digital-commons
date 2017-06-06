<html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<head>
    <base href='.'>
    <link rel='stylesheet' type='text/css' href='${pageContext.request.contextPath}/resources/css/main.css'>
    <link rel='stylesheet' href='${pageContext.request.contextPath}/resources/css/bootstrap/3.3.6/bootstrap.min.css'>
    <link rel='stylesheet'
          href='${pageContext.request.contextPath}/resources/css/bootstrap-treeview/1.2.0/bootstrap-treeview.min.css'>
    <link rel='stylesheet'
          href='${pageContext.request.contextPath}/resources/css/font-awesome-4.7.0/css/font-awesome.min.css'>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/xsd-forms/css/xsd-forms-style.css"
          type="text/css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/xsd-forms/css/xsd-forms-style-override.css"
          type="text/css"/>
    <link type="text/css"
          href="${pageContext.request.contextPath}/resources/xsd-forms/css/smoothness/jquery-ui-1.8.16.custom.css"
          rel="stylesheet"/>
    <link type="text/css" href="${pageContext.request.contextPath}/resources/xsd-forms/css/timepicker.css"
          rel="stylesheet"/>
    <style type="text/css">
        
    </style>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/xsd-forms/js/jquery-1.6.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/xsd-forms/js/jquery-ui-1.8.16.custom.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/xsd-forms/js/jquery-ui-timepicker-addon.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/xsd-forms/js/xml2json.js"></script>
    

    <script type="text/javascript">

        function encodeHTML(s) {
            if (typeof(s) != "undefined")
                return s.replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;');
            else
                return s;
        }

        function testEncodeHTML() {
            test('&lt;&gt;' == encodeHTML('<>'), "angle brackets encoded")
        }

        function test(condition, message) {
            if (!condition) alert(message);
        }

        function encodedValueById(id) {
            return encodeHTML($("#"+id).val());
        }

        function spaces(n) {
            var s = "";
            for (var i=0;i<n;i++)
                s = s + " ";
            return s;
        }

        function cloneAndReplaceIds(element, suffix){
            var clone = element.clone();
            clone.find("*[id]").andSelf().each(function() {
                var previousId = $(this).attr("id");
                var newId = previousId.replace(/(-[0-9][0-9]*)$/,"$1" + suffix);
                $(this).attr("id", newId);
            });
            return clone;
        }

        function idVisible(id) {
            return elemVisible($("#"+id));
        }

        function elemVisible(elem) {
            return elem.is(":visible");
        }

        function toXmlDate(s) {
            return s;
        }

        function toXmlDateTime(s) {
            return $.trim(s) +":00";
        }

        function toXmlTime(s) {
            return $.trim(s) +":00";
        }

        function toBoolean(s) {
            if (s)
                return "true";
            else
                return "false";
        }

        function postXml(url) {
            return function(xml) {
                var data = new Object();
                data.xml = xml;
                //disable submit button
                $('#submit').hide();
                $.ajax({
                    type: 'POST',
                    url: url,
                    data: data,
                    success:
                        function (dat,textStatus,jqXHR) {
                            $('#submit').hide();
                        },
                    error:
                        function (jqXHR,textStatus,errorThrown) {
                            alert(textStatus + '\n'+ errorThrown);
                            $('#submit').show();
                        },
                    async:false
                });
            };
        }

        function toJson(xml) {
            var x2js = new X2JS();
            var json = x2js.xml_str2json(xml);
            return JSON.stringify(json);
        }

        function showChoiceItem(elem) {
            elem.show();
            elem.find('.item-path').attr('enabled','true');
        }

        function hideChoiceItem(elem) {
            elem.hide();
            elem.find('.item-path').attr('enabled','false');
        }

        $(function() {
            //run js unit tests
            testEncodeHTML();

            //setup date and time pickers
            $('input').filter('.datepickerclass').datepicker();
            //now a workaround because datepicker does not use the initial value with the required format but expects mm/dd/yyyy
            $('input').filter('.datepickerclass').each(function() {
                var elem = $(this);
                var val = elem.attr('value');
                elem.datepicker( "option", "dateFormat","yy-mm-dd");
                if (typeof(val) != 'undefined') {
                    elem.datepicker('setDate',val);
                }
            });
            $('input').filter('.datetimepickerclass').datetimepicker({ dateFormat: 'yy-mm-dd', timeFormat: 'hh:mm',separator: 'T'});
            $('input').filter('.timepickerclass').timepicker({});

            function callMethod(methodName, argument) {
                var method = eval('(' + methodName + ')');
                return method(argument);
            }

            function changeMinOccursZeroCheckbox(v,enclosing) {
                if (v.is(':checked')) {
                    enclosing.find(':input').prop('disabled',false);
                    enclosing.find('.min-occurs-zero').prop('checked',true)
                } else {
                    enclosing.find(':input').prop('disabled',true);
                    enclosing.find('.min-occurs-zero').prop('checked',false)
                }
            }

            function matchesPattern(elem,regex) {
                return regex.test(elem.val());
            }

            function showError(id,ok) {
                var error = $("#"+id);
                if (ok)
                    error.hide();
                else
                    error.show();
            }

            function validate() {
                var previousItems = null;
                $('*[number]').each( function(index) {
                    var thisId = this.id
                    var elem = $('#' + thisId)
                    // will do validations here
                    //if elem visible then do the validation for that element
                    if (elemVisible(elem))
                        elem.change();
                });
                $('input:radio').each( function (index) {
                    var elem = $('#' + this.id)
                    if (elemVisible(elem))
                        elem.change();
                });
                var count = $('.item-error').filter(":visible").length
                if (count>0) {
                    $('#validation-errors').show();
                    return false;
                }
                else {
                    $('#validation-errors').hide();
                    return true;
                }
            }

            function getXml() {
                return "<?xml version=\"1.0\" encoding=\"utf-8\"?>" +  getXml1instance();
            }

            $('#submit').click( function () {
                if (validate()) {
                    var xml = getXml();
                    processXml(xml);
                }
            });

            var processXml = function(xml) {
                var s = xml.replace(/&/g,"&amp;");
                s = s.replace(/</g,"&lt;").replace(/>/g,"&gt;");
                s = "<pre>" + s + "</pre>";
                $('#submit-comments').html(s);
            }

            
  $('#remove-button-1-instance-1').click(function() {
    $('#repeating-enclosing-1-instance-1').hide();
  });

  $('#remove-button-2-instance-1_1').click(function() {
    $('#repeating-enclosing-2-instance-1_1').hide();
  });

  $('#remove-button-3-instance-1_1_1').click(function() {
    $('#repeating-enclosing-3-instance-1_1_1').hide();
  });

  $('#item-3-instance-1_1_1').prop('checked',false);

  // identifier
  var validate3instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-3-instance-1_1_1');
    var pathDiv = $('#item-path-3-instance-1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-3-instance-1_1_1').change( function() {
    var ok = validate3instance1_1_1();
    showError('item-error-3-instance-1_1_1',ok);
  });
  
  $('#remove-button-4-instance-1_1_1').click(function() {
    $('#repeating-enclosing-4-instance-1_1_1').hide();
  });

  $('#item-4-instance-1_1_1').prop('checked',false);

  // identifierSource
  var validate4instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-4-instance-1_1_1');
    var pathDiv = $('#item-path-4-instance-1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-4-instance-1_1_1').change( function() {
    var ok = validate4instance1_1_1();
    showError('item-error-4-instance-1_1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-4-instance-1_1_1').attr('enabled','false');
  $('#repeat-button-4-instance-1_1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-4-instance-1_1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-5-instance-1_1').click(function() {
    $('#repeating-enclosing-5-instance-1_1').hide();
  });

  $('#item-5-instance-1_1').prop('checked',false);

  // name
  var validate5instance1_1 = function () {
    var ok = true;
    var v = $('#item-5-instance-1_1');
    var pathDiv = $('#item-path-5-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-5-instance-1_1').change( function() {
    var ok = validate5instance1_1();
    showError('item-error-5-instance-1_1',ok);
  });
  
  $('#remove-button-6-instance-1_1').click(function() {
    $('#repeating-enclosing-6-instance-1_1').hide();
  });

  $('#remove-button-7-instance-1_1_1').click(function() {
    $('#repeating-enclosing-7-instance-1_1_1').hide();
  });

  $('#item-7-instance-1_1_1').prop('checked',false);

  // value
  var validate7instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-7-instance-1_1_1');
    var pathDiv = $('#item-path-7-instance-1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-7-instance-1_1_1').change( function() {
    var ok = validate7instance1_1_1();
    showError('item-error-7-instance-1_1_1',ok);
  });
  
  $('#remove-button-8-instance-1_1_1').click(function() {
    $('#repeating-enclosing-8-instance-1_1_1').hide();
  });

  $('#item-8-instance-1_1_1').prop('checked',false);

  // valueIRI
  var validate8instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-8-instance-1_1_1');
    var pathDiv = $('#item-path-8-instance-1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-8-instance-1_1_1').change( function() {
    var ok = validate8instance1_1_1();
    showError('item-error-8-instance-1_1_1',ok);
  });
  
$('#min-occurs-zero-9-instance-1').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-9-instance-1_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-9-instance-1_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-9-instance-1_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-9-instance-1_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-9-instance-1_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-9-instance-1_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-9-instance-1_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-9-instance-1_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-9-instance-1_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-9-instance-1_10'));
})

$('#min-occurs-zero-9-instance-1').change();
  $('#remove-button-9-instance-1_1').click(function() {
    $('#repeating-enclosing-9-instance-1_1').hide();
  });

  $('#remove-button-10-instance-1_1_1').click(function() {
    $('#repeating-enclosing-10-instance-1_1_1').hide();
  });

  $('#item-10-instance-1_1_1').prop('checked',false);

  // identifier
  var validate10instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_1_1');
    var pathDiv = $('#item-path-10-instance-1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-10-instance-1_1_1').change( function() {
    var ok = validate10instance1_1_1();
    showError('item-error-10-instance-1_1_1',ok);
  });
  
  $('#remove-button-11-instance-1_1_1').click(function() {
    $('#repeating-enclosing-11-instance-1_1_1').hide();
  });

  $('#item-11-instance-1_1_1').prop('checked',false);

  // identifierSource
  var validate11instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-11-instance-1_1_1');
    var pathDiv = $('#item-path-11-instance-1_1_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-11-instance-1_1_1').change( function() {
    var ok = validate11instance1_1_1();
    showError('item-error-11-instance-1_1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-11-instance-1_1_1').attr('enabled','false');
  $('#repeat-button-11-instance-1_1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-11-instance-1_1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-12-instance-1_1_1').click(function() {
    $('#repeating-enclosing-12-instance-1_1_1').hide();
  });

  $('#item-12-instance-1_1_1').prop('checked',false);

  // version
  var validate12instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_1_1');
    var pathDiv = $('#item-path-12-instance-1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_1_1').change( function() {
    var ok = validate12instance1_1_1();
    showError('item-error-12-instance-1_1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_1_1').attr('enabled','false');
  $('#repeat-button-12-instance-1_1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-12-instance-1_1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-9-instance-1_2').click(function() {
    $('#repeating-enclosing-9-instance-1_2').hide();
  });

  $('#remove-button-10-instance-1_2_1').click(function() {
    $('#repeating-enclosing-10-instance-1_2_1').hide();
  });

  $('#item-10-instance-1_2_1').prop('checked',false);

  // identifier
  var validate10instance1_2_1 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_2_1');
    var pathDiv = $('#item-path-10-instance-1_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-10-instance-1_2_1').change( function() {
    var ok = validate10instance1_2_1();
    showError('item-error-10-instance-1_2_1',ok);
  });
  
  $('#remove-button-11-instance-1_2_1').click(function() {
    $('#repeating-enclosing-11-instance-1_2_1').hide();
  });

  $('#item-11-instance-1_2_1').prop('checked',false);

  // identifierSource
  var validate11instance1_2_1 = function () {
    var ok = true;
    var v = $('#item-11-instance-1_2_1');
    var pathDiv = $('#item-path-11-instance-1_2_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-11-instance-1_2_1').change( function() {
    var ok = validate11instance1_2_1();
    showError('item-error-11-instance-1_2_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-11-instance-1_2_1').attr('enabled','false');
  $('#repeat-button-11-instance-1_2').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-11-instance-1_2_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-12-instance-1_2_1').click(function() {
    $('#repeating-enclosing-12-instance-1_2_1').hide();
  });

  $('#item-12-instance-1_2_1').prop('checked',false);

  // version
  var validate12instance1_2_1 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_2_1');
    var pathDiv = $('#item-path-12-instance-1_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_2_1').change( function() {
    var ok = validate12instance1_2_1();
    showError('item-error-12-instance-1_2_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_2_1').attr('enabled','false');
  $('#repeat-button-12-instance-1_2').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-12-instance-1_2_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-9-instance-1_3').click(function() {
    $('#repeating-enclosing-9-instance-1_3').hide();
  });

  $('#remove-button-10-instance-1_3_1').click(function() {
    $('#repeating-enclosing-10-instance-1_3_1').hide();
  });

  $('#item-10-instance-1_3_1').prop('checked',false);

  // identifier
  var validate10instance1_3_1 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_3_1');
    var pathDiv = $('#item-path-10-instance-1_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-10-instance-1_3_1').change( function() {
    var ok = validate10instance1_3_1();
    showError('item-error-10-instance-1_3_1',ok);
  });
  
  $('#remove-button-11-instance-1_3_1').click(function() {
    $('#repeating-enclosing-11-instance-1_3_1').hide();
  });

  $('#item-11-instance-1_3_1').prop('checked',false);

  // identifierSource
  var validate11instance1_3_1 = function () {
    var ok = true;
    var v = $('#item-11-instance-1_3_1');
    var pathDiv = $('#item-path-11-instance-1_3_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-11-instance-1_3_1').change( function() {
    var ok = validate11instance1_3_1();
    showError('item-error-11-instance-1_3_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-11-instance-1_3_1').attr('enabled','false');
  $('#repeat-button-11-instance-1_3').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-11-instance-1_3_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-12-instance-1_3_1').click(function() {
    $('#repeating-enclosing-12-instance-1_3_1').hide();
  });

  $('#item-12-instance-1_3_1').prop('checked',false);

  // version
  var validate12instance1_3_1 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_3_1');
    var pathDiv = $('#item-path-12-instance-1_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_3_1').change( function() {
    var ok = validate12instance1_3_1();
    showError('item-error-12-instance-1_3_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_3_1').attr('enabled','false');
  $('#repeat-button-12-instance-1_3').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-12-instance-1_3_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-9-instance-1_4').click(function() {
    $('#repeating-enclosing-9-instance-1_4').hide();
  });

  $('#remove-button-10-instance-1_4_1').click(function() {
    $('#repeating-enclosing-10-instance-1_4_1').hide();
  });

  $('#item-10-instance-1_4_1').prop('checked',false);

  // identifier
  var validate10instance1_4_1 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_4_1');
    var pathDiv = $('#item-path-10-instance-1_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-10-instance-1_4_1').change( function() {
    var ok = validate10instance1_4_1();
    showError('item-error-10-instance-1_4_1',ok);
  });
  
  $('#remove-button-11-instance-1_4_1').click(function() {
    $('#repeating-enclosing-11-instance-1_4_1').hide();
  });

  $('#item-11-instance-1_4_1').prop('checked',false);

  // identifierSource
  var validate11instance1_4_1 = function () {
    var ok = true;
    var v = $('#item-11-instance-1_4_1');
    var pathDiv = $('#item-path-11-instance-1_4_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-11-instance-1_4_1').change( function() {
    var ok = validate11instance1_4_1();
    showError('item-error-11-instance-1_4_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-11-instance-1_4_1').attr('enabled','false');
  $('#repeat-button-11-instance-1_4').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-11-instance-1_4_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-12-instance-1_4_1').click(function() {
    $('#repeating-enclosing-12-instance-1_4_1').hide();
  });

  $('#item-12-instance-1_4_1').prop('checked',false);

  // version
  var validate12instance1_4_1 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_4_1');
    var pathDiv = $('#item-path-12-instance-1_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_4_1').change( function() {
    var ok = validate12instance1_4_1();
    showError('item-error-12-instance-1_4_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_4_1').attr('enabled','false');
  $('#repeat-button-12-instance-1_4').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-12-instance-1_4_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-9-instance-1_5').click(function() {
    $('#repeating-enclosing-9-instance-1_5').hide();
  });

  $('#remove-button-10-instance-1_5_1').click(function() {
    $('#repeating-enclosing-10-instance-1_5_1').hide();
  });

  $('#item-10-instance-1_5_1').prop('checked',false);

  // identifier
  var validate10instance1_5_1 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_5_1');
    var pathDiv = $('#item-path-10-instance-1_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-10-instance-1_5_1').change( function() {
    var ok = validate10instance1_5_1();
    showError('item-error-10-instance-1_5_1',ok);
  });
  
  $('#remove-button-11-instance-1_5_1').click(function() {
    $('#repeating-enclosing-11-instance-1_5_1').hide();
  });

  $('#item-11-instance-1_5_1').prop('checked',false);

  // identifierSource
  var validate11instance1_5_1 = function () {
    var ok = true;
    var v = $('#item-11-instance-1_5_1');
    var pathDiv = $('#item-path-11-instance-1_5_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-11-instance-1_5_1').change( function() {
    var ok = validate11instance1_5_1();
    showError('item-error-11-instance-1_5_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-11-instance-1_5_1').attr('enabled','false');
  $('#repeat-button-11-instance-1_5').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-11-instance-1_5_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-12-instance-1_5_1').click(function() {
    $('#repeating-enclosing-12-instance-1_5_1').hide();
  });

  $('#item-12-instance-1_5_1').prop('checked',false);

  // version
  var validate12instance1_5_1 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_5_1');
    var pathDiv = $('#item-path-12-instance-1_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_5_1').change( function() {
    var ok = validate12instance1_5_1();
    showError('item-error-12-instance-1_5_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_5_1').attr('enabled','false');
  $('#repeat-button-12-instance-1_5').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-12-instance-1_5_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-9-instance-1_6').click(function() {
    $('#repeating-enclosing-9-instance-1_6').hide();
  });

  $('#remove-button-10-instance-1_6_1').click(function() {
    $('#repeating-enclosing-10-instance-1_6_1').hide();
  });

  $('#item-10-instance-1_6_1').prop('checked',false);

  // identifier
  var validate10instance1_6_1 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_6_1');
    var pathDiv = $('#item-path-10-instance-1_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-10-instance-1_6_1').change( function() {
    var ok = validate10instance1_6_1();
    showError('item-error-10-instance-1_6_1',ok);
  });
  
  $('#remove-button-11-instance-1_6_1').click(function() {
    $('#repeating-enclosing-11-instance-1_6_1').hide();
  });

  $('#item-11-instance-1_6_1').prop('checked',false);

  // identifierSource
  var validate11instance1_6_1 = function () {
    var ok = true;
    var v = $('#item-11-instance-1_6_1');
    var pathDiv = $('#item-path-11-instance-1_6_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-11-instance-1_6_1').change( function() {
    var ok = validate11instance1_6_1();
    showError('item-error-11-instance-1_6_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-11-instance-1_6_1').attr('enabled','false');
  $('#repeat-button-11-instance-1_6').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-11-instance-1_6_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-12-instance-1_6_1').click(function() {
    $('#repeating-enclosing-12-instance-1_6_1').hide();
  });

  $('#item-12-instance-1_6_1').prop('checked',false);

  // version
  var validate12instance1_6_1 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_6_1');
    var pathDiv = $('#item-path-12-instance-1_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_6_1').change( function() {
    var ok = validate12instance1_6_1();
    showError('item-error-12-instance-1_6_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_6_1').attr('enabled','false');
  $('#repeat-button-12-instance-1_6').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-12-instance-1_6_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-9-instance-1_7').click(function() {
    $('#repeating-enclosing-9-instance-1_7').hide();
  });

  $('#remove-button-10-instance-1_7_1').click(function() {
    $('#repeating-enclosing-10-instance-1_7_1').hide();
  });

  $('#item-10-instance-1_7_1').prop('checked',false);

  // identifier
  var validate10instance1_7_1 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_7_1');
    var pathDiv = $('#item-path-10-instance-1_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-10-instance-1_7_1').change( function() {
    var ok = validate10instance1_7_1();
    showError('item-error-10-instance-1_7_1',ok);
  });
  
  $('#remove-button-11-instance-1_7_1').click(function() {
    $('#repeating-enclosing-11-instance-1_7_1').hide();
  });

  $('#item-11-instance-1_7_1').prop('checked',false);

  // identifierSource
  var validate11instance1_7_1 = function () {
    var ok = true;
    var v = $('#item-11-instance-1_7_1');
    var pathDiv = $('#item-path-11-instance-1_7_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-11-instance-1_7_1').change( function() {
    var ok = validate11instance1_7_1();
    showError('item-error-11-instance-1_7_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-11-instance-1_7_1').attr('enabled','false');
  $('#repeat-button-11-instance-1_7').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-11-instance-1_7_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-12-instance-1_7_1').click(function() {
    $('#repeating-enclosing-12-instance-1_7_1').hide();
  });

  $('#item-12-instance-1_7_1').prop('checked',false);

  // version
  var validate12instance1_7_1 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_7_1');
    var pathDiv = $('#item-path-12-instance-1_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_7_1').change( function() {
    var ok = validate12instance1_7_1();
    showError('item-error-12-instance-1_7_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_7_1').attr('enabled','false');
  $('#repeat-button-12-instance-1_7').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-12-instance-1_7_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-9-instance-1_8').click(function() {
    $('#repeating-enclosing-9-instance-1_8').hide();
  });

  $('#remove-button-10-instance-1_8_1').click(function() {
    $('#repeating-enclosing-10-instance-1_8_1').hide();
  });

  $('#item-10-instance-1_8_1').prop('checked',false);

  // identifier
  var validate10instance1_8_1 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_8_1');
    var pathDiv = $('#item-path-10-instance-1_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-10-instance-1_8_1').change( function() {
    var ok = validate10instance1_8_1();
    showError('item-error-10-instance-1_8_1',ok);
  });
  
  $('#remove-button-11-instance-1_8_1').click(function() {
    $('#repeating-enclosing-11-instance-1_8_1').hide();
  });

  $('#item-11-instance-1_8_1').prop('checked',false);

  // identifierSource
  var validate11instance1_8_1 = function () {
    var ok = true;
    var v = $('#item-11-instance-1_8_1');
    var pathDiv = $('#item-path-11-instance-1_8_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-11-instance-1_8_1').change( function() {
    var ok = validate11instance1_8_1();
    showError('item-error-11-instance-1_8_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-11-instance-1_8_1').attr('enabled','false');
  $('#repeat-button-11-instance-1_8').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-11-instance-1_8_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-12-instance-1_8_1').click(function() {
    $('#repeating-enclosing-12-instance-1_8_1').hide();
  });

  $('#item-12-instance-1_8_1').prop('checked',false);

  // version
  var validate12instance1_8_1 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_8_1');
    var pathDiv = $('#item-path-12-instance-1_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_8_1').change( function() {
    var ok = validate12instance1_8_1();
    showError('item-error-12-instance-1_8_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_8_1').attr('enabled','false');
  $('#repeat-button-12-instance-1_8').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-12-instance-1_8_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-9-instance-1_9').click(function() {
    $('#repeating-enclosing-9-instance-1_9').hide();
  });

  $('#remove-button-10-instance-1_9_1').click(function() {
    $('#repeating-enclosing-10-instance-1_9_1').hide();
  });

  $('#item-10-instance-1_9_1').prop('checked',false);

  // identifier
  var validate10instance1_9_1 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_9_1');
    var pathDiv = $('#item-path-10-instance-1_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-10-instance-1_9_1').change( function() {
    var ok = validate10instance1_9_1();
    showError('item-error-10-instance-1_9_1',ok);
  });
  
  $('#remove-button-11-instance-1_9_1').click(function() {
    $('#repeating-enclosing-11-instance-1_9_1').hide();
  });

  $('#item-11-instance-1_9_1').prop('checked',false);

  // identifierSource
  var validate11instance1_9_1 = function () {
    var ok = true;
    var v = $('#item-11-instance-1_9_1');
    var pathDiv = $('#item-path-11-instance-1_9_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-11-instance-1_9_1').change( function() {
    var ok = validate11instance1_9_1();
    showError('item-error-11-instance-1_9_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-11-instance-1_9_1').attr('enabled','false');
  $('#repeat-button-11-instance-1_9').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-11-instance-1_9_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-12-instance-1_9_1').click(function() {
    $('#repeating-enclosing-12-instance-1_9_1').hide();
  });

  $('#item-12-instance-1_9_1').prop('checked',false);

  // version
  var validate12instance1_9_1 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_9_1');
    var pathDiv = $('#item-path-12-instance-1_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_9_1').change( function() {
    var ok = validate12instance1_9_1();
    showError('item-error-12-instance-1_9_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_9_1').attr('enabled','false');
  $('#repeat-button-12-instance-1_9').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-12-instance-1_9_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-9-instance-1_10').click(function() {
    $('#repeating-enclosing-9-instance-1_10').hide();
  });

  $('#remove-button-10-instance-1_10_1').click(function() {
    $('#repeating-enclosing-10-instance-1_10_1').hide();
  });

  $('#item-10-instance-1_10_1').prop('checked',false);

  // identifier
  var validate10instance1_10_1 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_10_1');
    var pathDiv = $('#item-path-10-instance-1_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-10-instance-1_10_1').change( function() {
    var ok = validate10instance1_10_1();
    showError('item-error-10-instance-1_10_1',ok);
  });
  
  $('#remove-button-11-instance-1_10_1').click(function() {
    $('#repeating-enclosing-11-instance-1_10_1').hide();
  });

  $('#item-11-instance-1_10_1').prop('checked',false);

  // identifierSource
  var validate11instance1_10_1 = function () {
    var ok = true;
    var v = $('#item-11-instance-1_10_1');
    var pathDiv = $('#item-path-11-instance-1_10_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-11-instance-1_10_1').change( function() {
    var ok = validate11instance1_10_1();
    showError('item-error-11-instance-1_10_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-11-instance-1_10_1').attr('enabled','false');
  $('#repeat-button-11-instance-1_10').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-11-instance-1_10_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-12-instance-1_10_1').click(function() {
    $('#repeating-enclosing-12-instance-1_10_1').hide();
  });

  $('#item-12-instance-1_10_1').prop('checked',false);

  // version
  var validate12instance1_10_1 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_10_1');
    var pathDiv = $('#item-path-12-instance-1_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_10_1').change( function() {
    var ok = validate12instance1_10_1();
    showError('item-error-12-instance-1_10_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_10_1').attr('enabled','false');
  $('#repeat-button-12-instance-1_10').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-12-instance-1_10_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#repeat-button-9-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-9-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-9-instance-1_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-9-instance-1_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-9-instance-1_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-9-instance-1_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-9-instance-1_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-9-instance-1_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-9-instance-1_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-9-instance-1_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-9-instance-1_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-13-instance-1_1').click(function() {
    $('#repeating-enclosing-13-instance-1_1').hide();
  });

  $('#item-13-instance-1_1').prop('checked',false);

  // version
  var validate13instance1_1 = function () {
    var ok = true;
    var v = $('#item-13-instance-1_1');
    var pathDiv = $('#item-path-13-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-13-instance-1_1').change( function() {
    var ok = validate13instance1_1();
    showError('item-error-13-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-13-instance-1_1').attr('enabled','false');
  $('#repeat-button-13-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-13-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

$('#min-occurs-zero-14-instance-1').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-14-instance-1_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-14-instance-1_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-14-instance-1_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-14-instance-1_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-14-instance-1_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-14-instance-1_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-14-instance-1_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-14-instance-1_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-14-instance-1_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-14-instance-1_10'));
})

$('#min-occurs-zero-14-instance-1').change();
  $('#remove-button-14-instance-1_1').click(function() {
    $('#repeating-enclosing-14-instance-1_1').hide();
  });

  $('#remove-button-15-instance-1_1_1').click(function() {
    $('#repeating-enclosing-15-instance-1_1_1').hide();
  });

  $('#item-15-instance-1_1_1').prop('checked',false);

  // category
  var validate15instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_1_1');
    var pathDiv = $('#item-path-15-instance-1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_1_1').change( function() {
    var ok = validate15instance1_1_1();
    showError('item-error-15-instance-1_1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_1_1').attr('enabled','false');
  $('#repeat-button-15-instance-1_1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-15-instance-1_1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-16-instance-1_1_1').click(function() {
    $('#repeating-enclosing-16-instance-1_1_1').hide();
  });

  $('#item-16-instance-1_1_1').prop('checked',false);

  // categoryIRI
  var validate16instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-16-instance-1_1_1');
    var pathDiv = $('#item-path-16-instance-1_1_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-16-instance-1_1_1').change( function() {
    var ok = validate16instance1_1_1();
    showError('item-error-16-instance-1_1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-16-instance-1_1_1').attr('enabled','false');
  $('#repeat-button-16-instance-1_1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-16-instance-1_1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

$('#min-occurs-zero-17-instance-1_1').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_1_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_1_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_1_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_1_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_1_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_1_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_1_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_1_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_1_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_1_10'));
})

$('#min-occurs-zero-17-instance-1_1').change();
  $('#remove-button-17-instance-1_1_1').click(function() {
    $('#repeating-enclosing-17-instance-1_1_1').hide();
  });

  $('#remove-button-18-instance-1_1_1_1').click(function() {
    $('#repeating-enclosing-18-instance-1_1_1_1').hide();
  });

  $('#item-18-instance-1_1_1_1').prop('checked',false);

  // value
  var validate18instance1_1_1_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_1_1_1');
    var pathDiv = $('#item-path-18-instance-1_1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_1_1_1').change( function() {
    var ok = validate18instance1_1_1_1();
    showError('item-error-18-instance-1_1_1_1',ok);
  });
  
  $('#remove-button-19-instance-1_1_1_1').click(function() {
    $('#repeating-enclosing-19-instance-1_1_1_1').hide();
  });

  $('#item-19-instance-1_1_1_1').prop('checked',false);

  // valueIRI
  var validate19instance1_1_1_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_1_1_1');
    var pathDiv = $('#item-path-19-instance-1_1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_1_1_1').change( function() {
    var ok = validate19instance1_1_1_1();
    showError('item-error-19-instance-1_1_1_1',ok);
  });
  
  $('#remove-button-17-instance-1_1_2').click(function() {
    $('#repeating-enclosing-17-instance-1_1_2').hide();
  });

  $('#remove-button-18-instance-1_1_2_1').click(function() {
    $('#repeating-enclosing-18-instance-1_1_2_1').hide();
  });

  $('#item-18-instance-1_1_2_1').prop('checked',false);

  // value
  var validate18instance1_1_2_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_1_2_1');
    var pathDiv = $('#item-path-18-instance-1_1_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_1_2_1').change( function() {
    var ok = validate18instance1_1_2_1();
    showError('item-error-18-instance-1_1_2_1',ok);
  });
  
  $('#remove-button-19-instance-1_1_2_1').click(function() {
    $('#repeating-enclosing-19-instance-1_1_2_1').hide();
  });

  $('#item-19-instance-1_1_2_1').prop('checked',false);

  // valueIRI
  var validate19instance1_1_2_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_1_2_1');
    var pathDiv = $('#item-path-19-instance-1_1_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_1_2_1').change( function() {
    var ok = validate19instance1_1_2_1();
    showError('item-error-19-instance-1_1_2_1',ok);
  });
  
  $('#remove-button-17-instance-1_1_3').click(function() {
    $('#repeating-enclosing-17-instance-1_1_3').hide();
  });

  $('#remove-button-18-instance-1_1_3_1').click(function() {
    $('#repeating-enclosing-18-instance-1_1_3_1').hide();
  });

  $('#item-18-instance-1_1_3_1').prop('checked',false);

  // value
  var validate18instance1_1_3_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_1_3_1');
    var pathDiv = $('#item-path-18-instance-1_1_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_1_3_1').change( function() {
    var ok = validate18instance1_1_3_1();
    showError('item-error-18-instance-1_1_3_1',ok);
  });
  
  $('#remove-button-19-instance-1_1_3_1').click(function() {
    $('#repeating-enclosing-19-instance-1_1_3_1').hide();
  });

  $('#item-19-instance-1_1_3_1').prop('checked',false);

  // valueIRI
  var validate19instance1_1_3_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_1_3_1');
    var pathDiv = $('#item-path-19-instance-1_1_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_1_3_1').change( function() {
    var ok = validate19instance1_1_3_1();
    showError('item-error-19-instance-1_1_3_1',ok);
  });
  
  $('#remove-button-17-instance-1_1_4').click(function() {
    $('#repeating-enclosing-17-instance-1_1_4').hide();
  });

  $('#remove-button-18-instance-1_1_4_1').click(function() {
    $('#repeating-enclosing-18-instance-1_1_4_1').hide();
  });

  $('#item-18-instance-1_1_4_1').prop('checked',false);

  // value
  var validate18instance1_1_4_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_1_4_1');
    var pathDiv = $('#item-path-18-instance-1_1_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_1_4_1').change( function() {
    var ok = validate18instance1_1_4_1();
    showError('item-error-18-instance-1_1_4_1',ok);
  });
  
  $('#remove-button-19-instance-1_1_4_1').click(function() {
    $('#repeating-enclosing-19-instance-1_1_4_1').hide();
  });

  $('#item-19-instance-1_1_4_1').prop('checked',false);

  // valueIRI
  var validate19instance1_1_4_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_1_4_1');
    var pathDiv = $('#item-path-19-instance-1_1_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_1_4_1').change( function() {
    var ok = validate19instance1_1_4_1();
    showError('item-error-19-instance-1_1_4_1',ok);
  });
  
  $('#remove-button-17-instance-1_1_5').click(function() {
    $('#repeating-enclosing-17-instance-1_1_5').hide();
  });

  $('#remove-button-18-instance-1_1_5_1').click(function() {
    $('#repeating-enclosing-18-instance-1_1_5_1').hide();
  });

  $('#item-18-instance-1_1_5_1').prop('checked',false);

  // value
  var validate18instance1_1_5_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_1_5_1');
    var pathDiv = $('#item-path-18-instance-1_1_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_1_5_1').change( function() {
    var ok = validate18instance1_1_5_1();
    showError('item-error-18-instance-1_1_5_1',ok);
  });
  
  $('#remove-button-19-instance-1_1_5_1').click(function() {
    $('#repeating-enclosing-19-instance-1_1_5_1').hide();
  });

  $('#item-19-instance-1_1_5_1').prop('checked',false);

  // valueIRI
  var validate19instance1_1_5_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_1_5_1');
    var pathDiv = $('#item-path-19-instance-1_1_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_1_5_1').change( function() {
    var ok = validate19instance1_1_5_1();
    showError('item-error-19-instance-1_1_5_1',ok);
  });
  
  $('#remove-button-17-instance-1_1_6').click(function() {
    $('#repeating-enclosing-17-instance-1_1_6').hide();
  });

  $('#remove-button-18-instance-1_1_6_1').click(function() {
    $('#repeating-enclosing-18-instance-1_1_6_1').hide();
  });

  $('#item-18-instance-1_1_6_1').prop('checked',false);

  // value
  var validate18instance1_1_6_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_1_6_1');
    var pathDiv = $('#item-path-18-instance-1_1_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_1_6_1').change( function() {
    var ok = validate18instance1_1_6_1();
    showError('item-error-18-instance-1_1_6_1',ok);
  });
  
  $('#remove-button-19-instance-1_1_6_1').click(function() {
    $('#repeating-enclosing-19-instance-1_1_6_1').hide();
  });

  $('#item-19-instance-1_1_6_1').prop('checked',false);

  // valueIRI
  var validate19instance1_1_6_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_1_6_1');
    var pathDiv = $('#item-path-19-instance-1_1_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_1_6_1').change( function() {
    var ok = validate19instance1_1_6_1();
    showError('item-error-19-instance-1_1_6_1',ok);
  });
  
  $('#remove-button-17-instance-1_1_7').click(function() {
    $('#repeating-enclosing-17-instance-1_1_7').hide();
  });

  $('#remove-button-18-instance-1_1_7_1').click(function() {
    $('#repeating-enclosing-18-instance-1_1_7_1').hide();
  });

  $('#item-18-instance-1_1_7_1').prop('checked',false);

  // value
  var validate18instance1_1_7_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_1_7_1');
    var pathDiv = $('#item-path-18-instance-1_1_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_1_7_1').change( function() {
    var ok = validate18instance1_1_7_1();
    showError('item-error-18-instance-1_1_7_1',ok);
  });
  
  $('#remove-button-19-instance-1_1_7_1').click(function() {
    $('#repeating-enclosing-19-instance-1_1_7_1').hide();
  });

  $('#item-19-instance-1_1_7_1').prop('checked',false);

  // valueIRI
  var validate19instance1_1_7_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_1_7_1');
    var pathDiv = $('#item-path-19-instance-1_1_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_1_7_1').change( function() {
    var ok = validate19instance1_1_7_1();
    showError('item-error-19-instance-1_1_7_1',ok);
  });
  
  $('#remove-button-17-instance-1_1_8').click(function() {
    $('#repeating-enclosing-17-instance-1_1_8').hide();
  });

  $('#remove-button-18-instance-1_1_8_1').click(function() {
    $('#repeating-enclosing-18-instance-1_1_8_1').hide();
  });

  $('#item-18-instance-1_1_8_1').prop('checked',false);

  // value
  var validate18instance1_1_8_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_1_8_1');
    var pathDiv = $('#item-path-18-instance-1_1_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_1_8_1').change( function() {
    var ok = validate18instance1_1_8_1();
    showError('item-error-18-instance-1_1_8_1',ok);
  });
  
  $('#remove-button-19-instance-1_1_8_1').click(function() {
    $('#repeating-enclosing-19-instance-1_1_8_1').hide();
  });

  $('#item-19-instance-1_1_8_1').prop('checked',false);

  // valueIRI
  var validate19instance1_1_8_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_1_8_1');
    var pathDiv = $('#item-path-19-instance-1_1_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_1_8_1').change( function() {
    var ok = validate19instance1_1_8_1();
    showError('item-error-19-instance-1_1_8_1',ok);
  });
  
  $('#remove-button-17-instance-1_1_9').click(function() {
    $('#repeating-enclosing-17-instance-1_1_9').hide();
  });

  $('#remove-button-18-instance-1_1_9_1').click(function() {
    $('#repeating-enclosing-18-instance-1_1_9_1').hide();
  });

  $('#item-18-instance-1_1_9_1').prop('checked',false);

  // value
  var validate18instance1_1_9_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_1_9_1');
    var pathDiv = $('#item-path-18-instance-1_1_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_1_9_1').change( function() {
    var ok = validate18instance1_1_9_1();
    showError('item-error-18-instance-1_1_9_1',ok);
  });
  
  $('#remove-button-19-instance-1_1_9_1').click(function() {
    $('#repeating-enclosing-19-instance-1_1_9_1').hide();
  });

  $('#item-19-instance-1_1_9_1').prop('checked',false);

  // valueIRI
  var validate19instance1_1_9_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_1_9_1');
    var pathDiv = $('#item-path-19-instance-1_1_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_1_9_1').change( function() {
    var ok = validate19instance1_1_9_1();
    showError('item-error-19-instance-1_1_9_1',ok);
  });
  
  $('#remove-button-17-instance-1_1_10').click(function() {
    $('#repeating-enclosing-17-instance-1_1_10').hide();
  });

  $('#remove-button-18-instance-1_1_10_1').click(function() {
    $('#repeating-enclosing-18-instance-1_1_10_1').hide();
  });

  $('#item-18-instance-1_1_10_1').prop('checked',false);

  // value
  var validate18instance1_1_10_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_1_10_1');
    var pathDiv = $('#item-path-18-instance-1_1_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_1_10_1').change( function() {
    var ok = validate18instance1_1_10_1();
    showError('item-error-18-instance-1_1_10_1',ok);
  });
  
  $('#remove-button-19-instance-1_1_10_1').click(function() {
    $('#repeating-enclosing-19-instance-1_1_10_1').hide();
  });

  $('#item-19-instance-1_1_10_1').prop('checked',false);

  // valueIRI
  var validate19instance1_1_10_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_1_10_1');
    var pathDiv = $('#item-path-19-instance-1_1_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_1_10_1').change( function() {
    var ok = validate19instance1_1_10_1();
    showError('item-error-19-instance-1_1_10_1',ok);
  });
  
  $('#repeat-button-17-instance-1_1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-17-instance-1_1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_1_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_1_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_1_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_1_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_1_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_1_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_1_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_1_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_1_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-14-instance-1_2').click(function() {
    $('#repeating-enclosing-14-instance-1_2').hide();
  });

  $('#remove-button-15-instance-1_2_1').click(function() {
    $('#repeating-enclosing-15-instance-1_2_1').hide();
  });

  $('#item-15-instance-1_2_1').prop('checked',false);

  // category
  var validate15instance1_2_1 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_2_1');
    var pathDiv = $('#item-path-15-instance-1_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_2_1').change( function() {
    var ok = validate15instance1_2_1();
    showError('item-error-15-instance-1_2_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_2_1').attr('enabled','false');
  $('#repeat-button-15-instance-1_2').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-15-instance-1_2_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-16-instance-1_2_1').click(function() {
    $('#repeating-enclosing-16-instance-1_2_1').hide();
  });

  $('#item-16-instance-1_2_1').prop('checked',false);

  // categoryIRI
  var validate16instance1_2_1 = function () {
    var ok = true;
    var v = $('#item-16-instance-1_2_1');
    var pathDiv = $('#item-path-16-instance-1_2_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-16-instance-1_2_1').change( function() {
    var ok = validate16instance1_2_1();
    showError('item-error-16-instance-1_2_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-16-instance-1_2_1').attr('enabled','false');
  $('#repeat-button-16-instance-1_2').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-16-instance-1_2_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

$('#min-occurs-zero-17-instance-1_2').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_2_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_2_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_2_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_2_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_2_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_2_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_2_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_2_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_2_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_2_10'));
})

$('#min-occurs-zero-17-instance-1_2').change();
  $('#remove-button-17-instance-1_2_1').click(function() {
    $('#repeating-enclosing-17-instance-1_2_1').hide();
  });

  $('#remove-button-18-instance-1_2_1_1').click(function() {
    $('#repeating-enclosing-18-instance-1_2_1_1').hide();
  });

  $('#item-18-instance-1_2_1_1').prop('checked',false);

  // value
  var validate18instance1_2_1_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_2_1_1');
    var pathDiv = $('#item-path-18-instance-1_2_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_2_1_1').change( function() {
    var ok = validate18instance1_2_1_1();
    showError('item-error-18-instance-1_2_1_1',ok);
  });
  
  $('#remove-button-19-instance-1_2_1_1').click(function() {
    $('#repeating-enclosing-19-instance-1_2_1_1').hide();
  });

  $('#item-19-instance-1_2_1_1').prop('checked',false);

  // valueIRI
  var validate19instance1_2_1_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_2_1_1');
    var pathDiv = $('#item-path-19-instance-1_2_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_2_1_1').change( function() {
    var ok = validate19instance1_2_1_1();
    showError('item-error-19-instance-1_2_1_1',ok);
  });
  
  $('#remove-button-17-instance-1_2_2').click(function() {
    $('#repeating-enclosing-17-instance-1_2_2').hide();
  });

  $('#remove-button-18-instance-1_2_2_1').click(function() {
    $('#repeating-enclosing-18-instance-1_2_2_1').hide();
  });

  $('#item-18-instance-1_2_2_1').prop('checked',false);

  // value
  var validate18instance1_2_2_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_2_2_1');
    var pathDiv = $('#item-path-18-instance-1_2_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_2_2_1').change( function() {
    var ok = validate18instance1_2_2_1();
    showError('item-error-18-instance-1_2_2_1',ok);
  });
  
  $('#remove-button-19-instance-1_2_2_1').click(function() {
    $('#repeating-enclosing-19-instance-1_2_2_1').hide();
  });

  $('#item-19-instance-1_2_2_1').prop('checked',false);

  // valueIRI
  var validate19instance1_2_2_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_2_2_1');
    var pathDiv = $('#item-path-19-instance-1_2_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_2_2_1').change( function() {
    var ok = validate19instance1_2_2_1();
    showError('item-error-19-instance-1_2_2_1',ok);
  });
  
  $('#remove-button-17-instance-1_2_3').click(function() {
    $('#repeating-enclosing-17-instance-1_2_3').hide();
  });

  $('#remove-button-18-instance-1_2_3_1').click(function() {
    $('#repeating-enclosing-18-instance-1_2_3_1').hide();
  });

  $('#item-18-instance-1_2_3_1').prop('checked',false);

  // value
  var validate18instance1_2_3_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_2_3_1');
    var pathDiv = $('#item-path-18-instance-1_2_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_2_3_1').change( function() {
    var ok = validate18instance1_2_3_1();
    showError('item-error-18-instance-1_2_3_1',ok);
  });
  
  $('#remove-button-19-instance-1_2_3_1').click(function() {
    $('#repeating-enclosing-19-instance-1_2_3_1').hide();
  });

  $('#item-19-instance-1_2_3_1').prop('checked',false);

  // valueIRI
  var validate19instance1_2_3_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_2_3_1');
    var pathDiv = $('#item-path-19-instance-1_2_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_2_3_1').change( function() {
    var ok = validate19instance1_2_3_1();
    showError('item-error-19-instance-1_2_3_1',ok);
  });
  
  $('#remove-button-17-instance-1_2_4').click(function() {
    $('#repeating-enclosing-17-instance-1_2_4').hide();
  });

  $('#remove-button-18-instance-1_2_4_1').click(function() {
    $('#repeating-enclosing-18-instance-1_2_4_1').hide();
  });

  $('#item-18-instance-1_2_4_1').prop('checked',false);

  // value
  var validate18instance1_2_4_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_2_4_1');
    var pathDiv = $('#item-path-18-instance-1_2_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_2_4_1').change( function() {
    var ok = validate18instance1_2_4_1();
    showError('item-error-18-instance-1_2_4_1',ok);
  });
  
  $('#remove-button-19-instance-1_2_4_1').click(function() {
    $('#repeating-enclosing-19-instance-1_2_4_1').hide();
  });

  $('#item-19-instance-1_2_4_1').prop('checked',false);

  // valueIRI
  var validate19instance1_2_4_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_2_4_1');
    var pathDiv = $('#item-path-19-instance-1_2_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_2_4_1').change( function() {
    var ok = validate19instance1_2_4_1();
    showError('item-error-19-instance-1_2_4_1',ok);
  });
  
  $('#remove-button-17-instance-1_2_5').click(function() {
    $('#repeating-enclosing-17-instance-1_2_5').hide();
  });

  $('#remove-button-18-instance-1_2_5_1').click(function() {
    $('#repeating-enclosing-18-instance-1_2_5_1').hide();
  });

  $('#item-18-instance-1_2_5_1').prop('checked',false);

  // value
  var validate18instance1_2_5_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_2_5_1');
    var pathDiv = $('#item-path-18-instance-1_2_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_2_5_1').change( function() {
    var ok = validate18instance1_2_5_1();
    showError('item-error-18-instance-1_2_5_1',ok);
  });
  
  $('#remove-button-19-instance-1_2_5_1').click(function() {
    $('#repeating-enclosing-19-instance-1_2_5_1').hide();
  });

  $('#item-19-instance-1_2_5_1').prop('checked',false);

  // valueIRI
  var validate19instance1_2_5_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_2_5_1');
    var pathDiv = $('#item-path-19-instance-1_2_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_2_5_1').change( function() {
    var ok = validate19instance1_2_5_1();
    showError('item-error-19-instance-1_2_5_1',ok);
  });
  
  $('#remove-button-17-instance-1_2_6').click(function() {
    $('#repeating-enclosing-17-instance-1_2_6').hide();
  });

  $('#remove-button-18-instance-1_2_6_1').click(function() {
    $('#repeating-enclosing-18-instance-1_2_6_1').hide();
  });

  $('#item-18-instance-1_2_6_1').prop('checked',false);

  // value
  var validate18instance1_2_6_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_2_6_1');
    var pathDiv = $('#item-path-18-instance-1_2_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_2_6_1').change( function() {
    var ok = validate18instance1_2_6_1();
    showError('item-error-18-instance-1_2_6_1',ok);
  });
  
  $('#remove-button-19-instance-1_2_6_1').click(function() {
    $('#repeating-enclosing-19-instance-1_2_6_1').hide();
  });

  $('#item-19-instance-1_2_6_1').prop('checked',false);

  // valueIRI
  var validate19instance1_2_6_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_2_6_1');
    var pathDiv = $('#item-path-19-instance-1_2_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_2_6_1').change( function() {
    var ok = validate19instance1_2_6_1();
    showError('item-error-19-instance-1_2_6_1',ok);
  });
  
  $('#remove-button-17-instance-1_2_7').click(function() {
    $('#repeating-enclosing-17-instance-1_2_7').hide();
  });

  $('#remove-button-18-instance-1_2_7_1').click(function() {
    $('#repeating-enclosing-18-instance-1_2_7_1').hide();
  });

  $('#item-18-instance-1_2_7_1').prop('checked',false);

  // value
  var validate18instance1_2_7_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_2_7_1');
    var pathDiv = $('#item-path-18-instance-1_2_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_2_7_1').change( function() {
    var ok = validate18instance1_2_7_1();
    showError('item-error-18-instance-1_2_7_1',ok);
  });
  
  $('#remove-button-19-instance-1_2_7_1').click(function() {
    $('#repeating-enclosing-19-instance-1_2_7_1').hide();
  });

  $('#item-19-instance-1_2_7_1').prop('checked',false);

  // valueIRI
  var validate19instance1_2_7_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_2_7_1');
    var pathDiv = $('#item-path-19-instance-1_2_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_2_7_1').change( function() {
    var ok = validate19instance1_2_7_1();
    showError('item-error-19-instance-1_2_7_1',ok);
  });
  
  $('#remove-button-17-instance-1_2_8').click(function() {
    $('#repeating-enclosing-17-instance-1_2_8').hide();
  });

  $('#remove-button-18-instance-1_2_8_1').click(function() {
    $('#repeating-enclosing-18-instance-1_2_8_1').hide();
  });

  $('#item-18-instance-1_2_8_1').prop('checked',false);

  // value
  var validate18instance1_2_8_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_2_8_1');
    var pathDiv = $('#item-path-18-instance-1_2_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_2_8_1').change( function() {
    var ok = validate18instance1_2_8_1();
    showError('item-error-18-instance-1_2_8_1',ok);
  });
  
  $('#remove-button-19-instance-1_2_8_1').click(function() {
    $('#repeating-enclosing-19-instance-1_2_8_1').hide();
  });

  $('#item-19-instance-1_2_8_1').prop('checked',false);

  // valueIRI
  var validate19instance1_2_8_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_2_8_1');
    var pathDiv = $('#item-path-19-instance-1_2_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_2_8_1').change( function() {
    var ok = validate19instance1_2_8_1();
    showError('item-error-19-instance-1_2_8_1',ok);
  });
  
  $('#remove-button-17-instance-1_2_9').click(function() {
    $('#repeating-enclosing-17-instance-1_2_9').hide();
  });

  $('#remove-button-18-instance-1_2_9_1').click(function() {
    $('#repeating-enclosing-18-instance-1_2_9_1').hide();
  });

  $('#item-18-instance-1_2_9_1').prop('checked',false);

  // value
  var validate18instance1_2_9_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_2_9_1');
    var pathDiv = $('#item-path-18-instance-1_2_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_2_9_1').change( function() {
    var ok = validate18instance1_2_9_1();
    showError('item-error-18-instance-1_2_9_1',ok);
  });
  
  $('#remove-button-19-instance-1_2_9_1').click(function() {
    $('#repeating-enclosing-19-instance-1_2_9_1').hide();
  });

  $('#item-19-instance-1_2_9_1').prop('checked',false);

  // valueIRI
  var validate19instance1_2_9_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_2_9_1');
    var pathDiv = $('#item-path-19-instance-1_2_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_2_9_1').change( function() {
    var ok = validate19instance1_2_9_1();
    showError('item-error-19-instance-1_2_9_1',ok);
  });
  
  $('#remove-button-17-instance-1_2_10').click(function() {
    $('#repeating-enclosing-17-instance-1_2_10').hide();
  });

  $('#remove-button-18-instance-1_2_10_1').click(function() {
    $('#repeating-enclosing-18-instance-1_2_10_1').hide();
  });

  $('#item-18-instance-1_2_10_1').prop('checked',false);

  // value
  var validate18instance1_2_10_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_2_10_1');
    var pathDiv = $('#item-path-18-instance-1_2_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_2_10_1').change( function() {
    var ok = validate18instance1_2_10_1();
    showError('item-error-18-instance-1_2_10_1',ok);
  });
  
  $('#remove-button-19-instance-1_2_10_1').click(function() {
    $('#repeating-enclosing-19-instance-1_2_10_1').hide();
  });

  $('#item-19-instance-1_2_10_1').prop('checked',false);

  // valueIRI
  var validate19instance1_2_10_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_2_10_1');
    var pathDiv = $('#item-path-19-instance-1_2_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_2_10_1').change( function() {
    var ok = validate19instance1_2_10_1();
    showError('item-error-19-instance-1_2_10_1',ok);
  });
  
  $('#repeat-button-17-instance-1_2').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-17-instance-1_2_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_2_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_2_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_2_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_2_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_2_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_2_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_2_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_2_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_2_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-14-instance-1_3').click(function() {
    $('#repeating-enclosing-14-instance-1_3').hide();
  });

  $('#remove-button-15-instance-1_3_1').click(function() {
    $('#repeating-enclosing-15-instance-1_3_1').hide();
  });

  $('#item-15-instance-1_3_1').prop('checked',false);

  // category
  var validate15instance1_3_1 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_3_1');
    var pathDiv = $('#item-path-15-instance-1_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_3_1').change( function() {
    var ok = validate15instance1_3_1();
    showError('item-error-15-instance-1_3_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_3_1').attr('enabled','false');
  $('#repeat-button-15-instance-1_3').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-15-instance-1_3_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-16-instance-1_3_1').click(function() {
    $('#repeating-enclosing-16-instance-1_3_1').hide();
  });

  $('#item-16-instance-1_3_1').prop('checked',false);

  // categoryIRI
  var validate16instance1_3_1 = function () {
    var ok = true;
    var v = $('#item-16-instance-1_3_1');
    var pathDiv = $('#item-path-16-instance-1_3_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-16-instance-1_3_1').change( function() {
    var ok = validate16instance1_3_1();
    showError('item-error-16-instance-1_3_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-16-instance-1_3_1').attr('enabled','false');
  $('#repeat-button-16-instance-1_3').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-16-instance-1_3_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

$('#min-occurs-zero-17-instance-1_3').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_3_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_3_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_3_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_3_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_3_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_3_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_3_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_3_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_3_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_3_10'));
})

$('#min-occurs-zero-17-instance-1_3').change();
  $('#remove-button-17-instance-1_3_1').click(function() {
    $('#repeating-enclosing-17-instance-1_3_1').hide();
  });

  $('#remove-button-18-instance-1_3_1_1').click(function() {
    $('#repeating-enclosing-18-instance-1_3_1_1').hide();
  });

  $('#item-18-instance-1_3_1_1').prop('checked',false);

  // value
  var validate18instance1_3_1_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_3_1_1');
    var pathDiv = $('#item-path-18-instance-1_3_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_3_1_1').change( function() {
    var ok = validate18instance1_3_1_1();
    showError('item-error-18-instance-1_3_1_1',ok);
  });
  
  $('#remove-button-19-instance-1_3_1_1').click(function() {
    $('#repeating-enclosing-19-instance-1_3_1_1').hide();
  });

  $('#item-19-instance-1_3_1_1').prop('checked',false);

  // valueIRI
  var validate19instance1_3_1_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_3_1_1');
    var pathDiv = $('#item-path-19-instance-1_3_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_3_1_1').change( function() {
    var ok = validate19instance1_3_1_1();
    showError('item-error-19-instance-1_3_1_1',ok);
  });
  
  $('#remove-button-17-instance-1_3_2').click(function() {
    $('#repeating-enclosing-17-instance-1_3_2').hide();
  });

  $('#remove-button-18-instance-1_3_2_1').click(function() {
    $('#repeating-enclosing-18-instance-1_3_2_1').hide();
  });

  $('#item-18-instance-1_3_2_1').prop('checked',false);

  // value
  var validate18instance1_3_2_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_3_2_1');
    var pathDiv = $('#item-path-18-instance-1_3_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_3_2_1').change( function() {
    var ok = validate18instance1_3_2_1();
    showError('item-error-18-instance-1_3_2_1',ok);
  });
  
  $('#remove-button-19-instance-1_3_2_1').click(function() {
    $('#repeating-enclosing-19-instance-1_3_2_1').hide();
  });

  $('#item-19-instance-1_3_2_1').prop('checked',false);

  // valueIRI
  var validate19instance1_3_2_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_3_2_1');
    var pathDiv = $('#item-path-19-instance-1_3_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_3_2_1').change( function() {
    var ok = validate19instance1_3_2_1();
    showError('item-error-19-instance-1_3_2_1',ok);
  });
  
  $('#remove-button-17-instance-1_3_3').click(function() {
    $('#repeating-enclosing-17-instance-1_3_3').hide();
  });

  $('#remove-button-18-instance-1_3_3_1').click(function() {
    $('#repeating-enclosing-18-instance-1_3_3_1').hide();
  });

  $('#item-18-instance-1_3_3_1').prop('checked',false);

  // value
  var validate18instance1_3_3_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_3_3_1');
    var pathDiv = $('#item-path-18-instance-1_3_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_3_3_1').change( function() {
    var ok = validate18instance1_3_3_1();
    showError('item-error-18-instance-1_3_3_1',ok);
  });
  
  $('#remove-button-19-instance-1_3_3_1').click(function() {
    $('#repeating-enclosing-19-instance-1_3_3_1').hide();
  });

  $('#item-19-instance-1_3_3_1').prop('checked',false);

  // valueIRI
  var validate19instance1_3_3_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_3_3_1');
    var pathDiv = $('#item-path-19-instance-1_3_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_3_3_1').change( function() {
    var ok = validate19instance1_3_3_1();
    showError('item-error-19-instance-1_3_3_1',ok);
  });
  
  $('#remove-button-17-instance-1_3_4').click(function() {
    $('#repeating-enclosing-17-instance-1_3_4').hide();
  });

  $('#remove-button-18-instance-1_3_4_1').click(function() {
    $('#repeating-enclosing-18-instance-1_3_4_1').hide();
  });

  $('#item-18-instance-1_3_4_1').prop('checked',false);

  // value
  var validate18instance1_3_4_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_3_4_1');
    var pathDiv = $('#item-path-18-instance-1_3_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_3_4_1').change( function() {
    var ok = validate18instance1_3_4_1();
    showError('item-error-18-instance-1_3_4_1',ok);
  });
  
  $('#remove-button-19-instance-1_3_4_1').click(function() {
    $('#repeating-enclosing-19-instance-1_3_4_1').hide();
  });

  $('#item-19-instance-1_3_4_1').prop('checked',false);

  // valueIRI
  var validate19instance1_3_4_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_3_4_1');
    var pathDiv = $('#item-path-19-instance-1_3_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_3_4_1').change( function() {
    var ok = validate19instance1_3_4_1();
    showError('item-error-19-instance-1_3_4_1',ok);
  });
  
  $('#remove-button-17-instance-1_3_5').click(function() {
    $('#repeating-enclosing-17-instance-1_3_5').hide();
  });

  $('#remove-button-18-instance-1_3_5_1').click(function() {
    $('#repeating-enclosing-18-instance-1_3_5_1').hide();
  });

  $('#item-18-instance-1_3_5_1').prop('checked',false);

  // value
  var validate18instance1_3_5_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_3_5_1');
    var pathDiv = $('#item-path-18-instance-1_3_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_3_5_1').change( function() {
    var ok = validate18instance1_3_5_1();
    showError('item-error-18-instance-1_3_5_1',ok);
  });
  
  $('#remove-button-19-instance-1_3_5_1').click(function() {
    $('#repeating-enclosing-19-instance-1_3_5_1').hide();
  });

  $('#item-19-instance-1_3_5_1').prop('checked',false);

  // valueIRI
  var validate19instance1_3_5_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_3_5_1');
    var pathDiv = $('#item-path-19-instance-1_3_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_3_5_1').change( function() {
    var ok = validate19instance1_3_5_1();
    showError('item-error-19-instance-1_3_5_1',ok);
  });
  
  $('#remove-button-17-instance-1_3_6').click(function() {
    $('#repeating-enclosing-17-instance-1_3_6').hide();
  });

  $('#remove-button-18-instance-1_3_6_1').click(function() {
    $('#repeating-enclosing-18-instance-1_3_6_1').hide();
  });

  $('#item-18-instance-1_3_6_1').prop('checked',false);

  // value
  var validate18instance1_3_6_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_3_6_1');
    var pathDiv = $('#item-path-18-instance-1_3_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_3_6_1').change( function() {
    var ok = validate18instance1_3_6_1();
    showError('item-error-18-instance-1_3_6_1',ok);
  });
  
  $('#remove-button-19-instance-1_3_6_1').click(function() {
    $('#repeating-enclosing-19-instance-1_3_6_1').hide();
  });

  $('#item-19-instance-1_3_6_1').prop('checked',false);

  // valueIRI
  var validate19instance1_3_6_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_3_6_1');
    var pathDiv = $('#item-path-19-instance-1_3_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_3_6_1').change( function() {
    var ok = validate19instance1_3_6_1();
    showError('item-error-19-instance-1_3_6_1',ok);
  });
  
  $('#remove-button-17-instance-1_3_7').click(function() {
    $('#repeating-enclosing-17-instance-1_3_7').hide();
  });

  $('#remove-button-18-instance-1_3_7_1').click(function() {
    $('#repeating-enclosing-18-instance-1_3_7_1').hide();
  });

  $('#item-18-instance-1_3_7_1').prop('checked',false);

  // value
  var validate18instance1_3_7_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_3_7_1');
    var pathDiv = $('#item-path-18-instance-1_3_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_3_7_1').change( function() {
    var ok = validate18instance1_3_7_1();
    showError('item-error-18-instance-1_3_7_1',ok);
  });
  
  $('#remove-button-19-instance-1_3_7_1').click(function() {
    $('#repeating-enclosing-19-instance-1_3_7_1').hide();
  });

  $('#item-19-instance-1_3_7_1').prop('checked',false);

  // valueIRI
  var validate19instance1_3_7_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_3_7_1');
    var pathDiv = $('#item-path-19-instance-1_3_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_3_7_1').change( function() {
    var ok = validate19instance1_3_7_1();
    showError('item-error-19-instance-1_3_7_1',ok);
  });
  
  $('#remove-button-17-instance-1_3_8').click(function() {
    $('#repeating-enclosing-17-instance-1_3_8').hide();
  });

  $('#remove-button-18-instance-1_3_8_1').click(function() {
    $('#repeating-enclosing-18-instance-1_3_8_1').hide();
  });

  $('#item-18-instance-1_3_8_1').prop('checked',false);

  // value
  var validate18instance1_3_8_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_3_8_1');
    var pathDiv = $('#item-path-18-instance-1_3_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_3_8_1').change( function() {
    var ok = validate18instance1_3_8_1();
    showError('item-error-18-instance-1_3_8_1',ok);
  });
  
  $('#remove-button-19-instance-1_3_8_1').click(function() {
    $('#repeating-enclosing-19-instance-1_3_8_1').hide();
  });

  $('#item-19-instance-1_3_8_1').prop('checked',false);

  // valueIRI
  var validate19instance1_3_8_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_3_8_1');
    var pathDiv = $('#item-path-19-instance-1_3_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_3_8_1').change( function() {
    var ok = validate19instance1_3_8_1();
    showError('item-error-19-instance-1_3_8_1',ok);
  });
  
  $('#remove-button-17-instance-1_3_9').click(function() {
    $('#repeating-enclosing-17-instance-1_3_9').hide();
  });

  $('#remove-button-18-instance-1_3_9_1').click(function() {
    $('#repeating-enclosing-18-instance-1_3_9_1').hide();
  });

  $('#item-18-instance-1_3_9_1').prop('checked',false);

  // value
  var validate18instance1_3_9_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_3_9_1');
    var pathDiv = $('#item-path-18-instance-1_3_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_3_9_1').change( function() {
    var ok = validate18instance1_3_9_1();
    showError('item-error-18-instance-1_3_9_1',ok);
  });
  
  $('#remove-button-19-instance-1_3_9_1').click(function() {
    $('#repeating-enclosing-19-instance-1_3_9_1').hide();
  });

  $('#item-19-instance-1_3_9_1').prop('checked',false);

  // valueIRI
  var validate19instance1_3_9_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_3_9_1');
    var pathDiv = $('#item-path-19-instance-1_3_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_3_9_1').change( function() {
    var ok = validate19instance1_3_9_1();
    showError('item-error-19-instance-1_3_9_1',ok);
  });
  
  $('#remove-button-17-instance-1_3_10').click(function() {
    $('#repeating-enclosing-17-instance-1_3_10').hide();
  });

  $('#remove-button-18-instance-1_3_10_1').click(function() {
    $('#repeating-enclosing-18-instance-1_3_10_1').hide();
  });

  $('#item-18-instance-1_3_10_1').prop('checked',false);

  // value
  var validate18instance1_3_10_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_3_10_1');
    var pathDiv = $('#item-path-18-instance-1_3_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_3_10_1').change( function() {
    var ok = validate18instance1_3_10_1();
    showError('item-error-18-instance-1_3_10_1',ok);
  });
  
  $('#remove-button-19-instance-1_3_10_1').click(function() {
    $('#repeating-enclosing-19-instance-1_3_10_1').hide();
  });

  $('#item-19-instance-1_3_10_1').prop('checked',false);

  // valueIRI
  var validate19instance1_3_10_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_3_10_1');
    var pathDiv = $('#item-path-19-instance-1_3_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_3_10_1').change( function() {
    var ok = validate19instance1_3_10_1();
    showError('item-error-19-instance-1_3_10_1',ok);
  });
  
  $('#repeat-button-17-instance-1_3').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-17-instance-1_3_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_3_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_3_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_3_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_3_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_3_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_3_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_3_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_3_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_3_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-14-instance-1_4').click(function() {
    $('#repeating-enclosing-14-instance-1_4').hide();
  });

  $('#remove-button-15-instance-1_4_1').click(function() {
    $('#repeating-enclosing-15-instance-1_4_1').hide();
  });

  $('#item-15-instance-1_4_1').prop('checked',false);

  // category
  var validate15instance1_4_1 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_4_1');
    var pathDiv = $('#item-path-15-instance-1_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_4_1').change( function() {
    var ok = validate15instance1_4_1();
    showError('item-error-15-instance-1_4_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_4_1').attr('enabled','false');
  $('#repeat-button-15-instance-1_4').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-15-instance-1_4_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-16-instance-1_4_1').click(function() {
    $('#repeating-enclosing-16-instance-1_4_1').hide();
  });

  $('#item-16-instance-1_4_1').prop('checked',false);

  // categoryIRI
  var validate16instance1_4_1 = function () {
    var ok = true;
    var v = $('#item-16-instance-1_4_1');
    var pathDiv = $('#item-path-16-instance-1_4_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-16-instance-1_4_1').change( function() {
    var ok = validate16instance1_4_1();
    showError('item-error-16-instance-1_4_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-16-instance-1_4_1').attr('enabled','false');
  $('#repeat-button-16-instance-1_4').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-16-instance-1_4_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

$('#min-occurs-zero-17-instance-1_4').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_4_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_4_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_4_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_4_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_4_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_4_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_4_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_4_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_4_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_4_10'));
})

$('#min-occurs-zero-17-instance-1_4').change();
  $('#remove-button-17-instance-1_4_1').click(function() {
    $('#repeating-enclosing-17-instance-1_4_1').hide();
  });

  $('#remove-button-18-instance-1_4_1_1').click(function() {
    $('#repeating-enclosing-18-instance-1_4_1_1').hide();
  });

  $('#item-18-instance-1_4_1_1').prop('checked',false);

  // value
  var validate18instance1_4_1_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_4_1_1');
    var pathDiv = $('#item-path-18-instance-1_4_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_4_1_1').change( function() {
    var ok = validate18instance1_4_1_1();
    showError('item-error-18-instance-1_4_1_1',ok);
  });
  
  $('#remove-button-19-instance-1_4_1_1').click(function() {
    $('#repeating-enclosing-19-instance-1_4_1_1').hide();
  });

  $('#item-19-instance-1_4_1_1').prop('checked',false);

  // valueIRI
  var validate19instance1_4_1_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_4_1_1');
    var pathDiv = $('#item-path-19-instance-1_4_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_4_1_1').change( function() {
    var ok = validate19instance1_4_1_1();
    showError('item-error-19-instance-1_4_1_1',ok);
  });
  
  $('#remove-button-17-instance-1_4_2').click(function() {
    $('#repeating-enclosing-17-instance-1_4_2').hide();
  });

  $('#remove-button-18-instance-1_4_2_1').click(function() {
    $('#repeating-enclosing-18-instance-1_4_2_1').hide();
  });

  $('#item-18-instance-1_4_2_1').prop('checked',false);

  // value
  var validate18instance1_4_2_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_4_2_1');
    var pathDiv = $('#item-path-18-instance-1_4_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_4_2_1').change( function() {
    var ok = validate18instance1_4_2_1();
    showError('item-error-18-instance-1_4_2_1',ok);
  });
  
  $('#remove-button-19-instance-1_4_2_1').click(function() {
    $('#repeating-enclosing-19-instance-1_4_2_1').hide();
  });

  $('#item-19-instance-1_4_2_1').prop('checked',false);

  // valueIRI
  var validate19instance1_4_2_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_4_2_1');
    var pathDiv = $('#item-path-19-instance-1_4_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_4_2_1').change( function() {
    var ok = validate19instance1_4_2_1();
    showError('item-error-19-instance-1_4_2_1',ok);
  });
  
  $('#remove-button-17-instance-1_4_3').click(function() {
    $('#repeating-enclosing-17-instance-1_4_3').hide();
  });

  $('#remove-button-18-instance-1_4_3_1').click(function() {
    $('#repeating-enclosing-18-instance-1_4_3_1').hide();
  });

  $('#item-18-instance-1_4_3_1').prop('checked',false);

  // value
  var validate18instance1_4_3_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_4_3_1');
    var pathDiv = $('#item-path-18-instance-1_4_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_4_3_1').change( function() {
    var ok = validate18instance1_4_3_1();
    showError('item-error-18-instance-1_4_3_1',ok);
  });
  
  $('#remove-button-19-instance-1_4_3_1').click(function() {
    $('#repeating-enclosing-19-instance-1_4_3_1').hide();
  });

  $('#item-19-instance-1_4_3_1').prop('checked',false);

  // valueIRI
  var validate19instance1_4_3_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_4_3_1');
    var pathDiv = $('#item-path-19-instance-1_4_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_4_3_1').change( function() {
    var ok = validate19instance1_4_3_1();
    showError('item-error-19-instance-1_4_3_1',ok);
  });
  
  $('#remove-button-17-instance-1_4_4').click(function() {
    $('#repeating-enclosing-17-instance-1_4_4').hide();
  });

  $('#remove-button-18-instance-1_4_4_1').click(function() {
    $('#repeating-enclosing-18-instance-1_4_4_1').hide();
  });

  $('#item-18-instance-1_4_4_1').prop('checked',false);

  // value
  var validate18instance1_4_4_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_4_4_1');
    var pathDiv = $('#item-path-18-instance-1_4_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_4_4_1').change( function() {
    var ok = validate18instance1_4_4_1();
    showError('item-error-18-instance-1_4_4_1',ok);
  });
  
  $('#remove-button-19-instance-1_4_4_1').click(function() {
    $('#repeating-enclosing-19-instance-1_4_4_1').hide();
  });

  $('#item-19-instance-1_4_4_1').prop('checked',false);

  // valueIRI
  var validate19instance1_4_4_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_4_4_1');
    var pathDiv = $('#item-path-19-instance-1_4_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_4_4_1').change( function() {
    var ok = validate19instance1_4_4_1();
    showError('item-error-19-instance-1_4_4_1',ok);
  });
  
  $('#remove-button-17-instance-1_4_5').click(function() {
    $('#repeating-enclosing-17-instance-1_4_5').hide();
  });

  $('#remove-button-18-instance-1_4_5_1').click(function() {
    $('#repeating-enclosing-18-instance-1_4_5_1').hide();
  });

  $('#item-18-instance-1_4_5_1').prop('checked',false);

  // value
  var validate18instance1_4_5_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_4_5_1');
    var pathDiv = $('#item-path-18-instance-1_4_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_4_5_1').change( function() {
    var ok = validate18instance1_4_5_1();
    showError('item-error-18-instance-1_4_5_1',ok);
  });
  
  $('#remove-button-19-instance-1_4_5_1').click(function() {
    $('#repeating-enclosing-19-instance-1_4_5_1').hide();
  });

  $('#item-19-instance-1_4_5_1').prop('checked',false);

  // valueIRI
  var validate19instance1_4_5_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_4_5_1');
    var pathDiv = $('#item-path-19-instance-1_4_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_4_5_1').change( function() {
    var ok = validate19instance1_4_5_1();
    showError('item-error-19-instance-1_4_5_1',ok);
  });
  
  $('#remove-button-17-instance-1_4_6').click(function() {
    $('#repeating-enclosing-17-instance-1_4_6').hide();
  });

  $('#remove-button-18-instance-1_4_6_1').click(function() {
    $('#repeating-enclosing-18-instance-1_4_6_1').hide();
  });

  $('#item-18-instance-1_4_6_1').prop('checked',false);

  // value
  var validate18instance1_4_6_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_4_6_1');
    var pathDiv = $('#item-path-18-instance-1_4_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_4_6_1').change( function() {
    var ok = validate18instance1_4_6_1();
    showError('item-error-18-instance-1_4_6_1',ok);
  });
  
  $('#remove-button-19-instance-1_4_6_1').click(function() {
    $('#repeating-enclosing-19-instance-1_4_6_1').hide();
  });

  $('#item-19-instance-1_4_6_1').prop('checked',false);

  // valueIRI
  var validate19instance1_4_6_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_4_6_1');
    var pathDiv = $('#item-path-19-instance-1_4_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_4_6_1').change( function() {
    var ok = validate19instance1_4_6_1();
    showError('item-error-19-instance-1_4_6_1',ok);
  });
  
  $('#remove-button-17-instance-1_4_7').click(function() {
    $('#repeating-enclosing-17-instance-1_4_7').hide();
  });

  $('#remove-button-18-instance-1_4_7_1').click(function() {
    $('#repeating-enclosing-18-instance-1_4_7_1').hide();
  });

  $('#item-18-instance-1_4_7_1').prop('checked',false);

  // value
  var validate18instance1_4_7_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_4_7_1');
    var pathDiv = $('#item-path-18-instance-1_4_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_4_7_1').change( function() {
    var ok = validate18instance1_4_7_1();
    showError('item-error-18-instance-1_4_7_1',ok);
  });
  
  $('#remove-button-19-instance-1_4_7_1').click(function() {
    $('#repeating-enclosing-19-instance-1_4_7_1').hide();
  });

  $('#item-19-instance-1_4_7_1').prop('checked',false);

  // valueIRI
  var validate19instance1_4_7_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_4_7_1');
    var pathDiv = $('#item-path-19-instance-1_4_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_4_7_1').change( function() {
    var ok = validate19instance1_4_7_1();
    showError('item-error-19-instance-1_4_7_1',ok);
  });
  
  $('#remove-button-17-instance-1_4_8').click(function() {
    $('#repeating-enclosing-17-instance-1_4_8').hide();
  });

  $('#remove-button-18-instance-1_4_8_1').click(function() {
    $('#repeating-enclosing-18-instance-1_4_8_1').hide();
  });

  $('#item-18-instance-1_4_8_1').prop('checked',false);

  // value
  var validate18instance1_4_8_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_4_8_1');
    var pathDiv = $('#item-path-18-instance-1_4_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_4_8_1').change( function() {
    var ok = validate18instance1_4_8_1();
    showError('item-error-18-instance-1_4_8_1',ok);
  });
  
  $('#remove-button-19-instance-1_4_8_1').click(function() {
    $('#repeating-enclosing-19-instance-1_4_8_1').hide();
  });

  $('#item-19-instance-1_4_8_1').prop('checked',false);

  // valueIRI
  var validate19instance1_4_8_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_4_8_1');
    var pathDiv = $('#item-path-19-instance-1_4_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_4_8_1').change( function() {
    var ok = validate19instance1_4_8_1();
    showError('item-error-19-instance-1_4_8_1',ok);
  });
  
  $('#remove-button-17-instance-1_4_9').click(function() {
    $('#repeating-enclosing-17-instance-1_4_9').hide();
  });

  $('#remove-button-18-instance-1_4_9_1').click(function() {
    $('#repeating-enclosing-18-instance-1_4_9_1').hide();
  });

  $('#item-18-instance-1_4_9_1').prop('checked',false);

  // value
  var validate18instance1_4_9_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_4_9_1');
    var pathDiv = $('#item-path-18-instance-1_4_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_4_9_1').change( function() {
    var ok = validate18instance1_4_9_1();
    showError('item-error-18-instance-1_4_9_1',ok);
  });
  
  $('#remove-button-19-instance-1_4_9_1').click(function() {
    $('#repeating-enclosing-19-instance-1_4_9_1').hide();
  });

  $('#item-19-instance-1_4_9_1').prop('checked',false);

  // valueIRI
  var validate19instance1_4_9_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_4_9_1');
    var pathDiv = $('#item-path-19-instance-1_4_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_4_9_1').change( function() {
    var ok = validate19instance1_4_9_1();
    showError('item-error-19-instance-1_4_9_1',ok);
  });
  
  $('#remove-button-17-instance-1_4_10').click(function() {
    $('#repeating-enclosing-17-instance-1_4_10').hide();
  });

  $('#remove-button-18-instance-1_4_10_1').click(function() {
    $('#repeating-enclosing-18-instance-1_4_10_1').hide();
  });

  $('#item-18-instance-1_4_10_1').prop('checked',false);

  // value
  var validate18instance1_4_10_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_4_10_1');
    var pathDiv = $('#item-path-18-instance-1_4_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_4_10_1').change( function() {
    var ok = validate18instance1_4_10_1();
    showError('item-error-18-instance-1_4_10_1',ok);
  });
  
  $('#remove-button-19-instance-1_4_10_1').click(function() {
    $('#repeating-enclosing-19-instance-1_4_10_1').hide();
  });

  $('#item-19-instance-1_4_10_1').prop('checked',false);

  // valueIRI
  var validate19instance1_4_10_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_4_10_1');
    var pathDiv = $('#item-path-19-instance-1_4_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_4_10_1').change( function() {
    var ok = validate19instance1_4_10_1();
    showError('item-error-19-instance-1_4_10_1',ok);
  });
  
  $('#repeat-button-17-instance-1_4').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-17-instance-1_4_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_4_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_4_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_4_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_4_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_4_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_4_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_4_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_4_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_4_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-14-instance-1_5').click(function() {
    $('#repeating-enclosing-14-instance-1_5').hide();
  });

  $('#remove-button-15-instance-1_5_1').click(function() {
    $('#repeating-enclosing-15-instance-1_5_1').hide();
  });

  $('#item-15-instance-1_5_1').prop('checked',false);

  // category
  var validate15instance1_5_1 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_5_1');
    var pathDiv = $('#item-path-15-instance-1_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_5_1').change( function() {
    var ok = validate15instance1_5_1();
    showError('item-error-15-instance-1_5_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_5_1').attr('enabled','false');
  $('#repeat-button-15-instance-1_5').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-15-instance-1_5_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-16-instance-1_5_1').click(function() {
    $('#repeating-enclosing-16-instance-1_5_1').hide();
  });

  $('#item-16-instance-1_5_1').prop('checked',false);

  // categoryIRI
  var validate16instance1_5_1 = function () {
    var ok = true;
    var v = $('#item-16-instance-1_5_1');
    var pathDiv = $('#item-path-16-instance-1_5_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-16-instance-1_5_1').change( function() {
    var ok = validate16instance1_5_1();
    showError('item-error-16-instance-1_5_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-16-instance-1_5_1').attr('enabled','false');
  $('#repeat-button-16-instance-1_5').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-16-instance-1_5_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

$('#min-occurs-zero-17-instance-1_5').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_5_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_5_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_5_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_5_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_5_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_5_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_5_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_5_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_5_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_5_10'));
})

$('#min-occurs-zero-17-instance-1_5').change();
  $('#remove-button-17-instance-1_5_1').click(function() {
    $('#repeating-enclosing-17-instance-1_5_1').hide();
  });

  $('#remove-button-18-instance-1_5_1_1').click(function() {
    $('#repeating-enclosing-18-instance-1_5_1_1').hide();
  });

  $('#item-18-instance-1_5_1_1').prop('checked',false);

  // value
  var validate18instance1_5_1_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_5_1_1');
    var pathDiv = $('#item-path-18-instance-1_5_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_5_1_1').change( function() {
    var ok = validate18instance1_5_1_1();
    showError('item-error-18-instance-1_5_1_1',ok);
  });
  
  $('#remove-button-19-instance-1_5_1_1').click(function() {
    $('#repeating-enclosing-19-instance-1_5_1_1').hide();
  });

  $('#item-19-instance-1_5_1_1').prop('checked',false);

  // valueIRI
  var validate19instance1_5_1_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_5_1_1');
    var pathDiv = $('#item-path-19-instance-1_5_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_5_1_1').change( function() {
    var ok = validate19instance1_5_1_1();
    showError('item-error-19-instance-1_5_1_1',ok);
  });
  
  $('#remove-button-17-instance-1_5_2').click(function() {
    $('#repeating-enclosing-17-instance-1_5_2').hide();
  });

  $('#remove-button-18-instance-1_5_2_1').click(function() {
    $('#repeating-enclosing-18-instance-1_5_2_1').hide();
  });

  $('#item-18-instance-1_5_2_1').prop('checked',false);

  // value
  var validate18instance1_5_2_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_5_2_1');
    var pathDiv = $('#item-path-18-instance-1_5_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_5_2_1').change( function() {
    var ok = validate18instance1_5_2_1();
    showError('item-error-18-instance-1_5_2_1',ok);
  });
  
  $('#remove-button-19-instance-1_5_2_1').click(function() {
    $('#repeating-enclosing-19-instance-1_5_2_1').hide();
  });

  $('#item-19-instance-1_5_2_1').prop('checked',false);

  // valueIRI
  var validate19instance1_5_2_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_5_2_1');
    var pathDiv = $('#item-path-19-instance-1_5_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_5_2_1').change( function() {
    var ok = validate19instance1_5_2_1();
    showError('item-error-19-instance-1_5_2_1',ok);
  });
  
  $('#remove-button-17-instance-1_5_3').click(function() {
    $('#repeating-enclosing-17-instance-1_5_3').hide();
  });

  $('#remove-button-18-instance-1_5_3_1').click(function() {
    $('#repeating-enclosing-18-instance-1_5_3_1').hide();
  });

  $('#item-18-instance-1_5_3_1').prop('checked',false);

  // value
  var validate18instance1_5_3_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_5_3_1');
    var pathDiv = $('#item-path-18-instance-1_5_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_5_3_1').change( function() {
    var ok = validate18instance1_5_3_1();
    showError('item-error-18-instance-1_5_3_1',ok);
  });
  
  $('#remove-button-19-instance-1_5_3_1').click(function() {
    $('#repeating-enclosing-19-instance-1_5_3_1').hide();
  });

  $('#item-19-instance-1_5_3_1').prop('checked',false);

  // valueIRI
  var validate19instance1_5_3_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_5_3_1');
    var pathDiv = $('#item-path-19-instance-1_5_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_5_3_1').change( function() {
    var ok = validate19instance1_5_3_1();
    showError('item-error-19-instance-1_5_3_1',ok);
  });
  
  $('#remove-button-17-instance-1_5_4').click(function() {
    $('#repeating-enclosing-17-instance-1_5_4').hide();
  });

  $('#remove-button-18-instance-1_5_4_1').click(function() {
    $('#repeating-enclosing-18-instance-1_5_4_1').hide();
  });

  $('#item-18-instance-1_5_4_1').prop('checked',false);

  // value
  var validate18instance1_5_4_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_5_4_1');
    var pathDiv = $('#item-path-18-instance-1_5_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_5_4_1').change( function() {
    var ok = validate18instance1_5_4_1();
    showError('item-error-18-instance-1_5_4_1',ok);
  });
  
  $('#remove-button-19-instance-1_5_4_1').click(function() {
    $('#repeating-enclosing-19-instance-1_5_4_1').hide();
  });

  $('#item-19-instance-1_5_4_1').prop('checked',false);

  // valueIRI
  var validate19instance1_5_4_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_5_4_1');
    var pathDiv = $('#item-path-19-instance-1_5_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_5_4_1').change( function() {
    var ok = validate19instance1_5_4_1();
    showError('item-error-19-instance-1_5_4_1',ok);
  });
  
  $('#remove-button-17-instance-1_5_5').click(function() {
    $('#repeating-enclosing-17-instance-1_5_5').hide();
  });

  $('#remove-button-18-instance-1_5_5_1').click(function() {
    $('#repeating-enclosing-18-instance-1_5_5_1').hide();
  });

  $('#item-18-instance-1_5_5_1').prop('checked',false);

  // value
  var validate18instance1_5_5_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_5_5_1');
    var pathDiv = $('#item-path-18-instance-1_5_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_5_5_1').change( function() {
    var ok = validate18instance1_5_5_1();
    showError('item-error-18-instance-1_5_5_1',ok);
  });
  
  $('#remove-button-19-instance-1_5_5_1').click(function() {
    $('#repeating-enclosing-19-instance-1_5_5_1').hide();
  });

  $('#item-19-instance-1_5_5_1').prop('checked',false);

  // valueIRI
  var validate19instance1_5_5_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_5_5_1');
    var pathDiv = $('#item-path-19-instance-1_5_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_5_5_1').change( function() {
    var ok = validate19instance1_5_5_1();
    showError('item-error-19-instance-1_5_5_1',ok);
  });
  
  $('#remove-button-17-instance-1_5_6').click(function() {
    $('#repeating-enclosing-17-instance-1_5_6').hide();
  });

  $('#remove-button-18-instance-1_5_6_1').click(function() {
    $('#repeating-enclosing-18-instance-1_5_6_1').hide();
  });

  $('#item-18-instance-1_5_6_1').prop('checked',false);

  // value
  var validate18instance1_5_6_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_5_6_1');
    var pathDiv = $('#item-path-18-instance-1_5_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_5_6_1').change( function() {
    var ok = validate18instance1_5_6_1();
    showError('item-error-18-instance-1_5_6_1',ok);
  });
  
  $('#remove-button-19-instance-1_5_6_1').click(function() {
    $('#repeating-enclosing-19-instance-1_5_6_1').hide();
  });

  $('#item-19-instance-1_5_6_1').prop('checked',false);

  // valueIRI
  var validate19instance1_5_6_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_5_6_1');
    var pathDiv = $('#item-path-19-instance-1_5_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_5_6_1').change( function() {
    var ok = validate19instance1_5_6_1();
    showError('item-error-19-instance-1_5_6_1',ok);
  });
  
  $('#remove-button-17-instance-1_5_7').click(function() {
    $('#repeating-enclosing-17-instance-1_5_7').hide();
  });

  $('#remove-button-18-instance-1_5_7_1').click(function() {
    $('#repeating-enclosing-18-instance-1_5_7_1').hide();
  });

  $('#item-18-instance-1_5_7_1').prop('checked',false);

  // value
  var validate18instance1_5_7_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_5_7_1');
    var pathDiv = $('#item-path-18-instance-1_5_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_5_7_1').change( function() {
    var ok = validate18instance1_5_7_1();
    showError('item-error-18-instance-1_5_7_1',ok);
  });
  
  $('#remove-button-19-instance-1_5_7_1').click(function() {
    $('#repeating-enclosing-19-instance-1_5_7_1').hide();
  });

  $('#item-19-instance-1_5_7_1').prop('checked',false);

  // valueIRI
  var validate19instance1_5_7_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_5_7_1');
    var pathDiv = $('#item-path-19-instance-1_5_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_5_7_1').change( function() {
    var ok = validate19instance1_5_7_1();
    showError('item-error-19-instance-1_5_7_1',ok);
  });
  
  $('#remove-button-17-instance-1_5_8').click(function() {
    $('#repeating-enclosing-17-instance-1_5_8').hide();
  });

  $('#remove-button-18-instance-1_5_8_1').click(function() {
    $('#repeating-enclosing-18-instance-1_5_8_1').hide();
  });

  $('#item-18-instance-1_5_8_1').prop('checked',false);

  // value
  var validate18instance1_5_8_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_5_8_1');
    var pathDiv = $('#item-path-18-instance-1_5_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_5_8_1').change( function() {
    var ok = validate18instance1_5_8_1();
    showError('item-error-18-instance-1_5_8_1',ok);
  });
  
  $('#remove-button-19-instance-1_5_8_1').click(function() {
    $('#repeating-enclosing-19-instance-1_5_8_1').hide();
  });

  $('#item-19-instance-1_5_8_1').prop('checked',false);

  // valueIRI
  var validate19instance1_5_8_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_5_8_1');
    var pathDiv = $('#item-path-19-instance-1_5_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_5_8_1').change( function() {
    var ok = validate19instance1_5_8_1();
    showError('item-error-19-instance-1_5_8_1',ok);
  });
  
  $('#remove-button-17-instance-1_5_9').click(function() {
    $('#repeating-enclosing-17-instance-1_5_9').hide();
  });

  $('#remove-button-18-instance-1_5_9_1').click(function() {
    $('#repeating-enclosing-18-instance-1_5_9_1').hide();
  });

  $('#item-18-instance-1_5_9_1').prop('checked',false);

  // value
  var validate18instance1_5_9_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_5_9_1');
    var pathDiv = $('#item-path-18-instance-1_5_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_5_9_1').change( function() {
    var ok = validate18instance1_5_9_1();
    showError('item-error-18-instance-1_5_9_1',ok);
  });
  
  $('#remove-button-19-instance-1_5_9_1').click(function() {
    $('#repeating-enclosing-19-instance-1_5_9_1').hide();
  });

  $('#item-19-instance-1_5_9_1').prop('checked',false);

  // valueIRI
  var validate19instance1_5_9_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_5_9_1');
    var pathDiv = $('#item-path-19-instance-1_5_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_5_9_1').change( function() {
    var ok = validate19instance1_5_9_1();
    showError('item-error-19-instance-1_5_9_1',ok);
  });
  
  $('#remove-button-17-instance-1_5_10').click(function() {
    $('#repeating-enclosing-17-instance-1_5_10').hide();
  });

  $('#remove-button-18-instance-1_5_10_1').click(function() {
    $('#repeating-enclosing-18-instance-1_5_10_1').hide();
  });

  $('#item-18-instance-1_5_10_1').prop('checked',false);

  // value
  var validate18instance1_5_10_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_5_10_1');
    var pathDiv = $('#item-path-18-instance-1_5_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_5_10_1').change( function() {
    var ok = validate18instance1_5_10_1();
    showError('item-error-18-instance-1_5_10_1',ok);
  });
  
  $('#remove-button-19-instance-1_5_10_1').click(function() {
    $('#repeating-enclosing-19-instance-1_5_10_1').hide();
  });

  $('#item-19-instance-1_5_10_1').prop('checked',false);

  // valueIRI
  var validate19instance1_5_10_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_5_10_1');
    var pathDiv = $('#item-path-19-instance-1_5_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_5_10_1').change( function() {
    var ok = validate19instance1_5_10_1();
    showError('item-error-19-instance-1_5_10_1',ok);
  });
  
  $('#repeat-button-17-instance-1_5').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-17-instance-1_5_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_5_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_5_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_5_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_5_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_5_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_5_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_5_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_5_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_5_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-14-instance-1_6').click(function() {
    $('#repeating-enclosing-14-instance-1_6').hide();
  });

  $('#remove-button-15-instance-1_6_1').click(function() {
    $('#repeating-enclosing-15-instance-1_6_1').hide();
  });

  $('#item-15-instance-1_6_1').prop('checked',false);

  // category
  var validate15instance1_6_1 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_6_1');
    var pathDiv = $('#item-path-15-instance-1_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_6_1').change( function() {
    var ok = validate15instance1_6_1();
    showError('item-error-15-instance-1_6_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_6_1').attr('enabled','false');
  $('#repeat-button-15-instance-1_6').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-15-instance-1_6_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-16-instance-1_6_1').click(function() {
    $('#repeating-enclosing-16-instance-1_6_1').hide();
  });

  $('#item-16-instance-1_6_1').prop('checked',false);

  // categoryIRI
  var validate16instance1_6_1 = function () {
    var ok = true;
    var v = $('#item-16-instance-1_6_1');
    var pathDiv = $('#item-path-16-instance-1_6_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-16-instance-1_6_1').change( function() {
    var ok = validate16instance1_6_1();
    showError('item-error-16-instance-1_6_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-16-instance-1_6_1').attr('enabled','false');
  $('#repeat-button-16-instance-1_6').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-16-instance-1_6_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

$('#min-occurs-zero-17-instance-1_6').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_6_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_6_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_6_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_6_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_6_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_6_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_6_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_6_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_6_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_6_10'));
})

$('#min-occurs-zero-17-instance-1_6').change();
  $('#remove-button-17-instance-1_6_1').click(function() {
    $('#repeating-enclosing-17-instance-1_6_1').hide();
  });

  $('#remove-button-18-instance-1_6_1_1').click(function() {
    $('#repeating-enclosing-18-instance-1_6_1_1').hide();
  });

  $('#item-18-instance-1_6_1_1').prop('checked',false);

  // value
  var validate18instance1_6_1_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_6_1_1');
    var pathDiv = $('#item-path-18-instance-1_6_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_6_1_1').change( function() {
    var ok = validate18instance1_6_1_1();
    showError('item-error-18-instance-1_6_1_1',ok);
  });
  
  $('#remove-button-19-instance-1_6_1_1').click(function() {
    $('#repeating-enclosing-19-instance-1_6_1_1').hide();
  });

  $('#item-19-instance-1_6_1_1').prop('checked',false);

  // valueIRI
  var validate19instance1_6_1_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_6_1_1');
    var pathDiv = $('#item-path-19-instance-1_6_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_6_1_1').change( function() {
    var ok = validate19instance1_6_1_1();
    showError('item-error-19-instance-1_6_1_1',ok);
  });
  
  $('#remove-button-17-instance-1_6_2').click(function() {
    $('#repeating-enclosing-17-instance-1_6_2').hide();
  });

  $('#remove-button-18-instance-1_6_2_1').click(function() {
    $('#repeating-enclosing-18-instance-1_6_2_1').hide();
  });

  $('#item-18-instance-1_6_2_1').prop('checked',false);

  // value
  var validate18instance1_6_2_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_6_2_1');
    var pathDiv = $('#item-path-18-instance-1_6_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_6_2_1').change( function() {
    var ok = validate18instance1_6_2_1();
    showError('item-error-18-instance-1_6_2_1',ok);
  });
  
  $('#remove-button-19-instance-1_6_2_1').click(function() {
    $('#repeating-enclosing-19-instance-1_6_2_1').hide();
  });

  $('#item-19-instance-1_6_2_1').prop('checked',false);

  // valueIRI
  var validate19instance1_6_2_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_6_2_1');
    var pathDiv = $('#item-path-19-instance-1_6_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_6_2_1').change( function() {
    var ok = validate19instance1_6_2_1();
    showError('item-error-19-instance-1_6_2_1',ok);
  });
  
  $('#remove-button-17-instance-1_6_3').click(function() {
    $('#repeating-enclosing-17-instance-1_6_3').hide();
  });

  $('#remove-button-18-instance-1_6_3_1').click(function() {
    $('#repeating-enclosing-18-instance-1_6_3_1').hide();
  });

  $('#item-18-instance-1_6_3_1').prop('checked',false);

  // value
  var validate18instance1_6_3_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_6_3_1');
    var pathDiv = $('#item-path-18-instance-1_6_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_6_3_1').change( function() {
    var ok = validate18instance1_6_3_1();
    showError('item-error-18-instance-1_6_3_1',ok);
  });
  
  $('#remove-button-19-instance-1_6_3_1').click(function() {
    $('#repeating-enclosing-19-instance-1_6_3_1').hide();
  });

  $('#item-19-instance-1_6_3_1').prop('checked',false);

  // valueIRI
  var validate19instance1_6_3_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_6_3_1');
    var pathDiv = $('#item-path-19-instance-1_6_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_6_3_1').change( function() {
    var ok = validate19instance1_6_3_1();
    showError('item-error-19-instance-1_6_3_1',ok);
  });
  
  $('#remove-button-17-instance-1_6_4').click(function() {
    $('#repeating-enclosing-17-instance-1_6_4').hide();
  });

  $('#remove-button-18-instance-1_6_4_1').click(function() {
    $('#repeating-enclosing-18-instance-1_6_4_1').hide();
  });

  $('#item-18-instance-1_6_4_1').prop('checked',false);

  // value
  var validate18instance1_6_4_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_6_4_1');
    var pathDiv = $('#item-path-18-instance-1_6_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_6_4_1').change( function() {
    var ok = validate18instance1_6_4_1();
    showError('item-error-18-instance-1_6_4_1',ok);
  });
  
  $('#remove-button-19-instance-1_6_4_1').click(function() {
    $('#repeating-enclosing-19-instance-1_6_4_1').hide();
  });

  $('#item-19-instance-1_6_4_1').prop('checked',false);

  // valueIRI
  var validate19instance1_6_4_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_6_4_1');
    var pathDiv = $('#item-path-19-instance-1_6_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_6_4_1').change( function() {
    var ok = validate19instance1_6_4_1();
    showError('item-error-19-instance-1_6_4_1',ok);
  });
  
  $('#remove-button-17-instance-1_6_5').click(function() {
    $('#repeating-enclosing-17-instance-1_6_5').hide();
  });

  $('#remove-button-18-instance-1_6_5_1').click(function() {
    $('#repeating-enclosing-18-instance-1_6_5_1').hide();
  });

  $('#item-18-instance-1_6_5_1').prop('checked',false);

  // value
  var validate18instance1_6_5_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_6_5_1');
    var pathDiv = $('#item-path-18-instance-1_6_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_6_5_1').change( function() {
    var ok = validate18instance1_6_5_1();
    showError('item-error-18-instance-1_6_5_1',ok);
  });
  
  $('#remove-button-19-instance-1_6_5_1').click(function() {
    $('#repeating-enclosing-19-instance-1_6_5_1').hide();
  });

  $('#item-19-instance-1_6_5_1').prop('checked',false);

  // valueIRI
  var validate19instance1_6_5_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_6_5_1');
    var pathDiv = $('#item-path-19-instance-1_6_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_6_5_1').change( function() {
    var ok = validate19instance1_6_5_1();
    showError('item-error-19-instance-1_6_5_1',ok);
  });
  
  $('#remove-button-17-instance-1_6_6').click(function() {
    $('#repeating-enclosing-17-instance-1_6_6').hide();
  });

  $('#remove-button-18-instance-1_6_6_1').click(function() {
    $('#repeating-enclosing-18-instance-1_6_6_1').hide();
  });

  $('#item-18-instance-1_6_6_1').prop('checked',false);

  // value
  var validate18instance1_6_6_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_6_6_1');
    var pathDiv = $('#item-path-18-instance-1_6_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_6_6_1').change( function() {
    var ok = validate18instance1_6_6_1();
    showError('item-error-18-instance-1_6_6_1',ok);
  });
  
  $('#remove-button-19-instance-1_6_6_1').click(function() {
    $('#repeating-enclosing-19-instance-1_6_6_1').hide();
  });

  $('#item-19-instance-1_6_6_1').prop('checked',false);

  // valueIRI
  var validate19instance1_6_6_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_6_6_1');
    var pathDiv = $('#item-path-19-instance-1_6_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_6_6_1').change( function() {
    var ok = validate19instance1_6_6_1();
    showError('item-error-19-instance-1_6_6_1',ok);
  });
  
  $('#remove-button-17-instance-1_6_7').click(function() {
    $('#repeating-enclosing-17-instance-1_6_7').hide();
  });

  $('#remove-button-18-instance-1_6_7_1').click(function() {
    $('#repeating-enclosing-18-instance-1_6_7_1').hide();
  });

  $('#item-18-instance-1_6_7_1').prop('checked',false);

  // value
  var validate18instance1_6_7_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_6_7_1');
    var pathDiv = $('#item-path-18-instance-1_6_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_6_7_1').change( function() {
    var ok = validate18instance1_6_7_1();
    showError('item-error-18-instance-1_6_7_1',ok);
  });
  
  $('#remove-button-19-instance-1_6_7_1').click(function() {
    $('#repeating-enclosing-19-instance-1_6_7_1').hide();
  });

  $('#item-19-instance-1_6_7_1').prop('checked',false);

  // valueIRI
  var validate19instance1_6_7_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_6_7_1');
    var pathDiv = $('#item-path-19-instance-1_6_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_6_7_1').change( function() {
    var ok = validate19instance1_6_7_1();
    showError('item-error-19-instance-1_6_7_1',ok);
  });
  
  $('#remove-button-17-instance-1_6_8').click(function() {
    $('#repeating-enclosing-17-instance-1_6_8').hide();
  });

  $('#remove-button-18-instance-1_6_8_1').click(function() {
    $('#repeating-enclosing-18-instance-1_6_8_1').hide();
  });

  $('#item-18-instance-1_6_8_1').prop('checked',false);

  // value
  var validate18instance1_6_8_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_6_8_1');
    var pathDiv = $('#item-path-18-instance-1_6_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_6_8_1').change( function() {
    var ok = validate18instance1_6_8_1();
    showError('item-error-18-instance-1_6_8_1',ok);
  });
  
  $('#remove-button-19-instance-1_6_8_1').click(function() {
    $('#repeating-enclosing-19-instance-1_6_8_1').hide();
  });

  $('#item-19-instance-1_6_8_1').prop('checked',false);

  // valueIRI
  var validate19instance1_6_8_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_6_8_1');
    var pathDiv = $('#item-path-19-instance-1_6_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_6_8_1').change( function() {
    var ok = validate19instance1_6_8_1();
    showError('item-error-19-instance-1_6_8_1',ok);
  });
  
  $('#remove-button-17-instance-1_6_9').click(function() {
    $('#repeating-enclosing-17-instance-1_6_9').hide();
  });

  $('#remove-button-18-instance-1_6_9_1').click(function() {
    $('#repeating-enclosing-18-instance-1_6_9_1').hide();
  });

  $('#item-18-instance-1_6_9_1').prop('checked',false);

  // value
  var validate18instance1_6_9_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_6_9_1');
    var pathDiv = $('#item-path-18-instance-1_6_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_6_9_1').change( function() {
    var ok = validate18instance1_6_9_1();
    showError('item-error-18-instance-1_6_9_1',ok);
  });
  
  $('#remove-button-19-instance-1_6_9_1').click(function() {
    $('#repeating-enclosing-19-instance-1_6_9_1').hide();
  });

  $('#item-19-instance-1_6_9_1').prop('checked',false);

  // valueIRI
  var validate19instance1_6_9_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_6_9_1');
    var pathDiv = $('#item-path-19-instance-1_6_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_6_9_1').change( function() {
    var ok = validate19instance1_6_9_1();
    showError('item-error-19-instance-1_6_9_1',ok);
  });
  
  $('#remove-button-17-instance-1_6_10').click(function() {
    $('#repeating-enclosing-17-instance-1_6_10').hide();
  });

  $('#remove-button-18-instance-1_6_10_1').click(function() {
    $('#repeating-enclosing-18-instance-1_6_10_1').hide();
  });

  $('#item-18-instance-1_6_10_1').prop('checked',false);

  // value
  var validate18instance1_6_10_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_6_10_1');
    var pathDiv = $('#item-path-18-instance-1_6_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_6_10_1').change( function() {
    var ok = validate18instance1_6_10_1();
    showError('item-error-18-instance-1_6_10_1',ok);
  });
  
  $('#remove-button-19-instance-1_6_10_1').click(function() {
    $('#repeating-enclosing-19-instance-1_6_10_1').hide();
  });

  $('#item-19-instance-1_6_10_1').prop('checked',false);

  // valueIRI
  var validate19instance1_6_10_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_6_10_1');
    var pathDiv = $('#item-path-19-instance-1_6_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_6_10_1').change( function() {
    var ok = validate19instance1_6_10_1();
    showError('item-error-19-instance-1_6_10_1',ok);
  });
  
  $('#repeat-button-17-instance-1_6').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-17-instance-1_6_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_6_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_6_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_6_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_6_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_6_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_6_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_6_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_6_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_6_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-14-instance-1_7').click(function() {
    $('#repeating-enclosing-14-instance-1_7').hide();
  });

  $('#remove-button-15-instance-1_7_1').click(function() {
    $('#repeating-enclosing-15-instance-1_7_1').hide();
  });

  $('#item-15-instance-1_7_1').prop('checked',false);

  // category
  var validate15instance1_7_1 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_7_1');
    var pathDiv = $('#item-path-15-instance-1_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_7_1').change( function() {
    var ok = validate15instance1_7_1();
    showError('item-error-15-instance-1_7_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_7_1').attr('enabled','false');
  $('#repeat-button-15-instance-1_7').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-15-instance-1_7_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-16-instance-1_7_1').click(function() {
    $('#repeating-enclosing-16-instance-1_7_1').hide();
  });

  $('#item-16-instance-1_7_1').prop('checked',false);

  // categoryIRI
  var validate16instance1_7_1 = function () {
    var ok = true;
    var v = $('#item-16-instance-1_7_1');
    var pathDiv = $('#item-path-16-instance-1_7_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-16-instance-1_7_1').change( function() {
    var ok = validate16instance1_7_1();
    showError('item-error-16-instance-1_7_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-16-instance-1_7_1').attr('enabled','false');
  $('#repeat-button-16-instance-1_7').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-16-instance-1_7_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

$('#min-occurs-zero-17-instance-1_7').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_7_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_7_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_7_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_7_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_7_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_7_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_7_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_7_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_7_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_7_10'));
})

$('#min-occurs-zero-17-instance-1_7').change();
  $('#remove-button-17-instance-1_7_1').click(function() {
    $('#repeating-enclosing-17-instance-1_7_1').hide();
  });

  $('#remove-button-18-instance-1_7_1_1').click(function() {
    $('#repeating-enclosing-18-instance-1_7_1_1').hide();
  });

  $('#item-18-instance-1_7_1_1').prop('checked',false);

  // value
  var validate18instance1_7_1_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_7_1_1');
    var pathDiv = $('#item-path-18-instance-1_7_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_7_1_1').change( function() {
    var ok = validate18instance1_7_1_1();
    showError('item-error-18-instance-1_7_1_1',ok);
  });
  
  $('#remove-button-19-instance-1_7_1_1').click(function() {
    $('#repeating-enclosing-19-instance-1_7_1_1').hide();
  });

  $('#item-19-instance-1_7_1_1').prop('checked',false);

  // valueIRI
  var validate19instance1_7_1_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_7_1_1');
    var pathDiv = $('#item-path-19-instance-1_7_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_7_1_1').change( function() {
    var ok = validate19instance1_7_1_1();
    showError('item-error-19-instance-1_7_1_1',ok);
  });
  
  $('#remove-button-17-instance-1_7_2').click(function() {
    $('#repeating-enclosing-17-instance-1_7_2').hide();
  });

  $('#remove-button-18-instance-1_7_2_1').click(function() {
    $('#repeating-enclosing-18-instance-1_7_2_1').hide();
  });

  $('#item-18-instance-1_7_2_1').prop('checked',false);

  // value
  var validate18instance1_7_2_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_7_2_1');
    var pathDiv = $('#item-path-18-instance-1_7_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_7_2_1').change( function() {
    var ok = validate18instance1_7_2_1();
    showError('item-error-18-instance-1_7_2_1',ok);
  });
  
  $('#remove-button-19-instance-1_7_2_1').click(function() {
    $('#repeating-enclosing-19-instance-1_7_2_1').hide();
  });

  $('#item-19-instance-1_7_2_1').prop('checked',false);

  // valueIRI
  var validate19instance1_7_2_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_7_2_1');
    var pathDiv = $('#item-path-19-instance-1_7_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_7_2_1').change( function() {
    var ok = validate19instance1_7_2_1();
    showError('item-error-19-instance-1_7_2_1',ok);
  });
  
  $('#remove-button-17-instance-1_7_3').click(function() {
    $('#repeating-enclosing-17-instance-1_7_3').hide();
  });

  $('#remove-button-18-instance-1_7_3_1').click(function() {
    $('#repeating-enclosing-18-instance-1_7_3_1').hide();
  });

  $('#item-18-instance-1_7_3_1').prop('checked',false);

  // value
  var validate18instance1_7_3_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_7_3_1');
    var pathDiv = $('#item-path-18-instance-1_7_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_7_3_1').change( function() {
    var ok = validate18instance1_7_3_1();
    showError('item-error-18-instance-1_7_3_1',ok);
  });
  
  $('#remove-button-19-instance-1_7_3_1').click(function() {
    $('#repeating-enclosing-19-instance-1_7_3_1').hide();
  });

  $('#item-19-instance-1_7_3_1').prop('checked',false);

  // valueIRI
  var validate19instance1_7_3_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_7_3_1');
    var pathDiv = $('#item-path-19-instance-1_7_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_7_3_1').change( function() {
    var ok = validate19instance1_7_3_1();
    showError('item-error-19-instance-1_7_3_1',ok);
  });
  
  $('#remove-button-17-instance-1_7_4').click(function() {
    $('#repeating-enclosing-17-instance-1_7_4').hide();
  });

  $('#remove-button-18-instance-1_7_4_1').click(function() {
    $('#repeating-enclosing-18-instance-1_7_4_1').hide();
  });

  $('#item-18-instance-1_7_4_1').prop('checked',false);

  // value
  var validate18instance1_7_4_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_7_4_1');
    var pathDiv = $('#item-path-18-instance-1_7_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_7_4_1').change( function() {
    var ok = validate18instance1_7_4_1();
    showError('item-error-18-instance-1_7_4_1',ok);
  });
  
  $('#remove-button-19-instance-1_7_4_1').click(function() {
    $('#repeating-enclosing-19-instance-1_7_4_1').hide();
  });

  $('#item-19-instance-1_7_4_1').prop('checked',false);

  // valueIRI
  var validate19instance1_7_4_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_7_4_1');
    var pathDiv = $('#item-path-19-instance-1_7_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_7_4_1').change( function() {
    var ok = validate19instance1_7_4_1();
    showError('item-error-19-instance-1_7_4_1',ok);
  });
  
  $('#remove-button-17-instance-1_7_5').click(function() {
    $('#repeating-enclosing-17-instance-1_7_5').hide();
  });

  $('#remove-button-18-instance-1_7_5_1').click(function() {
    $('#repeating-enclosing-18-instance-1_7_5_1').hide();
  });

  $('#item-18-instance-1_7_5_1').prop('checked',false);

  // value
  var validate18instance1_7_5_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_7_5_1');
    var pathDiv = $('#item-path-18-instance-1_7_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_7_5_1').change( function() {
    var ok = validate18instance1_7_5_1();
    showError('item-error-18-instance-1_7_5_1',ok);
  });
  
  $('#remove-button-19-instance-1_7_5_1').click(function() {
    $('#repeating-enclosing-19-instance-1_7_5_1').hide();
  });

  $('#item-19-instance-1_7_5_1').prop('checked',false);

  // valueIRI
  var validate19instance1_7_5_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_7_5_1');
    var pathDiv = $('#item-path-19-instance-1_7_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_7_5_1').change( function() {
    var ok = validate19instance1_7_5_1();
    showError('item-error-19-instance-1_7_5_1',ok);
  });
  
  $('#remove-button-17-instance-1_7_6').click(function() {
    $('#repeating-enclosing-17-instance-1_7_6').hide();
  });

  $('#remove-button-18-instance-1_7_6_1').click(function() {
    $('#repeating-enclosing-18-instance-1_7_6_1').hide();
  });

  $('#item-18-instance-1_7_6_1').prop('checked',false);

  // value
  var validate18instance1_7_6_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_7_6_1');
    var pathDiv = $('#item-path-18-instance-1_7_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_7_6_1').change( function() {
    var ok = validate18instance1_7_6_1();
    showError('item-error-18-instance-1_7_6_1',ok);
  });
  
  $('#remove-button-19-instance-1_7_6_1').click(function() {
    $('#repeating-enclosing-19-instance-1_7_6_1').hide();
  });

  $('#item-19-instance-1_7_6_1').prop('checked',false);

  // valueIRI
  var validate19instance1_7_6_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_7_6_1');
    var pathDiv = $('#item-path-19-instance-1_7_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_7_6_1').change( function() {
    var ok = validate19instance1_7_6_1();
    showError('item-error-19-instance-1_7_6_1',ok);
  });
  
  $('#remove-button-17-instance-1_7_7').click(function() {
    $('#repeating-enclosing-17-instance-1_7_7').hide();
  });

  $('#remove-button-18-instance-1_7_7_1').click(function() {
    $('#repeating-enclosing-18-instance-1_7_7_1').hide();
  });

  $('#item-18-instance-1_7_7_1').prop('checked',false);

  // value
  var validate18instance1_7_7_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_7_7_1');
    var pathDiv = $('#item-path-18-instance-1_7_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_7_7_1').change( function() {
    var ok = validate18instance1_7_7_1();
    showError('item-error-18-instance-1_7_7_1',ok);
  });
  
  $('#remove-button-19-instance-1_7_7_1').click(function() {
    $('#repeating-enclosing-19-instance-1_7_7_1').hide();
  });

  $('#item-19-instance-1_7_7_1').prop('checked',false);

  // valueIRI
  var validate19instance1_7_7_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_7_7_1');
    var pathDiv = $('#item-path-19-instance-1_7_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_7_7_1').change( function() {
    var ok = validate19instance1_7_7_1();
    showError('item-error-19-instance-1_7_7_1',ok);
  });
  
  $('#remove-button-17-instance-1_7_8').click(function() {
    $('#repeating-enclosing-17-instance-1_7_8').hide();
  });

  $('#remove-button-18-instance-1_7_8_1').click(function() {
    $('#repeating-enclosing-18-instance-1_7_8_1').hide();
  });

  $('#item-18-instance-1_7_8_1').prop('checked',false);

  // value
  var validate18instance1_7_8_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_7_8_1');
    var pathDiv = $('#item-path-18-instance-1_7_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_7_8_1').change( function() {
    var ok = validate18instance1_7_8_1();
    showError('item-error-18-instance-1_7_8_1',ok);
  });
  
  $('#remove-button-19-instance-1_7_8_1').click(function() {
    $('#repeating-enclosing-19-instance-1_7_8_1').hide();
  });

  $('#item-19-instance-1_7_8_1').prop('checked',false);

  // valueIRI
  var validate19instance1_7_8_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_7_8_1');
    var pathDiv = $('#item-path-19-instance-1_7_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_7_8_1').change( function() {
    var ok = validate19instance1_7_8_1();
    showError('item-error-19-instance-1_7_8_1',ok);
  });
  
  $('#remove-button-17-instance-1_7_9').click(function() {
    $('#repeating-enclosing-17-instance-1_7_9').hide();
  });

  $('#remove-button-18-instance-1_7_9_1').click(function() {
    $('#repeating-enclosing-18-instance-1_7_9_1').hide();
  });

  $('#item-18-instance-1_7_9_1').prop('checked',false);

  // value
  var validate18instance1_7_9_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_7_9_1');
    var pathDiv = $('#item-path-18-instance-1_7_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_7_9_1').change( function() {
    var ok = validate18instance1_7_9_1();
    showError('item-error-18-instance-1_7_9_1',ok);
  });
  
  $('#remove-button-19-instance-1_7_9_1').click(function() {
    $('#repeating-enclosing-19-instance-1_7_9_1').hide();
  });

  $('#item-19-instance-1_7_9_1').prop('checked',false);

  // valueIRI
  var validate19instance1_7_9_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_7_9_1');
    var pathDiv = $('#item-path-19-instance-1_7_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_7_9_1').change( function() {
    var ok = validate19instance1_7_9_1();
    showError('item-error-19-instance-1_7_9_1',ok);
  });
  
  $('#remove-button-17-instance-1_7_10').click(function() {
    $('#repeating-enclosing-17-instance-1_7_10').hide();
  });

  $('#remove-button-18-instance-1_7_10_1').click(function() {
    $('#repeating-enclosing-18-instance-1_7_10_1').hide();
  });

  $('#item-18-instance-1_7_10_1').prop('checked',false);

  // value
  var validate18instance1_7_10_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_7_10_1');
    var pathDiv = $('#item-path-18-instance-1_7_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_7_10_1').change( function() {
    var ok = validate18instance1_7_10_1();
    showError('item-error-18-instance-1_7_10_1',ok);
  });
  
  $('#remove-button-19-instance-1_7_10_1').click(function() {
    $('#repeating-enclosing-19-instance-1_7_10_1').hide();
  });

  $('#item-19-instance-1_7_10_1').prop('checked',false);

  // valueIRI
  var validate19instance1_7_10_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_7_10_1');
    var pathDiv = $('#item-path-19-instance-1_7_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_7_10_1').change( function() {
    var ok = validate19instance1_7_10_1();
    showError('item-error-19-instance-1_7_10_1',ok);
  });
  
  $('#repeat-button-17-instance-1_7').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-17-instance-1_7_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_7_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_7_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_7_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_7_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_7_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_7_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_7_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_7_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_7_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-14-instance-1_8').click(function() {
    $('#repeating-enclosing-14-instance-1_8').hide();
  });

  $('#remove-button-15-instance-1_8_1').click(function() {
    $('#repeating-enclosing-15-instance-1_8_1').hide();
  });

  $('#item-15-instance-1_8_1').prop('checked',false);

  // category
  var validate15instance1_8_1 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_8_1');
    var pathDiv = $('#item-path-15-instance-1_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_8_1').change( function() {
    var ok = validate15instance1_8_1();
    showError('item-error-15-instance-1_8_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_8_1').attr('enabled','false');
  $('#repeat-button-15-instance-1_8').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-15-instance-1_8_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-16-instance-1_8_1').click(function() {
    $('#repeating-enclosing-16-instance-1_8_1').hide();
  });

  $('#item-16-instance-1_8_1').prop('checked',false);

  // categoryIRI
  var validate16instance1_8_1 = function () {
    var ok = true;
    var v = $('#item-16-instance-1_8_1');
    var pathDiv = $('#item-path-16-instance-1_8_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-16-instance-1_8_1').change( function() {
    var ok = validate16instance1_8_1();
    showError('item-error-16-instance-1_8_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-16-instance-1_8_1').attr('enabled','false');
  $('#repeat-button-16-instance-1_8').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-16-instance-1_8_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

$('#min-occurs-zero-17-instance-1_8').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_8_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_8_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_8_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_8_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_8_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_8_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_8_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_8_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_8_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_8_10'));
})

$('#min-occurs-zero-17-instance-1_8').change();
  $('#remove-button-17-instance-1_8_1').click(function() {
    $('#repeating-enclosing-17-instance-1_8_1').hide();
  });

  $('#remove-button-18-instance-1_8_1_1').click(function() {
    $('#repeating-enclosing-18-instance-1_8_1_1').hide();
  });

  $('#item-18-instance-1_8_1_1').prop('checked',false);

  // value
  var validate18instance1_8_1_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_8_1_1');
    var pathDiv = $('#item-path-18-instance-1_8_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_8_1_1').change( function() {
    var ok = validate18instance1_8_1_1();
    showError('item-error-18-instance-1_8_1_1',ok);
  });
  
  $('#remove-button-19-instance-1_8_1_1').click(function() {
    $('#repeating-enclosing-19-instance-1_8_1_1').hide();
  });

  $('#item-19-instance-1_8_1_1').prop('checked',false);

  // valueIRI
  var validate19instance1_8_1_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_8_1_1');
    var pathDiv = $('#item-path-19-instance-1_8_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_8_1_1').change( function() {
    var ok = validate19instance1_8_1_1();
    showError('item-error-19-instance-1_8_1_1',ok);
  });
  
  $('#remove-button-17-instance-1_8_2').click(function() {
    $('#repeating-enclosing-17-instance-1_8_2').hide();
  });

  $('#remove-button-18-instance-1_8_2_1').click(function() {
    $('#repeating-enclosing-18-instance-1_8_2_1').hide();
  });

  $('#item-18-instance-1_8_2_1').prop('checked',false);

  // value
  var validate18instance1_8_2_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_8_2_1');
    var pathDiv = $('#item-path-18-instance-1_8_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_8_2_1').change( function() {
    var ok = validate18instance1_8_2_1();
    showError('item-error-18-instance-1_8_2_1',ok);
  });
  
  $('#remove-button-19-instance-1_8_2_1').click(function() {
    $('#repeating-enclosing-19-instance-1_8_2_1').hide();
  });

  $('#item-19-instance-1_8_2_1').prop('checked',false);

  // valueIRI
  var validate19instance1_8_2_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_8_2_1');
    var pathDiv = $('#item-path-19-instance-1_8_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_8_2_1').change( function() {
    var ok = validate19instance1_8_2_1();
    showError('item-error-19-instance-1_8_2_1',ok);
  });
  
  $('#remove-button-17-instance-1_8_3').click(function() {
    $('#repeating-enclosing-17-instance-1_8_3').hide();
  });

  $('#remove-button-18-instance-1_8_3_1').click(function() {
    $('#repeating-enclosing-18-instance-1_8_3_1').hide();
  });

  $('#item-18-instance-1_8_3_1').prop('checked',false);

  // value
  var validate18instance1_8_3_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_8_3_1');
    var pathDiv = $('#item-path-18-instance-1_8_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_8_3_1').change( function() {
    var ok = validate18instance1_8_3_1();
    showError('item-error-18-instance-1_8_3_1',ok);
  });
  
  $('#remove-button-19-instance-1_8_3_1').click(function() {
    $('#repeating-enclosing-19-instance-1_8_3_1').hide();
  });

  $('#item-19-instance-1_8_3_1').prop('checked',false);

  // valueIRI
  var validate19instance1_8_3_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_8_3_1');
    var pathDiv = $('#item-path-19-instance-1_8_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_8_3_1').change( function() {
    var ok = validate19instance1_8_3_1();
    showError('item-error-19-instance-1_8_3_1',ok);
  });
  
  $('#remove-button-17-instance-1_8_4').click(function() {
    $('#repeating-enclosing-17-instance-1_8_4').hide();
  });

  $('#remove-button-18-instance-1_8_4_1').click(function() {
    $('#repeating-enclosing-18-instance-1_8_4_1').hide();
  });

  $('#item-18-instance-1_8_4_1').prop('checked',false);

  // value
  var validate18instance1_8_4_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_8_4_1');
    var pathDiv = $('#item-path-18-instance-1_8_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_8_4_1').change( function() {
    var ok = validate18instance1_8_4_1();
    showError('item-error-18-instance-1_8_4_1',ok);
  });
  
  $('#remove-button-19-instance-1_8_4_1').click(function() {
    $('#repeating-enclosing-19-instance-1_8_4_1').hide();
  });

  $('#item-19-instance-1_8_4_1').prop('checked',false);

  // valueIRI
  var validate19instance1_8_4_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_8_4_1');
    var pathDiv = $('#item-path-19-instance-1_8_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_8_4_1').change( function() {
    var ok = validate19instance1_8_4_1();
    showError('item-error-19-instance-1_8_4_1',ok);
  });
  
  $('#remove-button-17-instance-1_8_5').click(function() {
    $('#repeating-enclosing-17-instance-1_8_5').hide();
  });

  $('#remove-button-18-instance-1_8_5_1').click(function() {
    $('#repeating-enclosing-18-instance-1_8_5_1').hide();
  });

  $('#item-18-instance-1_8_5_1').prop('checked',false);

  // value
  var validate18instance1_8_5_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_8_5_1');
    var pathDiv = $('#item-path-18-instance-1_8_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_8_5_1').change( function() {
    var ok = validate18instance1_8_5_1();
    showError('item-error-18-instance-1_8_5_1',ok);
  });
  
  $('#remove-button-19-instance-1_8_5_1').click(function() {
    $('#repeating-enclosing-19-instance-1_8_5_1').hide();
  });

  $('#item-19-instance-1_8_5_1').prop('checked',false);

  // valueIRI
  var validate19instance1_8_5_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_8_5_1');
    var pathDiv = $('#item-path-19-instance-1_8_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_8_5_1').change( function() {
    var ok = validate19instance1_8_5_1();
    showError('item-error-19-instance-1_8_5_1',ok);
  });
  
  $('#remove-button-17-instance-1_8_6').click(function() {
    $('#repeating-enclosing-17-instance-1_8_6').hide();
  });

  $('#remove-button-18-instance-1_8_6_1').click(function() {
    $('#repeating-enclosing-18-instance-1_8_6_1').hide();
  });

  $('#item-18-instance-1_8_6_1').prop('checked',false);

  // value
  var validate18instance1_8_6_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_8_6_1');
    var pathDiv = $('#item-path-18-instance-1_8_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_8_6_1').change( function() {
    var ok = validate18instance1_8_6_1();
    showError('item-error-18-instance-1_8_6_1',ok);
  });
  
  $('#remove-button-19-instance-1_8_6_1').click(function() {
    $('#repeating-enclosing-19-instance-1_8_6_1').hide();
  });

  $('#item-19-instance-1_8_6_1').prop('checked',false);

  // valueIRI
  var validate19instance1_8_6_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_8_6_1');
    var pathDiv = $('#item-path-19-instance-1_8_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_8_6_1').change( function() {
    var ok = validate19instance1_8_6_1();
    showError('item-error-19-instance-1_8_6_1',ok);
  });
  
  $('#remove-button-17-instance-1_8_7').click(function() {
    $('#repeating-enclosing-17-instance-1_8_7').hide();
  });

  $('#remove-button-18-instance-1_8_7_1').click(function() {
    $('#repeating-enclosing-18-instance-1_8_7_1').hide();
  });

  $('#item-18-instance-1_8_7_1').prop('checked',false);

  // value
  var validate18instance1_8_7_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_8_7_1');
    var pathDiv = $('#item-path-18-instance-1_8_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_8_7_1').change( function() {
    var ok = validate18instance1_8_7_1();
    showError('item-error-18-instance-1_8_7_1',ok);
  });
  
  $('#remove-button-19-instance-1_8_7_1').click(function() {
    $('#repeating-enclosing-19-instance-1_8_7_1').hide();
  });

  $('#item-19-instance-1_8_7_1').prop('checked',false);

  // valueIRI
  var validate19instance1_8_7_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_8_7_1');
    var pathDiv = $('#item-path-19-instance-1_8_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_8_7_1').change( function() {
    var ok = validate19instance1_8_7_1();
    showError('item-error-19-instance-1_8_7_1',ok);
  });
  
  $('#remove-button-17-instance-1_8_8').click(function() {
    $('#repeating-enclosing-17-instance-1_8_8').hide();
  });

  $('#remove-button-18-instance-1_8_8_1').click(function() {
    $('#repeating-enclosing-18-instance-1_8_8_1').hide();
  });

  $('#item-18-instance-1_8_8_1').prop('checked',false);

  // value
  var validate18instance1_8_8_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_8_8_1');
    var pathDiv = $('#item-path-18-instance-1_8_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_8_8_1').change( function() {
    var ok = validate18instance1_8_8_1();
    showError('item-error-18-instance-1_8_8_1',ok);
  });
  
  $('#remove-button-19-instance-1_8_8_1').click(function() {
    $('#repeating-enclosing-19-instance-1_8_8_1').hide();
  });

  $('#item-19-instance-1_8_8_1').prop('checked',false);

  // valueIRI
  var validate19instance1_8_8_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_8_8_1');
    var pathDiv = $('#item-path-19-instance-1_8_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_8_8_1').change( function() {
    var ok = validate19instance1_8_8_1();
    showError('item-error-19-instance-1_8_8_1',ok);
  });
  
  $('#remove-button-17-instance-1_8_9').click(function() {
    $('#repeating-enclosing-17-instance-1_8_9').hide();
  });

  $('#remove-button-18-instance-1_8_9_1').click(function() {
    $('#repeating-enclosing-18-instance-1_8_9_1').hide();
  });

  $('#item-18-instance-1_8_9_1').prop('checked',false);

  // value
  var validate18instance1_8_9_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_8_9_1');
    var pathDiv = $('#item-path-18-instance-1_8_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_8_9_1').change( function() {
    var ok = validate18instance1_8_9_1();
    showError('item-error-18-instance-1_8_9_1',ok);
  });
  
  $('#remove-button-19-instance-1_8_9_1').click(function() {
    $('#repeating-enclosing-19-instance-1_8_9_1').hide();
  });

  $('#item-19-instance-1_8_9_1').prop('checked',false);

  // valueIRI
  var validate19instance1_8_9_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_8_9_1');
    var pathDiv = $('#item-path-19-instance-1_8_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_8_9_1').change( function() {
    var ok = validate19instance1_8_9_1();
    showError('item-error-19-instance-1_8_9_1',ok);
  });
  
  $('#remove-button-17-instance-1_8_10').click(function() {
    $('#repeating-enclosing-17-instance-1_8_10').hide();
  });

  $('#remove-button-18-instance-1_8_10_1').click(function() {
    $('#repeating-enclosing-18-instance-1_8_10_1').hide();
  });

  $('#item-18-instance-1_8_10_1').prop('checked',false);

  // value
  var validate18instance1_8_10_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_8_10_1');
    var pathDiv = $('#item-path-18-instance-1_8_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_8_10_1').change( function() {
    var ok = validate18instance1_8_10_1();
    showError('item-error-18-instance-1_8_10_1',ok);
  });
  
  $('#remove-button-19-instance-1_8_10_1').click(function() {
    $('#repeating-enclosing-19-instance-1_8_10_1').hide();
  });

  $('#item-19-instance-1_8_10_1').prop('checked',false);

  // valueIRI
  var validate19instance1_8_10_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_8_10_1');
    var pathDiv = $('#item-path-19-instance-1_8_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_8_10_1').change( function() {
    var ok = validate19instance1_8_10_1();
    showError('item-error-19-instance-1_8_10_1',ok);
  });
  
  $('#repeat-button-17-instance-1_8').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-17-instance-1_8_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_8_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_8_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_8_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_8_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_8_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_8_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_8_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_8_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_8_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-14-instance-1_9').click(function() {
    $('#repeating-enclosing-14-instance-1_9').hide();
  });

  $('#remove-button-15-instance-1_9_1').click(function() {
    $('#repeating-enclosing-15-instance-1_9_1').hide();
  });

  $('#item-15-instance-1_9_1').prop('checked',false);

  // category
  var validate15instance1_9_1 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_9_1');
    var pathDiv = $('#item-path-15-instance-1_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_9_1').change( function() {
    var ok = validate15instance1_9_1();
    showError('item-error-15-instance-1_9_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_9_1').attr('enabled','false');
  $('#repeat-button-15-instance-1_9').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-15-instance-1_9_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-16-instance-1_9_1').click(function() {
    $('#repeating-enclosing-16-instance-1_9_1').hide();
  });

  $('#item-16-instance-1_9_1').prop('checked',false);

  // categoryIRI
  var validate16instance1_9_1 = function () {
    var ok = true;
    var v = $('#item-16-instance-1_9_1');
    var pathDiv = $('#item-path-16-instance-1_9_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-16-instance-1_9_1').change( function() {
    var ok = validate16instance1_9_1();
    showError('item-error-16-instance-1_9_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-16-instance-1_9_1').attr('enabled','false');
  $('#repeat-button-16-instance-1_9').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-16-instance-1_9_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

$('#min-occurs-zero-17-instance-1_9').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_9_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_9_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_9_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_9_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_9_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_9_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_9_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_9_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_9_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_9_10'));
})

$('#min-occurs-zero-17-instance-1_9').change();
  $('#remove-button-17-instance-1_9_1').click(function() {
    $('#repeating-enclosing-17-instance-1_9_1').hide();
  });

  $('#remove-button-18-instance-1_9_1_1').click(function() {
    $('#repeating-enclosing-18-instance-1_9_1_1').hide();
  });

  $('#item-18-instance-1_9_1_1').prop('checked',false);

  // value
  var validate18instance1_9_1_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_9_1_1');
    var pathDiv = $('#item-path-18-instance-1_9_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_9_1_1').change( function() {
    var ok = validate18instance1_9_1_1();
    showError('item-error-18-instance-1_9_1_1',ok);
  });
  
  $('#remove-button-19-instance-1_9_1_1').click(function() {
    $('#repeating-enclosing-19-instance-1_9_1_1').hide();
  });

  $('#item-19-instance-1_9_1_1').prop('checked',false);

  // valueIRI
  var validate19instance1_9_1_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_9_1_1');
    var pathDiv = $('#item-path-19-instance-1_9_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_9_1_1').change( function() {
    var ok = validate19instance1_9_1_1();
    showError('item-error-19-instance-1_9_1_1',ok);
  });
  
  $('#remove-button-17-instance-1_9_2').click(function() {
    $('#repeating-enclosing-17-instance-1_9_2').hide();
  });

  $('#remove-button-18-instance-1_9_2_1').click(function() {
    $('#repeating-enclosing-18-instance-1_9_2_1').hide();
  });

  $('#item-18-instance-1_9_2_1').prop('checked',false);

  // value
  var validate18instance1_9_2_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_9_2_1');
    var pathDiv = $('#item-path-18-instance-1_9_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_9_2_1').change( function() {
    var ok = validate18instance1_9_2_1();
    showError('item-error-18-instance-1_9_2_1',ok);
  });
  
  $('#remove-button-19-instance-1_9_2_1').click(function() {
    $('#repeating-enclosing-19-instance-1_9_2_1').hide();
  });

  $('#item-19-instance-1_9_2_1').prop('checked',false);

  // valueIRI
  var validate19instance1_9_2_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_9_2_1');
    var pathDiv = $('#item-path-19-instance-1_9_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_9_2_1').change( function() {
    var ok = validate19instance1_9_2_1();
    showError('item-error-19-instance-1_9_2_1',ok);
  });
  
  $('#remove-button-17-instance-1_9_3').click(function() {
    $('#repeating-enclosing-17-instance-1_9_3').hide();
  });

  $('#remove-button-18-instance-1_9_3_1').click(function() {
    $('#repeating-enclosing-18-instance-1_9_3_1').hide();
  });

  $('#item-18-instance-1_9_3_1').prop('checked',false);

  // value
  var validate18instance1_9_3_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_9_3_1');
    var pathDiv = $('#item-path-18-instance-1_9_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_9_3_1').change( function() {
    var ok = validate18instance1_9_3_1();
    showError('item-error-18-instance-1_9_3_1',ok);
  });
  
  $('#remove-button-19-instance-1_9_3_1').click(function() {
    $('#repeating-enclosing-19-instance-1_9_3_1').hide();
  });

  $('#item-19-instance-1_9_3_1').prop('checked',false);

  // valueIRI
  var validate19instance1_9_3_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_9_3_1');
    var pathDiv = $('#item-path-19-instance-1_9_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_9_3_1').change( function() {
    var ok = validate19instance1_9_3_1();
    showError('item-error-19-instance-1_9_3_1',ok);
  });
  
  $('#remove-button-17-instance-1_9_4').click(function() {
    $('#repeating-enclosing-17-instance-1_9_4').hide();
  });

  $('#remove-button-18-instance-1_9_4_1').click(function() {
    $('#repeating-enclosing-18-instance-1_9_4_1').hide();
  });

  $('#item-18-instance-1_9_4_1').prop('checked',false);

  // value
  var validate18instance1_9_4_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_9_4_1');
    var pathDiv = $('#item-path-18-instance-1_9_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_9_4_1').change( function() {
    var ok = validate18instance1_9_4_1();
    showError('item-error-18-instance-1_9_4_1',ok);
  });
  
  $('#remove-button-19-instance-1_9_4_1').click(function() {
    $('#repeating-enclosing-19-instance-1_9_4_1').hide();
  });

  $('#item-19-instance-1_9_4_1').prop('checked',false);

  // valueIRI
  var validate19instance1_9_4_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_9_4_1');
    var pathDiv = $('#item-path-19-instance-1_9_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_9_4_1').change( function() {
    var ok = validate19instance1_9_4_1();
    showError('item-error-19-instance-1_9_4_1',ok);
  });
  
  $('#remove-button-17-instance-1_9_5').click(function() {
    $('#repeating-enclosing-17-instance-1_9_5').hide();
  });

  $('#remove-button-18-instance-1_9_5_1').click(function() {
    $('#repeating-enclosing-18-instance-1_9_5_1').hide();
  });

  $('#item-18-instance-1_9_5_1').prop('checked',false);

  // value
  var validate18instance1_9_5_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_9_5_1');
    var pathDiv = $('#item-path-18-instance-1_9_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_9_5_1').change( function() {
    var ok = validate18instance1_9_5_1();
    showError('item-error-18-instance-1_9_5_1',ok);
  });
  
  $('#remove-button-19-instance-1_9_5_1').click(function() {
    $('#repeating-enclosing-19-instance-1_9_5_1').hide();
  });

  $('#item-19-instance-1_9_5_1').prop('checked',false);

  // valueIRI
  var validate19instance1_9_5_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_9_5_1');
    var pathDiv = $('#item-path-19-instance-1_9_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_9_5_1').change( function() {
    var ok = validate19instance1_9_5_1();
    showError('item-error-19-instance-1_9_5_1',ok);
  });
  
  $('#remove-button-17-instance-1_9_6').click(function() {
    $('#repeating-enclosing-17-instance-1_9_6').hide();
  });

  $('#remove-button-18-instance-1_9_6_1').click(function() {
    $('#repeating-enclosing-18-instance-1_9_6_1').hide();
  });

  $('#item-18-instance-1_9_6_1').prop('checked',false);

  // value
  var validate18instance1_9_6_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_9_6_1');
    var pathDiv = $('#item-path-18-instance-1_9_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_9_6_1').change( function() {
    var ok = validate18instance1_9_6_1();
    showError('item-error-18-instance-1_9_6_1',ok);
  });
  
  $('#remove-button-19-instance-1_9_6_1').click(function() {
    $('#repeating-enclosing-19-instance-1_9_6_1').hide();
  });

  $('#item-19-instance-1_9_6_1').prop('checked',false);

  // valueIRI
  var validate19instance1_9_6_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_9_6_1');
    var pathDiv = $('#item-path-19-instance-1_9_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_9_6_1').change( function() {
    var ok = validate19instance1_9_6_1();
    showError('item-error-19-instance-1_9_6_1',ok);
  });
  
  $('#remove-button-17-instance-1_9_7').click(function() {
    $('#repeating-enclosing-17-instance-1_9_7').hide();
  });

  $('#remove-button-18-instance-1_9_7_1').click(function() {
    $('#repeating-enclosing-18-instance-1_9_7_1').hide();
  });

  $('#item-18-instance-1_9_7_1').prop('checked',false);

  // value
  var validate18instance1_9_7_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_9_7_1');
    var pathDiv = $('#item-path-18-instance-1_9_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_9_7_1').change( function() {
    var ok = validate18instance1_9_7_1();
    showError('item-error-18-instance-1_9_7_1',ok);
  });
  
  $('#remove-button-19-instance-1_9_7_1').click(function() {
    $('#repeating-enclosing-19-instance-1_9_7_1').hide();
  });

  $('#item-19-instance-1_9_7_1').prop('checked',false);

  // valueIRI
  var validate19instance1_9_7_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_9_7_1');
    var pathDiv = $('#item-path-19-instance-1_9_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_9_7_1').change( function() {
    var ok = validate19instance1_9_7_1();
    showError('item-error-19-instance-1_9_7_1',ok);
  });
  
  $('#remove-button-17-instance-1_9_8').click(function() {
    $('#repeating-enclosing-17-instance-1_9_8').hide();
  });

  $('#remove-button-18-instance-1_9_8_1').click(function() {
    $('#repeating-enclosing-18-instance-1_9_8_1').hide();
  });

  $('#item-18-instance-1_9_8_1').prop('checked',false);

  // value
  var validate18instance1_9_8_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_9_8_1');
    var pathDiv = $('#item-path-18-instance-1_9_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_9_8_1').change( function() {
    var ok = validate18instance1_9_8_1();
    showError('item-error-18-instance-1_9_8_1',ok);
  });
  
  $('#remove-button-19-instance-1_9_8_1').click(function() {
    $('#repeating-enclosing-19-instance-1_9_8_1').hide();
  });

  $('#item-19-instance-1_9_8_1').prop('checked',false);

  // valueIRI
  var validate19instance1_9_8_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_9_8_1');
    var pathDiv = $('#item-path-19-instance-1_9_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_9_8_1').change( function() {
    var ok = validate19instance1_9_8_1();
    showError('item-error-19-instance-1_9_8_1',ok);
  });
  
  $('#remove-button-17-instance-1_9_9').click(function() {
    $('#repeating-enclosing-17-instance-1_9_9').hide();
  });

  $('#remove-button-18-instance-1_9_9_1').click(function() {
    $('#repeating-enclosing-18-instance-1_9_9_1').hide();
  });

  $('#item-18-instance-1_9_9_1').prop('checked',false);

  // value
  var validate18instance1_9_9_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_9_9_1');
    var pathDiv = $('#item-path-18-instance-1_9_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_9_9_1').change( function() {
    var ok = validate18instance1_9_9_1();
    showError('item-error-18-instance-1_9_9_1',ok);
  });
  
  $('#remove-button-19-instance-1_9_9_1').click(function() {
    $('#repeating-enclosing-19-instance-1_9_9_1').hide();
  });

  $('#item-19-instance-1_9_9_1').prop('checked',false);

  // valueIRI
  var validate19instance1_9_9_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_9_9_1');
    var pathDiv = $('#item-path-19-instance-1_9_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_9_9_1').change( function() {
    var ok = validate19instance1_9_9_1();
    showError('item-error-19-instance-1_9_9_1',ok);
  });
  
  $('#remove-button-17-instance-1_9_10').click(function() {
    $('#repeating-enclosing-17-instance-1_9_10').hide();
  });

  $('#remove-button-18-instance-1_9_10_1').click(function() {
    $('#repeating-enclosing-18-instance-1_9_10_1').hide();
  });

  $('#item-18-instance-1_9_10_1').prop('checked',false);

  // value
  var validate18instance1_9_10_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_9_10_1');
    var pathDiv = $('#item-path-18-instance-1_9_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_9_10_1').change( function() {
    var ok = validate18instance1_9_10_1();
    showError('item-error-18-instance-1_9_10_1',ok);
  });
  
  $('#remove-button-19-instance-1_9_10_1').click(function() {
    $('#repeating-enclosing-19-instance-1_9_10_1').hide();
  });

  $('#item-19-instance-1_9_10_1').prop('checked',false);

  // valueIRI
  var validate19instance1_9_10_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_9_10_1');
    var pathDiv = $('#item-path-19-instance-1_9_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_9_10_1').change( function() {
    var ok = validate19instance1_9_10_1();
    showError('item-error-19-instance-1_9_10_1',ok);
  });
  
  $('#repeat-button-17-instance-1_9').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-17-instance-1_9_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_9_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_9_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_9_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_9_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_9_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_9_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_9_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_9_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_9_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-14-instance-1_10').click(function() {
    $('#repeating-enclosing-14-instance-1_10').hide();
  });

  $('#remove-button-15-instance-1_10_1').click(function() {
    $('#repeating-enclosing-15-instance-1_10_1').hide();
  });

  $('#item-15-instance-1_10_1').prop('checked',false);

  // category
  var validate15instance1_10_1 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_10_1');
    var pathDiv = $('#item-path-15-instance-1_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_10_1').change( function() {
    var ok = validate15instance1_10_1();
    showError('item-error-15-instance-1_10_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_10_1').attr('enabled','false');
  $('#repeat-button-15-instance-1_10').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-15-instance-1_10_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-16-instance-1_10_1').click(function() {
    $('#repeating-enclosing-16-instance-1_10_1').hide();
  });

  $('#item-16-instance-1_10_1').prop('checked',false);

  // categoryIRI
  var validate16instance1_10_1 = function () {
    var ok = true;
    var v = $('#item-16-instance-1_10_1');
    var pathDiv = $('#item-path-16-instance-1_10_1');
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-16-instance-1_10_1').change( function() {
    var ok = validate16instance1_10_1();
    showError('item-error-16-instance-1_10_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-16-instance-1_10_1').attr('enabled','false');
  $('#repeat-button-16-instance-1_10').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-16-instance-1_10_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

$('#min-occurs-zero-17-instance-1_10').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_10_1'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_10_2'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_10_3'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_10_4'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_10_5'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_10_6'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_10_7'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_10_8'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_10_9'));
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-17-instance-1_10_10'));
})

$('#min-occurs-zero-17-instance-1_10').change();
  $('#remove-button-17-instance-1_10_1').click(function() {
    $('#repeating-enclosing-17-instance-1_10_1').hide();
  });

  $('#remove-button-18-instance-1_10_1_1').click(function() {
    $('#repeating-enclosing-18-instance-1_10_1_1').hide();
  });

  $('#item-18-instance-1_10_1_1').prop('checked',false);

  // value
  var validate18instance1_10_1_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_10_1_1');
    var pathDiv = $('#item-path-18-instance-1_10_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_10_1_1').change( function() {
    var ok = validate18instance1_10_1_1();
    showError('item-error-18-instance-1_10_1_1',ok);
  });
  
  $('#remove-button-19-instance-1_10_1_1').click(function() {
    $('#repeating-enclosing-19-instance-1_10_1_1').hide();
  });

  $('#item-19-instance-1_10_1_1').prop('checked',false);

  // valueIRI
  var validate19instance1_10_1_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_10_1_1');
    var pathDiv = $('#item-path-19-instance-1_10_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_10_1_1').change( function() {
    var ok = validate19instance1_10_1_1();
    showError('item-error-19-instance-1_10_1_1',ok);
  });
  
  $('#remove-button-17-instance-1_10_2').click(function() {
    $('#repeating-enclosing-17-instance-1_10_2').hide();
  });

  $('#remove-button-18-instance-1_10_2_1').click(function() {
    $('#repeating-enclosing-18-instance-1_10_2_1').hide();
  });

  $('#item-18-instance-1_10_2_1').prop('checked',false);

  // value
  var validate18instance1_10_2_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_10_2_1');
    var pathDiv = $('#item-path-18-instance-1_10_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_10_2_1').change( function() {
    var ok = validate18instance1_10_2_1();
    showError('item-error-18-instance-1_10_2_1',ok);
  });
  
  $('#remove-button-19-instance-1_10_2_1').click(function() {
    $('#repeating-enclosing-19-instance-1_10_2_1').hide();
  });

  $('#item-19-instance-1_10_2_1').prop('checked',false);

  // valueIRI
  var validate19instance1_10_2_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_10_2_1');
    var pathDiv = $('#item-path-19-instance-1_10_2_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_10_2_1').change( function() {
    var ok = validate19instance1_10_2_1();
    showError('item-error-19-instance-1_10_2_1',ok);
  });
  
  $('#remove-button-17-instance-1_10_3').click(function() {
    $('#repeating-enclosing-17-instance-1_10_3').hide();
  });

  $('#remove-button-18-instance-1_10_3_1').click(function() {
    $('#repeating-enclosing-18-instance-1_10_3_1').hide();
  });

  $('#item-18-instance-1_10_3_1').prop('checked',false);

  // value
  var validate18instance1_10_3_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_10_3_1');
    var pathDiv = $('#item-path-18-instance-1_10_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_10_3_1').change( function() {
    var ok = validate18instance1_10_3_1();
    showError('item-error-18-instance-1_10_3_1',ok);
  });
  
  $('#remove-button-19-instance-1_10_3_1').click(function() {
    $('#repeating-enclosing-19-instance-1_10_3_1').hide();
  });

  $('#item-19-instance-1_10_3_1').prop('checked',false);

  // valueIRI
  var validate19instance1_10_3_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_10_3_1');
    var pathDiv = $('#item-path-19-instance-1_10_3_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_10_3_1').change( function() {
    var ok = validate19instance1_10_3_1();
    showError('item-error-19-instance-1_10_3_1',ok);
  });
  
  $('#remove-button-17-instance-1_10_4').click(function() {
    $('#repeating-enclosing-17-instance-1_10_4').hide();
  });

  $('#remove-button-18-instance-1_10_4_1').click(function() {
    $('#repeating-enclosing-18-instance-1_10_4_1').hide();
  });

  $('#item-18-instance-1_10_4_1').prop('checked',false);

  // value
  var validate18instance1_10_4_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_10_4_1');
    var pathDiv = $('#item-path-18-instance-1_10_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_10_4_1').change( function() {
    var ok = validate18instance1_10_4_1();
    showError('item-error-18-instance-1_10_4_1',ok);
  });
  
  $('#remove-button-19-instance-1_10_4_1').click(function() {
    $('#repeating-enclosing-19-instance-1_10_4_1').hide();
  });

  $('#item-19-instance-1_10_4_1').prop('checked',false);

  // valueIRI
  var validate19instance1_10_4_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_10_4_1');
    var pathDiv = $('#item-path-19-instance-1_10_4_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_10_4_1').change( function() {
    var ok = validate19instance1_10_4_1();
    showError('item-error-19-instance-1_10_4_1',ok);
  });
  
  $('#remove-button-17-instance-1_10_5').click(function() {
    $('#repeating-enclosing-17-instance-1_10_5').hide();
  });

  $('#remove-button-18-instance-1_10_5_1').click(function() {
    $('#repeating-enclosing-18-instance-1_10_5_1').hide();
  });

  $('#item-18-instance-1_10_5_1').prop('checked',false);

  // value
  var validate18instance1_10_5_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_10_5_1');
    var pathDiv = $('#item-path-18-instance-1_10_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_10_5_1').change( function() {
    var ok = validate18instance1_10_5_1();
    showError('item-error-18-instance-1_10_5_1',ok);
  });
  
  $('#remove-button-19-instance-1_10_5_1').click(function() {
    $('#repeating-enclosing-19-instance-1_10_5_1').hide();
  });

  $('#item-19-instance-1_10_5_1').prop('checked',false);

  // valueIRI
  var validate19instance1_10_5_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_10_5_1');
    var pathDiv = $('#item-path-19-instance-1_10_5_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_10_5_1').change( function() {
    var ok = validate19instance1_10_5_1();
    showError('item-error-19-instance-1_10_5_1',ok);
  });
  
  $('#remove-button-17-instance-1_10_6').click(function() {
    $('#repeating-enclosing-17-instance-1_10_6').hide();
  });

  $('#remove-button-18-instance-1_10_6_1').click(function() {
    $('#repeating-enclosing-18-instance-1_10_6_1').hide();
  });

  $('#item-18-instance-1_10_6_1').prop('checked',false);

  // value
  var validate18instance1_10_6_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_10_6_1');
    var pathDiv = $('#item-path-18-instance-1_10_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_10_6_1').change( function() {
    var ok = validate18instance1_10_6_1();
    showError('item-error-18-instance-1_10_6_1',ok);
  });
  
  $('#remove-button-19-instance-1_10_6_1').click(function() {
    $('#repeating-enclosing-19-instance-1_10_6_1').hide();
  });

  $('#item-19-instance-1_10_6_1').prop('checked',false);

  // valueIRI
  var validate19instance1_10_6_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_10_6_1');
    var pathDiv = $('#item-path-19-instance-1_10_6_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_10_6_1').change( function() {
    var ok = validate19instance1_10_6_1();
    showError('item-error-19-instance-1_10_6_1',ok);
  });
  
  $('#remove-button-17-instance-1_10_7').click(function() {
    $('#repeating-enclosing-17-instance-1_10_7').hide();
  });

  $('#remove-button-18-instance-1_10_7_1').click(function() {
    $('#repeating-enclosing-18-instance-1_10_7_1').hide();
  });

  $('#item-18-instance-1_10_7_1').prop('checked',false);

  // value
  var validate18instance1_10_7_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_10_7_1');
    var pathDiv = $('#item-path-18-instance-1_10_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_10_7_1').change( function() {
    var ok = validate18instance1_10_7_1();
    showError('item-error-18-instance-1_10_7_1',ok);
  });
  
  $('#remove-button-19-instance-1_10_7_1').click(function() {
    $('#repeating-enclosing-19-instance-1_10_7_1').hide();
  });

  $('#item-19-instance-1_10_7_1').prop('checked',false);

  // valueIRI
  var validate19instance1_10_7_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_10_7_1');
    var pathDiv = $('#item-path-19-instance-1_10_7_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_10_7_1').change( function() {
    var ok = validate19instance1_10_7_1();
    showError('item-error-19-instance-1_10_7_1',ok);
  });
  
  $('#remove-button-17-instance-1_10_8').click(function() {
    $('#repeating-enclosing-17-instance-1_10_8').hide();
  });

  $('#remove-button-18-instance-1_10_8_1').click(function() {
    $('#repeating-enclosing-18-instance-1_10_8_1').hide();
  });

  $('#item-18-instance-1_10_8_1').prop('checked',false);

  // value
  var validate18instance1_10_8_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_10_8_1');
    var pathDiv = $('#item-path-18-instance-1_10_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_10_8_1').change( function() {
    var ok = validate18instance1_10_8_1();
    showError('item-error-18-instance-1_10_8_1',ok);
  });
  
  $('#remove-button-19-instance-1_10_8_1').click(function() {
    $('#repeating-enclosing-19-instance-1_10_8_1').hide();
  });

  $('#item-19-instance-1_10_8_1').prop('checked',false);

  // valueIRI
  var validate19instance1_10_8_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_10_8_1');
    var pathDiv = $('#item-path-19-instance-1_10_8_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_10_8_1').change( function() {
    var ok = validate19instance1_10_8_1();
    showError('item-error-19-instance-1_10_8_1',ok);
  });
  
  $('#remove-button-17-instance-1_10_9').click(function() {
    $('#repeating-enclosing-17-instance-1_10_9').hide();
  });

  $('#remove-button-18-instance-1_10_9_1').click(function() {
    $('#repeating-enclosing-18-instance-1_10_9_1').hide();
  });

  $('#item-18-instance-1_10_9_1').prop('checked',false);

  // value
  var validate18instance1_10_9_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_10_9_1');
    var pathDiv = $('#item-path-18-instance-1_10_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_10_9_1').change( function() {
    var ok = validate18instance1_10_9_1();
    showError('item-error-18-instance-1_10_9_1',ok);
  });
  
  $('#remove-button-19-instance-1_10_9_1').click(function() {
    $('#repeating-enclosing-19-instance-1_10_9_1').hide();
  });

  $('#item-19-instance-1_10_9_1').prop('checked',false);

  // valueIRI
  var validate19instance1_10_9_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_10_9_1');
    var pathDiv = $('#item-path-19-instance-1_10_9_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_10_9_1').change( function() {
    var ok = validate19instance1_10_9_1();
    showError('item-error-19-instance-1_10_9_1',ok);
  });
  
  $('#remove-button-17-instance-1_10_10').click(function() {
    $('#repeating-enclosing-17-instance-1_10_10').hide();
  });

  $('#remove-button-18-instance-1_10_10_1').click(function() {
    $('#repeating-enclosing-18-instance-1_10_10_1').hide();
  });

  $('#item-18-instance-1_10_10_1').prop('checked',false);

  // value
  var validate18instance1_10_10_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_10_10_1');
    var pathDiv = $('#item-path-18-instance-1_10_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-18-instance-1_10_10_1').change( function() {
    var ok = validate18instance1_10_10_1();
    showError('item-error-18-instance-1_10_10_1',ok);
  });
  
  $('#remove-button-19-instance-1_10_10_1').click(function() {
    $('#repeating-enclosing-19-instance-1_10_10_1').hide();
  });

  $('#item-19-instance-1_10_10_1').prop('checked',false);

  // valueIRI
  var validate19instance1_10_10_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_10_10_1');
    var pathDiv = $('#item-path-19-instance-1_10_10_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-19-instance-1_10_10_1').change( function() {
    var ok = validate19instance1_10_10_1();
    showError('item-error-19-instance-1_10_10_1',ok);
  });
  
  $('#repeat-button-17-instance-1_10').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-17-instance-1_10_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_10_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_10_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_10_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_10_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_10_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_10_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_10_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_10_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-17-instance-1_10_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#repeat-button-14-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-14-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-14-instance-1_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-14-instance-1_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-14-instance-1_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-14-instance-1_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-14-instance-1_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-14-instance-1_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-14-instance-1_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-14-instance-1_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-14-instance-1_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  //extract xml from element <identifier>
  function getXml3instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-3-instance-1_1_1')) {
    var v = encodedValueById("item-3-instance-1_1_1");
    xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml4instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-4-instance-1_1_1')) {
    var v = encodedValueById("item-4-instance-1_1_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml2instance1() {

    var xml = '\n' + spaces(2) + '<identifier>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-2-instance-1_1')) {
      xml += getXml3instance1_1();
      xml += getXml4instance1_1();
    }
    xml += '\n' + spaces(2) + '</identifier>';
    return xml;
  }

  //extract xml from element <name>
  function getXml5instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-5-instance-1_1')) {
    var v = encodedValueById("item-5-instance-1_1");
    xml += '\n' + spaces(2) + '<name>' + v + '</name>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml7instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-7-instance-1_1_1')) {
    var v = encodedValueById("item-7-instance-1_1_1");
    xml += '\n' + spaces(4) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml8instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-8-instance-1_1_1')) {
    var v = encodedValueById("item-8-instance-1_1_1");
    xml += '\n' + spaces(4) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <type>
  function getXml6instance1() {

    var xml = '\n' + spaces(2) + '<type>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-6-instance-1_1')) {
      xml += getXml7instance1_1();
      xml += getXml8instance1_1();
    }
    xml += '\n' + spaces(2) + '</type>';
    return xml;
  }

  //extract xml from element <identifier>
  function getXml10instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-10-instance-1_1_1')) {
    var v = encodedValueById("item-10-instance-1_1_1");
    xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml11instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-11-instance-1_1_1')) {
    var v = encodedValueById("item-11-instance-1_1_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <version>
  function getXml12instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-12-instance-1_1_1')) {
    var v = encodedValueById("item-12-instance-1_1_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml10instance1_2() {

  var xml='';
  if (idVisible('repeating-enclosing-10-instance-1_2_1')) {
    var v = encodedValueById("item-10-instance-1_2_1");
    xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml11instance1_2() {

  var xml='';
  if (idVisible('repeating-enclosing-11-instance-1_2_1')) {
    var v = encodedValueById("item-11-instance-1_2_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <version>
  function getXml12instance1_2() {

  var xml='';
  if (idVisible('repeating-enclosing-12-instance-1_2_1')) {
    var v = encodedValueById("item-12-instance-1_2_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml10instance1_3() {

  var xml='';
  if (idVisible('repeating-enclosing-10-instance-1_3_1')) {
    var v = encodedValueById("item-10-instance-1_3_1");
    xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml11instance1_3() {

  var xml='';
  if (idVisible('repeating-enclosing-11-instance-1_3_1')) {
    var v = encodedValueById("item-11-instance-1_3_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <version>
  function getXml12instance1_3() {

  var xml='';
  if (idVisible('repeating-enclosing-12-instance-1_3_1')) {
    var v = encodedValueById("item-12-instance-1_3_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml10instance1_4() {

  var xml='';
  if (idVisible('repeating-enclosing-10-instance-1_4_1')) {
    var v = encodedValueById("item-10-instance-1_4_1");
    xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml11instance1_4() {

  var xml='';
  if (idVisible('repeating-enclosing-11-instance-1_4_1')) {
    var v = encodedValueById("item-11-instance-1_4_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <version>
  function getXml12instance1_4() {

  var xml='';
  if (idVisible('repeating-enclosing-12-instance-1_4_1')) {
    var v = encodedValueById("item-12-instance-1_4_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml10instance1_5() {

  var xml='';
  if (idVisible('repeating-enclosing-10-instance-1_5_1')) {
    var v = encodedValueById("item-10-instance-1_5_1");
    xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml11instance1_5() {

  var xml='';
  if (idVisible('repeating-enclosing-11-instance-1_5_1')) {
    var v = encodedValueById("item-11-instance-1_5_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <version>
  function getXml12instance1_5() {

  var xml='';
  if (idVisible('repeating-enclosing-12-instance-1_5_1')) {
    var v = encodedValueById("item-12-instance-1_5_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml10instance1_6() {

  var xml='';
  if (idVisible('repeating-enclosing-10-instance-1_6_1')) {
    var v = encodedValueById("item-10-instance-1_6_1");
    xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml11instance1_6() {

  var xml='';
  if (idVisible('repeating-enclosing-11-instance-1_6_1')) {
    var v = encodedValueById("item-11-instance-1_6_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <version>
  function getXml12instance1_6() {

  var xml='';
  if (idVisible('repeating-enclosing-12-instance-1_6_1')) {
    var v = encodedValueById("item-12-instance-1_6_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml10instance1_7() {

  var xml='';
  if (idVisible('repeating-enclosing-10-instance-1_7_1')) {
    var v = encodedValueById("item-10-instance-1_7_1");
    xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml11instance1_7() {

  var xml='';
  if (idVisible('repeating-enclosing-11-instance-1_7_1')) {
    var v = encodedValueById("item-11-instance-1_7_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <version>
  function getXml12instance1_7() {

  var xml='';
  if (idVisible('repeating-enclosing-12-instance-1_7_1')) {
    var v = encodedValueById("item-12-instance-1_7_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml10instance1_8() {

  var xml='';
  if (idVisible('repeating-enclosing-10-instance-1_8_1')) {
    var v = encodedValueById("item-10-instance-1_8_1");
    xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml11instance1_8() {

  var xml='';
  if (idVisible('repeating-enclosing-11-instance-1_8_1')) {
    var v = encodedValueById("item-11-instance-1_8_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <version>
  function getXml12instance1_8() {

  var xml='';
  if (idVisible('repeating-enclosing-12-instance-1_8_1')) {
    var v = encodedValueById("item-12-instance-1_8_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml10instance1_9() {

  var xml='';
  if (idVisible('repeating-enclosing-10-instance-1_9_1')) {
    var v = encodedValueById("item-10-instance-1_9_1");
    xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml11instance1_9() {

  var xml='';
  if (idVisible('repeating-enclosing-11-instance-1_9_1')) {
    var v = encodedValueById("item-11-instance-1_9_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <version>
  function getXml12instance1_9() {

  var xml='';
  if (idVisible('repeating-enclosing-12-instance-1_9_1')) {
    var v = encodedValueById("item-12-instance-1_9_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml10instance1_10() {

  var xml='';
  if (idVisible('repeating-enclosing-10-instance-1_10_1')) {
    var v = encodedValueById("item-10-instance-1_10_1");
    xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml11instance1_10() {

  var xml='';
  if (idVisible('repeating-enclosing-11-instance-1_10_1')) {
    var v = encodedValueById("item-11-instance-1_10_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <version>
  function getXml12instance1_10() {

  var xml='';
  if (idVisible('repeating-enclosing-12-instance-1_10_1')) {
    var v = encodedValueById("item-12-instance-1_10_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <licenses>
  function getXml9instance1() {

if (!$('#min-occurs-zero-9-instance-1').is(':checked')) return '';
    var xml = '\n' + spaces(2) + '<licenses>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-9-instance-1_1')) {
      xml += getXml10instance1_1();
      xml += getXml11instance1_1();
      xml += getXml12instance1_1();
    }
    if (idVisible('repeating-enclosing-9-instance-1_2')) {
      xml += getXml10instance1_2();
      xml += getXml11instance1_2();
      xml += getXml12instance1_2();
    }
    if (idVisible('repeating-enclosing-9-instance-1_3')) {
      xml += getXml10instance1_3();
      xml += getXml11instance1_3();
      xml += getXml12instance1_3();
    }
    if (idVisible('repeating-enclosing-9-instance-1_4')) {
      xml += getXml10instance1_4();
      xml += getXml11instance1_4();
      xml += getXml12instance1_4();
    }
    if (idVisible('repeating-enclosing-9-instance-1_5')) {
      xml += getXml10instance1_5();
      xml += getXml11instance1_5();
      xml += getXml12instance1_5();
    }
    if (idVisible('repeating-enclosing-9-instance-1_6')) {
      xml += getXml10instance1_6();
      xml += getXml11instance1_6();
      xml += getXml12instance1_6();
    }
    if (idVisible('repeating-enclosing-9-instance-1_7')) {
      xml += getXml10instance1_7();
      xml += getXml11instance1_7();
      xml += getXml12instance1_7();
    }
    if (idVisible('repeating-enclosing-9-instance-1_8')) {
      xml += getXml10instance1_8();
      xml += getXml11instance1_8();
      xml += getXml12instance1_8();
    }
    if (idVisible('repeating-enclosing-9-instance-1_9')) {
      xml += getXml10instance1_9();
      xml += getXml11instance1_9();
      xml += getXml12instance1_9();
    }
    if (idVisible('repeating-enclosing-9-instance-1_10')) {
      xml += getXml10instance1_10();
      xml += getXml11instance1_10();
      xml += getXml12instance1_10();
    }
    xml += '\n' + spaces(2) + '</licenses>';
    return xml;
  }

  //extract xml from element <version>
  function getXml13instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-13-instance-1_1')) {
    var v = encodedValueById("item-13-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <category>
  function getXml15instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-15-instance-1_1_1')) {
    var v = encodedValueById("item-15-instance-1_1_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<category>' + v + '</category>';
  }
   return xml;
  }

  //extract xml from element <categoryIRI>
  function getXml16instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-16-instance-1_1_1')) {
    var v = encodedValueById("item-16-instance-1_1_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<categoryIRI>' + v + '</categoryIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_1_1_1')) {
    var v = encodedValueById("item-18-instance-1_1_1_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_1_1_1')) {
    var v = encodedValueById("item-19-instance-1_1_1_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_1_2() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_1_2_1')) {
    var v = encodedValueById("item-18-instance-1_1_2_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_1_2() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_1_2_1')) {
    var v = encodedValueById("item-19-instance-1_1_2_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_1_3() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_1_3_1')) {
    var v = encodedValueById("item-18-instance-1_1_3_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_1_3() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_1_3_1')) {
    var v = encodedValueById("item-19-instance-1_1_3_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_1_4() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_1_4_1')) {
    var v = encodedValueById("item-18-instance-1_1_4_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_1_4() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_1_4_1')) {
    var v = encodedValueById("item-19-instance-1_1_4_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_1_5() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_1_5_1')) {
    var v = encodedValueById("item-18-instance-1_1_5_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_1_5() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_1_5_1')) {
    var v = encodedValueById("item-19-instance-1_1_5_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_1_6() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_1_6_1')) {
    var v = encodedValueById("item-18-instance-1_1_6_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_1_6() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_1_6_1')) {
    var v = encodedValueById("item-19-instance-1_1_6_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_1_7() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_1_7_1')) {
    var v = encodedValueById("item-18-instance-1_1_7_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_1_7() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_1_7_1')) {
    var v = encodedValueById("item-19-instance-1_1_7_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_1_8() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_1_8_1')) {
    var v = encodedValueById("item-18-instance-1_1_8_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_1_8() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_1_8_1')) {
    var v = encodedValueById("item-19-instance-1_1_8_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_1_9() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_1_9_1')) {
    var v = encodedValueById("item-18-instance-1_1_9_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_1_9() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_1_9_1')) {
    var v = encodedValueById("item-19-instance-1_1_9_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_1_10() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_1_10_1')) {
    var v = encodedValueById("item-18-instance-1_1_10_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_1_10() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_1_10_1')) {
    var v = encodedValueById("item-19-instance-1_1_10_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <values>
  function getXml17instance1_1() {

if (!$('#min-occurs-zero-17-instance-1_1').is(':checked')) return '';
    var xml = '\n' + spaces(4) + '<values>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-17-instance-1_1_1')) {
      xml += getXml18instance1_1_1();
      xml += getXml19instance1_1_1();
    }
    if (idVisible('repeating-enclosing-17-instance-1_1_2')) {
      xml += getXml18instance1_1_2();
      xml += getXml19instance1_1_2();
    }
    if (idVisible('repeating-enclosing-17-instance-1_1_3')) {
      xml += getXml18instance1_1_3();
      xml += getXml19instance1_1_3();
    }
    if (idVisible('repeating-enclosing-17-instance-1_1_4')) {
      xml += getXml18instance1_1_4();
      xml += getXml19instance1_1_4();
    }
    if (idVisible('repeating-enclosing-17-instance-1_1_5')) {
      xml += getXml18instance1_1_5();
      xml += getXml19instance1_1_5();
    }
    if (idVisible('repeating-enclosing-17-instance-1_1_6')) {
      xml += getXml18instance1_1_6();
      xml += getXml19instance1_1_6();
    }
    if (idVisible('repeating-enclosing-17-instance-1_1_7')) {
      xml += getXml18instance1_1_7();
      xml += getXml19instance1_1_7();
    }
    if (idVisible('repeating-enclosing-17-instance-1_1_8')) {
      xml += getXml18instance1_1_8();
      xml += getXml19instance1_1_8();
    }
    if (idVisible('repeating-enclosing-17-instance-1_1_9')) {
      xml += getXml18instance1_1_9();
      xml += getXml19instance1_1_9();
    }
    if (idVisible('repeating-enclosing-17-instance-1_1_10')) {
      xml += getXml18instance1_1_10();
      xml += getXml19instance1_1_10();
    }
    xml += '\n' + spaces(4) + '</values>';
    return xml;
  }

  //extract xml from element <category>
  function getXml15instance1_2() {

  var xml='';
  if (idVisible('repeating-enclosing-15-instance-1_2_1')) {
    var v = encodedValueById("item-15-instance-1_2_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<category>' + v + '</category>';
  }
   return xml;
  }

  //extract xml from element <categoryIRI>
  function getXml16instance1_2() {

  var xml='';
  if (idVisible('repeating-enclosing-16-instance-1_2_1')) {
    var v = encodedValueById("item-16-instance-1_2_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<categoryIRI>' + v + '</categoryIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_2_1() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_2_1_1')) {
    var v = encodedValueById("item-18-instance-1_2_1_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_2_1() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_2_1_1')) {
    var v = encodedValueById("item-19-instance-1_2_1_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_2_2() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_2_2_1')) {
    var v = encodedValueById("item-18-instance-1_2_2_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_2_2() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_2_2_1')) {
    var v = encodedValueById("item-19-instance-1_2_2_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_2_3() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_2_3_1')) {
    var v = encodedValueById("item-18-instance-1_2_3_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_2_3() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_2_3_1')) {
    var v = encodedValueById("item-19-instance-1_2_3_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_2_4() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_2_4_1')) {
    var v = encodedValueById("item-18-instance-1_2_4_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_2_4() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_2_4_1')) {
    var v = encodedValueById("item-19-instance-1_2_4_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_2_5() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_2_5_1')) {
    var v = encodedValueById("item-18-instance-1_2_5_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_2_5() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_2_5_1')) {
    var v = encodedValueById("item-19-instance-1_2_5_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_2_6() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_2_6_1')) {
    var v = encodedValueById("item-18-instance-1_2_6_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_2_6() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_2_6_1')) {
    var v = encodedValueById("item-19-instance-1_2_6_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_2_7() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_2_7_1')) {
    var v = encodedValueById("item-18-instance-1_2_7_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_2_7() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_2_7_1')) {
    var v = encodedValueById("item-19-instance-1_2_7_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_2_8() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_2_8_1')) {
    var v = encodedValueById("item-18-instance-1_2_8_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_2_8() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_2_8_1')) {
    var v = encodedValueById("item-19-instance-1_2_8_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_2_9() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_2_9_1')) {
    var v = encodedValueById("item-18-instance-1_2_9_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_2_9() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_2_9_1')) {
    var v = encodedValueById("item-19-instance-1_2_9_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_2_10() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_2_10_1')) {
    var v = encodedValueById("item-18-instance-1_2_10_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_2_10() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_2_10_1')) {
    var v = encodedValueById("item-19-instance-1_2_10_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <values>
  function getXml17instance1_2() {

if (!$('#min-occurs-zero-17-instance-1_2').is(':checked')) return '';
    var xml = '\n' + spaces(4) + '<values>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-17-instance-1_2_1')) {
      xml += getXml18instance1_2_1();
      xml += getXml19instance1_2_1();
    }
    if (idVisible('repeating-enclosing-17-instance-1_2_2')) {
      xml += getXml18instance1_2_2();
      xml += getXml19instance1_2_2();
    }
    if (idVisible('repeating-enclosing-17-instance-1_2_3')) {
      xml += getXml18instance1_2_3();
      xml += getXml19instance1_2_3();
    }
    if (idVisible('repeating-enclosing-17-instance-1_2_4')) {
      xml += getXml18instance1_2_4();
      xml += getXml19instance1_2_4();
    }
    if (idVisible('repeating-enclosing-17-instance-1_2_5')) {
      xml += getXml18instance1_2_5();
      xml += getXml19instance1_2_5();
    }
    if (idVisible('repeating-enclosing-17-instance-1_2_6')) {
      xml += getXml18instance1_2_6();
      xml += getXml19instance1_2_6();
    }
    if (idVisible('repeating-enclosing-17-instance-1_2_7')) {
      xml += getXml18instance1_2_7();
      xml += getXml19instance1_2_7();
    }
    if (idVisible('repeating-enclosing-17-instance-1_2_8')) {
      xml += getXml18instance1_2_8();
      xml += getXml19instance1_2_8();
    }
    if (idVisible('repeating-enclosing-17-instance-1_2_9')) {
      xml += getXml18instance1_2_9();
      xml += getXml19instance1_2_9();
    }
    if (idVisible('repeating-enclosing-17-instance-1_2_10')) {
      xml += getXml18instance1_2_10();
      xml += getXml19instance1_2_10();
    }
    xml += '\n' + spaces(4) + '</values>';
    return xml;
  }

  //extract xml from element <category>
  function getXml15instance1_3() {

  var xml='';
  if (idVisible('repeating-enclosing-15-instance-1_3_1')) {
    var v = encodedValueById("item-15-instance-1_3_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<category>' + v + '</category>';
  }
   return xml;
  }

  //extract xml from element <categoryIRI>
  function getXml16instance1_3() {

  var xml='';
  if (idVisible('repeating-enclosing-16-instance-1_3_1')) {
    var v = encodedValueById("item-16-instance-1_3_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<categoryIRI>' + v + '</categoryIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_3_1() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_3_1_1')) {
    var v = encodedValueById("item-18-instance-1_3_1_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_3_1() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_3_1_1')) {
    var v = encodedValueById("item-19-instance-1_3_1_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_3_2() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_3_2_1')) {
    var v = encodedValueById("item-18-instance-1_3_2_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_3_2() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_3_2_1')) {
    var v = encodedValueById("item-19-instance-1_3_2_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_3_3() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_3_3_1')) {
    var v = encodedValueById("item-18-instance-1_3_3_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_3_3() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_3_3_1')) {
    var v = encodedValueById("item-19-instance-1_3_3_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_3_4() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_3_4_1')) {
    var v = encodedValueById("item-18-instance-1_3_4_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_3_4() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_3_4_1')) {
    var v = encodedValueById("item-19-instance-1_3_4_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_3_5() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_3_5_1')) {
    var v = encodedValueById("item-18-instance-1_3_5_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_3_5() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_3_5_1')) {
    var v = encodedValueById("item-19-instance-1_3_5_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_3_6() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_3_6_1')) {
    var v = encodedValueById("item-18-instance-1_3_6_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_3_6() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_3_6_1')) {
    var v = encodedValueById("item-19-instance-1_3_6_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_3_7() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_3_7_1')) {
    var v = encodedValueById("item-18-instance-1_3_7_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_3_7() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_3_7_1')) {
    var v = encodedValueById("item-19-instance-1_3_7_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_3_8() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_3_8_1')) {
    var v = encodedValueById("item-18-instance-1_3_8_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_3_8() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_3_8_1')) {
    var v = encodedValueById("item-19-instance-1_3_8_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_3_9() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_3_9_1')) {
    var v = encodedValueById("item-18-instance-1_3_9_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_3_9() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_3_9_1')) {
    var v = encodedValueById("item-19-instance-1_3_9_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_3_10() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_3_10_1')) {
    var v = encodedValueById("item-18-instance-1_3_10_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_3_10() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_3_10_1')) {
    var v = encodedValueById("item-19-instance-1_3_10_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <values>
  function getXml17instance1_3() {

if (!$('#min-occurs-zero-17-instance-1_3').is(':checked')) return '';
    var xml = '\n' + spaces(4) + '<values>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-17-instance-1_3_1')) {
      xml += getXml18instance1_3_1();
      xml += getXml19instance1_3_1();
    }
    if (idVisible('repeating-enclosing-17-instance-1_3_2')) {
      xml += getXml18instance1_3_2();
      xml += getXml19instance1_3_2();
    }
    if (idVisible('repeating-enclosing-17-instance-1_3_3')) {
      xml += getXml18instance1_3_3();
      xml += getXml19instance1_3_3();
    }
    if (idVisible('repeating-enclosing-17-instance-1_3_4')) {
      xml += getXml18instance1_3_4();
      xml += getXml19instance1_3_4();
    }
    if (idVisible('repeating-enclosing-17-instance-1_3_5')) {
      xml += getXml18instance1_3_5();
      xml += getXml19instance1_3_5();
    }
    if (idVisible('repeating-enclosing-17-instance-1_3_6')) {
      xml += getXml18instance1_3_6();
      xml += getXml19instance1_3_6();
    }
    if (idVisible('repeating-enclosing-17-instance-1_3_7')) {
      xml += getXml18instance1_3_7();
      xml += getXml19instance1_3_7();
    }
    if (idVisible('repeating-enclosing-17-instance-1_3_8')) {
      xml += getXml18instance1_3_8();
      xml += getXml19instance1_3_8();
    }
    if (idVisible('repeating-enclosing-17-instance-1_3_9')) {
      xml += getXml18instance1_3_9();
      xml += getXml19instance1_3_9();
    }
    if (idVisible('repeating-enclosing-17-instance-1_3_10')) {
      xml += getXml18instance1_3_10();
      xml += getXml19instance1_3_10();
    }
    xml += '\n' + spaces(4) + '</values>';
    return xml;
  }

  //extract xml from element <category>
  function getXml15instance1_4() {

  var xml='';
  if (idVisible('repeating-enclosing-15-instance-1_4_1')) {
    var v = encodedValueById("item-15-instance-1_4_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<category>' + v + '</category>';
  }
   return xml;
  }

  //extract xml from element <categoryIRI>
  function getXml16instance1_4() {

  var xml='';
  if (idVisible('repeating-enclosing-16-instance-1_4_1')) {
    var v = encodedValueById("item-16-instance-1_4_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<categoryIRI>' + v + '</categoryIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_4_1() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_4_1_1')) {
    var v = encodedValueById("item-18-instance-1_4_1_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_4_1() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_4_1_1')) {
    var v = encodedValueById("item-19-instance-1_4_1_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_4_2() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_4_2_1')) {
    var v = encodedValueById("item-18-instance-1_4_2_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_4_2() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_4_2_1')) {
    var v = encodedValueById("item-19-instance-1_4_2_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_4_3() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_4_3_1')) {
    var v = encodedValueById("item-18-instance-1_4_3_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_4_3() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_4_3_1')) {
    var v = encodedValueById("item-19-instance-1_4_3_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_4_4() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_4_4_1')) {
    var v = encodedValueById("item-18-instance-1_4_4_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_4_4() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_4_4_1')) {
    var v = encodedValueById("item-19-instance-1_4_4_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_4_5() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_4_5_1')) {
    var v = encodedValueById("item-18-instance-1_4_5_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_4_5() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_4_5_1')) {
    var v = encodedValueById("item-19-instance-1_4_5_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_4_6() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_4_6_1')) {
    var v = encodedValueById("item-18-instance-1_4_6_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_4_6() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_4_6_1')) {
    var v = encodedValueById("item-19-instance-1_4_6_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_4_7() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_4_7_1')) {
    var v = encodedValueById("item-18-instance-1_4_7_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_4_7() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_4_7_1')) {
    var v = encodedValueById("item-19-instance-1_4_7_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_4_8() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_4_8_1')) {
    var v = encodedValueById("item-18-instance-1_4_8_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_4_8() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_4_8_1')) {
    var v = encodedValueById("item-19-instance-1_4_8_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_4_9() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_4_9_1')) {
    var v = encodedValueById("item-18-instance-1_4_9_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_4_9() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_4_9_1')) {
    var v = encodedValueById("item-19-instance-1_4_9_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_4_10() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_4_10_1')) {
    var v = encodedValueById("item-18-instance-1_4_10_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_4_10() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_4_10_1')) {
    var v = encodedValueById("item-19-instance-1_4_10_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <values>
  function getXml17instance1_4() {

if (!$('#min-occurs-zero-17-instance-1_4').is(':checked')) return '';
    var xml = '\n' + spaces(4) + '<values>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-17-instance-1_4_1')) {
      xml += getXml18instance1_4_1();
      xml += getXml19instance1_4_1();
    }
    if (idVisible('repeating-enclosing-17-instance-1_4_2')) {
      xml += getXml18instance1_4_2();
      xml += getXml19instance1_4_2();
    }
    if (idVisible('repeating-enclosing-17-instance-1_4_3')) {
      xml += getXml18instance1_4_3();
      xml += getXml19instance1_4_3();
    }
    if (idVisible('repeating-enclosing-17-instance-1_4_4')) {
      xml += getXml18instance1_4_4();
      xml += getXml19instance1_4_4();
    }
    if (idVisible('repeating-enclosing-17-instance-1_4_5')) {
      xml += getXml18instance1_4_5();
      xml += getXml19instance1_4_5();
    }
    if (idVisible('repeating-enclosing-17-instance-1_4_6')) {
      xml += getXml18instance1_4_6();
      xml += getXml19instance1_4_6();
    }
    if (idVisible('repeating-enclosing-17-instance-1_4_7')) {
      xml += getXml18instance1_4_7();
      xml += getXml19instance1_4_7();
    }
    if (idVisible('repeating-enclosing-17-instance-1_4_8')) {
      xml += getXml18instance1_4_8();
      xml += getXml19instance1_4_8();
    }
    if (idVisible('repeating-enclosing-17-instance-1_4_9')) {
      xml += getXml18instance1_4_9();
      xml += getXml19instance1_4_9();
    }
    if (idVisible('repeating-enclosing-17-instance-1_4_10')) {
      xml += getXml18instance1_4_10();
      xml += getXml19instance1_4_10();
    }
    xml += '\n' + spaces(4) + '</values>';
    return xml;
  }

  //extract xml from element <category>
  function getXml15instance1_5() {

  var xml='';
  if (idVisible('repeating-enclosing-15-instance-1_5_1')) {
    var v = encodedValueById("item-15-instance-1_5_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<category>' + v + '</category>';
  }
   return xml;
  }

  //extract xml from element <categoryIRI>
  function getXml16instance1_5() {

  var xml='';
  if (idVisible('repeating-enclosing-16-instance-1_5_1')) {
    var v = encodedValueById("item-16-instance-1_5_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<categoryIRI>' + v + '</categoryIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_5_1() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_5_1_1')) {
    var v = encodedValueById("item-18-instance-1_5_1_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_5_1() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_5_1_1')) {
    var v = encodedValueById("item-19-instance-1_5_1_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_5_2() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_5_2_1')) {
    var v = encodedValueById("item-18-instance-1_5_2_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_5_2() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_5_2_1')) {
    var v = encodedValueById("item-19-instance-1_5_2_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_5_3() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_5_3_1')) {
    var v = encodedValueById("item-18-instance-1_5_3_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_5_3() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_5_3_1')) {
    var v = encodedValueById("item-19-instance-1_5_3_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_5_4() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_5_4_1')) {
    var v = encodedValueById("item-18-instance-1_5_4_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_5_4() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_5_4_1')) {
    var v = encodedValueById("item-19-instance-1_5_4_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_5_5() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_5_5_1')) {
    var v = encodedValueById("item-18-instance-1_5_5_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_5_5() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_5_5_1')) {
    var v = encodedValueById("item-19-instance-1_5_5_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_5_6() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_5_6_1')) {
    var v = encodedValueById("item-18-instance-1_5_6_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_5_6() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_5_6_1')) {
    var v = encodedValueById("item-19-instance-1_5_6_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_5_7() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_5_7_1')) {
    var v = encodedValueById("item-18-instance-1_5_7_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_5_7() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_5_7_1')) {
    var v = encodedValueById("item-19-instance-1_5_7_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_5_8() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_5_8_1')) {
    var v = encodedValueById("item-18-instance-1_5_8_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_5_8() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_5_8_1')) {
    var v = encodedValueById("item-19-instance-1_5_8_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_5_9() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_5_9_1')) {
    var v = encodedValueById("item-18-instance-1_5_9_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_5_9() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_5_9_1')) {
    var v = encodedValueById("item-19-instance-1_5_9_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_5_10() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_5_10_1')) {
    var v = encodedValueById("item-18-instance-1_5_10_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_5_10() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_5_10_1')) {
    var v = encodedValueById("item-19-instance-1_5_10_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <values>
  function getXml17instance1_5() {

if (!$('#min-occurs-zero-17-instance-1_5').is(':checked')) return '';
    var xml = '\n' + spaces(4) + '<values>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-17-instance-1_5_1')) {
      xml += getXml18instance1_5_1();
      xml += getXml19instance1_5_1();
    }
    if (idVisible('repeating-enclosing-17-instance-1_5_2')) {
      xml += getXml18instance1_5_2();
      xml += getXml19instance1_5_2();
    }
    if (idVisible('repeating-enclosing-17-instance-1_5_3')) {
      xml += getXml18instance1_5_3();
      xml += getXml19instance1_5_3();
    }
    if (idVisible('repeating-enclosing-17-instance-1_5_4')) {
      xml += getXml18instance1_5_4();
      xml += getXml19instance1_5_4();
    }
    if (idVisible('repeating-enclosing-17-instance-1_5_5')) {
      xml += getXml18instance1_5_5();
      xml += getXml19instance1_5_5();
    }
    if (idVisible('repeating-enclosing-17-instance-1_5_6')) {
      xml += getXml18instance1_5_6();
      xml += getXml19instance1_5_6();
    }
    if (idVisible('repeating-enclosing-17-instance-1_5_7')) {
      xml += getXml18instance1_5_7();
      xml += getXml19instance1_5_7();
    }
    if (idVisible('repeating-enclosing-17-instance-1_5_8')) {
      xml += getXml18instance1_5_8();
      xml += getXml19instance1_5_8();
    }
    if (idVisible('repeating-enclosing-17-instance-1_5_9')) {
      xml += getXml18instance1_5_9();
      xml += getXml19instance1_5_9();
    }
    if (idVisible('repeating-enclosing-17-instance-1_5_10')) {
      xml += getXml18instance1_5_10();
      xml += getXml19instance1_5_10();
    }
    xml += '\n' + spaces(4) + '</values>';
    return xml;
  }

  //extract xml from element <category>
  function getXml15instance1_6() {

  var xml='';
  if (idVisible('repeating-enclosing-15-instance-1_6_1')) {
    var v = encodedValueById("item-15-instance-1_6_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<category>' + v + '</category>';
  }
   return xml;
  }

  //extract xml from element <categoryIRI>
  function getXml16instance1_6() {

  var xml='';
  if (idVisible('repeating-enclosing-16-instance-1_6_1')) {
    var v = encodedValueById("item-16-instance-1_6_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<categoryIRI>' + v + '</categoryIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_6_1() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_6_1_1')) {
    var v = encodedValueById("item-18-instance-1_6_1_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_6_1() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_6_1_1')) {
    var v = encodedValueById("item-19-instance-1_6_1_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_6_2() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_6_2_1')) {
    var v = encodedValueById("item-18-instance-1_6_2_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_6_2() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_6_2_1')) {
    var v = encodedValueById("item-19-instance-1_6_2_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_6_3() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_6_3_1')) {
    var v = encodedValueById("item-18-instance-1_6_3_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_6_3() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_6_3_1')) {
    var v = encodedValueById("item-19-instance-1_6_3_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_6_4() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_6_4_1')) {
    var v = encodedValueById("item-18-instance-1_6_4_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_6_4() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_6_4_1')) {
    var v = encodedValueById("item-19-instance-1_6_4_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_6_5() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_6_5_1')) {
    var v = encodedValueById("item-18-instance-1_6_5_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_6_5() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_6_5_1')) {
    var v = encodedValueById("item-19-instance-1_6_5_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_6_6() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_6_6_1')) {
    var v = encodedValueById("item-18-instance-1_6_6_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_6_6() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_6_6_1')) {
    var v = encodedValueById("item-19-instance-1_6_6_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_6_7() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_6_7_1')) {
    var v = encodedValueById("item-18-instance-1_6_7_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_6_7() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_6_7_1')) {
    var v = encodedValueById("item-19-instance-1_6_7_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_6_8() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_6_8_1')) {
    var v = encodedValueById("item-18-instance-1_6_8_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_6_8() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_6_8_1')) {
    var v = encodedValueById("item-19-instance-1_6_8_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_6_9() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_6_9_1')) {
    var v = encodedValueById("item-18-instance-1_6_9_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_6_9() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_6_9_1')) {
    var v = encodedValueById("item-19-instance-1_6_9_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_6_10() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_6_10_1')) {
    var v = encodedValueById("item-18-instance-1_6_10_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_6_10() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_6_10_1')) {
    var v = encodedValueById("item-19-instance-1_6_10_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <values>
  function getXml17instance1_6() {

if (!$('#min-occurs-zero-17-instance-1_6').is(':checked')) return '';
    var xml = '\n' + spaces(4) + '<values>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-17-instance-1_6_1')) {
      xml += getXml18instance1_6_1();
      xml += getXml19instance1_6_1();
    }
    if (idVisible('repeating-enclosing-17-instance-1_6_2')) {
      xml += getXml18instance1_6_2();
      xml += getXml19instance1_6_2();
    }
    if (idVisible('repeating-enclosing-17-instance-1_6_3')) {
      xml += getXml18instance1_6_3();
      xml += getXml19instance1_6_3();
    }
    if (idVisible('repeating-enclosing-17-instance-1_6_4')) {
      xml += getXml18instance1_6_4();
      xml += getXml19instance1_6_4();
    }
    if (idVisible('repeating-enclosing-17-instance-1_6_5')) {
      xml += getXml18instance1_6_5();
      xml += getXml19instance1_6_5();
    }
    if (idVisible('repeating-enclosing-17-instance-1_6_6')) {
      xml += getXml18instance1_6_6();
      xml += getXml19instance1_6_6();
    }
    if (idVisible('repeating-enclosing-17-instance-1_6_7')) {
      xml += getXml18instance1_6_7();
      xml += getXml19instance1_6_7();
    }
    if (idVisible('repeating-enclosing-17-instance-1_6_8')) {
      xml += getXml18instance1_6_8();
      xml += getXml19instance1_6_8();
    }
    if (idVisible('repeating-enclosing-17-instance-1_6_9')) {
      xml += getXml18instance1_6_9();
      xml += getXml19instance1_6_9();
    }
    if (idVisible('repeating-enclosing-17-instance-1_6_10')) {
      xml += getXml18instance1_6_10();
      xml += getXml19instance1_6_10();
    }
    xml += '\n' + spaces(4) + '</values>';
    return xml;
  }

  //extract xml from element <category>
  function getXml15instance1_7() {

  var xml='';
  if (idVisible('repeating-enclosing-15-instance-1_7_1')) {
    var v = encodedValueById("item-15-instance-1_7_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<category>' + v + '</category>';
  }
   return xml;
  }

  //extract xml from element <categoryIRI>
  function getXml16instance1_7() {

  var xml='';
  if (idVisible('repeating-enclosing-16-instance-1_7_1')) {
    var v = encodedValueById("item-16-instance-1_7_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<categoryIRI>' + v + '</categoryIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_7_1() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_7_1_1')) {
    var v = encodedValueById("item-18-instance-1_7_1_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_7_1() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_7_1_1')) {
    var v = encodedValueById("item-19-instance-1_7_1_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_7_2() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_7_2_1')) {
    var v = encodedValueById("item-18-instance-1_7_2_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_7_2() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_7_2_1')) {
    var v = encodedValueById("item-19-instance-1_7_2_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_7_3() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_7_3_1')) {
    var v = encodedValueById("item-18-instance-1_7_3_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_7_3() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_7_3_1')) {
    var v = encodedValueById("item-19-instance-1_7_3_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_7_4() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_7_4_1')) {
    var v = encodedValueById("item-18-instance-1_7_4_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_7_4() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_7_4_1')) {
    var v = encodedValueById("item-19-instance-1_7_4_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_7_5() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_7_5_1')) {
    var v = encodedValueById("item-18-instance-1_7_5_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_7_5() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_7_5_1')) {
    var v = encodedValueById("item-19-instance-1_7_5_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_7_6() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_7_6_1')) {
    var v = encodedValueById("item-18-instance-1_7_6_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_7_6() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_7_6_1')) {
    var v = encodedValueById("item-19-instance-1_7_6_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_7_7() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_7_7_1')) {
    var v = encodedValueById("item-18-instance-1_7_7_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_7_7() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_7_7_1')) {
    var v = encodedValueById("item-19-instance-1_7_7_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_7_8() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_7_8_1')) {
    var v = encodedValueById("item-18-instance-1_7_8_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_7_8() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_7_8_1')) {
    var v = encodedValueById("item-19-instance-1_7_8_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_7_9() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_7_9_1')) {
    var v = encodedValueById("item-18-instance-1_7_9_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_7_9() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_7_9_1')) {
    var v = encodedValueById("item-19-instance-1_7_9_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_7_10() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_7_10_1')) {
    var v = encodedValueById("item-18-instance-1_7_10_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_7_10() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_7_10_1')) {
    var v = encodedValueById("item-19-instance-1_7_10_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <values>
  function getXml17instance1_7() {

if (!$('#min-occurs-zero-17-instance-1_7').is(':checked')) return '';
    var xml = '\n' + spaces(4) + '<values>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-17-instance-1_7_1')) {
      xml += getXml18instance1_7_1();
      xml += getXml19instance1_7_1();
    }
    if (idVisible('repeating-enclosing-17-instance-1_7_2')) {
      xml += getXml18instance1_7_2();
      xml += getXml19instance1_7_2();
    }
    if (idVisible('repeating-enclosing-17-instance-1_7_3')) {
      xml += getXml18instance1_7_3();
      xml += getXml19instance1_7_3();
    }
    if (idVisible('repeating-enclosing-17-instance-1_7_4')) {
      xml += getXml18instance1_7_4();
      xml += getXml19instance1_7_4();
    }
    if (idVisible('repeating-enclosing-17-instance-1_7_5')) {
      xml += getXml18instance1_7_5();
      xml += getXml19instance1_7_5();
    }
    if (idVisible('repeating-enclosing-17-instance-1_7_6')) {
      xml += getXml18instance1_7_6();
      xml += getXml19instance1_7_6();
    }
    if (idVisible('repeating-enclosing-17-instance-1_7_7')) {
      xml += getXml18instance1_7_7();
      xml += getXml19instance1_7_7();
    }
    if (idVisible('repeating-enclosing-17-instance-1_7_8')) {
      xml += getXml18instance1_7_8();
      xml += getXml19instance1_7_8();
    }
    if (idVisible('repeating-enclosing-17-instance-1_7_9')) {
      xml += getXml18instance1_7_9();
      xml += getXml19instance1_7_9();
    }
    if (idVisible('repeating-enclosing-17-instance-1_7_10')) {
      xml += getXml18instance1_7_10();
      xml += getXml19instance1_7_10();
    }
    xml += '\n' + spaces(4) + '</values>';
    return xml;
  }

  //extract xml from element <category>
  function getXml15instance1_8() {

  var xml='';
  if (idVisible('repeating-enclosing-15-instance-1_8_1')) {
    var v = encodedValueById("item-15-instance-1_8_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<category>' + v + '</category>';
  }
   return xml;
  }

  //extract xml from element <categoryIRI>
  function getXml16instance1_8() {

  var xml='';
  if (idVisible('repeating-enclosing-16-instance-1_8_1')) {
    var v = encodedValueById("item-16-instance-1_8_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<categoryIRI>' + v + '</categoryIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_8_1() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_8_1_1')) {
    var v = encodedValueById("item-18-instance-1_8_1_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_8_1() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_8_1_1')) {
    var v = encodedValueById("item-19-instance-1_8_1_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_8_2() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_8_2_1')) {
    var v = encodedValueById("item-18-instance-1_8_2_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_8_2() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_8_2_1')) {
    var v = encodedValueById("item-19-instance-1_8_2_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_8_3() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_8_3_1')) {
    var v = encodedValueById("item-18-instance-1_8_3_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_8_3() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_8_3_1')) {
    var v = encodedValueById("item-19-instance-1_8_3_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_8_4() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_8_4_1')) {
    var v = encodedValueById("item-18-instance-1_8_4_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_8_4() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_8_4_1')) {
    var v = encodedValueById("item-19-instance-1_8_4_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_8_5() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_8_5_1')) {
    var v = encodedValueById("item-18-instance-1_8_5_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_8_5() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_8_5_1')) {
    var v = encodedValueById("item-19-instance-1_8_5_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_8_6() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_8_6_1')) {
    var v = encodedValueById("item-18-instance-1_8_6_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_8_6() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_8_6_1')) {
    var v = encodedValueById("item-19-instance-1_8_6_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_8_7() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_8_7_1')) {
    var v = encodedValueById("item-18-instance-1_8_7_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_8_7() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_8_7_1')) {
    var v = encodedValueById("item-19-instance-1_8_7_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_8_8() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_8_8_1')) {
    var v = encodedValueById("item-18-instance-1_8_8_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_8_8() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_8_8_1')) {
    var v = encodedValueById("item-19-instance-1_8_8_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_8_9() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_8_9_1')) {
    var v = encodedValueById("item-18-instance-1_8_9_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_8_9() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_8_9_1')) {
    var v = encodedValueById("item-19-instance-1_8_9_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_8_10() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_8_10_1')) {
    var v = encodedValueById("item-18-instance-1_8_10_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_8_10() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_8_10_1')) {
    var v = encodedValueById("item-19-instance-1_8_10_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <values>
  function getXml17instance1_8() {

if (!$('#min-occurs-zero-17-instance-1_8').is(':checked')) return '';
    var xml = '\n' + spaces(4) + '<values>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-17-instance-1_8_1')) {
      xml += getXml18instance1_8_1();
      xml += getXml19instance1_8_1();
    }
    if (idVisible('repeating-enclosing-17-instance-1_8_2')) {
      xml += getXml18instance1_8_2();
      xml += getXml19instance1_8_2();
    }
    if (idVisible('repeating-enclosing-17-instance-1_8_3')) {
      xml += getXml18instance1_8_3();
      xml += getXml19instance1_8_3();
    }
    if (idVisible('repeating-enclosing-17-instance-1_8_4')) {
      xml += getXml18instance1_8_4();
      xml += getXml19instance1_8_4();
    }
    if (idVisible('repeating-enclosing-17-instance-1_8_5')) {
      xml += getXml18instance1_8_5();
      xml += getXml19instance1_8_5();
    }
    if (idVisible('repeating-enclosing-17-instance-1_8_6')) {
      xml += getXml18instance1_8_6();
      xml += getXml19instance1_8_6();
    }
    if (idVisible('repeating-enclosing-17-instance-1_8_7')) {
      xml += getXml18instance1_8_7();
      xml += getXml19instance1_8_7();
    }
    if (idVisible('repeating-enclosing-17-instance-1_8_8')) {
      xml += getXml18instance1_8_8();
      xml += getXml19instance1_8_8();
    }
    if (idVisible('repeating-enclosing-17-instance-1_8_9')) {
      xml += getXml18instance1_8_9();
      xml += getXml19instance1_8_9();
    }
    if (idVisible('repeating-enclosing-17-instance-1_8_10')) {
      xml += getXml18instance1_8_10();
      xml += getXml19instance1_8_10();
    }
    xml += '\n' + spaces(4) + '</values>';
    return xml;
  }

  //extract xml from element <category>
  function getXml15instance1_9() {

  var xml='';
  if (idVisible('repeating-enclosing-15-instance-1_9_1')) {
    var v = encodedValueById("item-15-instance-1_9_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<category>' + v + '</category>';
  }
   return xml;
  }

  //extract xml from element <categoryIRI>
  function getXml16instance1_9() {

  var xml='';
  if (idVisible('repeating-enclosing-16-instance-1_9_1')) {
    var v = encodedValueById("item-16-instance-1_9_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<categoryIRI>' + v + '</categoryIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_9_1() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_9_1_1')) {
    var v = encodedValueById("item-18-instance-1_9_1_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_9_1() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_9_1_1')) {
    var v = encodedValueById("item-19-instance-1_9_1_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_9_2() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_9_2_1')) {
    var v = encodedValueById("item-18-instance-1_9_2_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_9_2() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_9_2_1')) {
    var v = encodedValueById("item-19-instance-1_9_2_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_9_3() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_9_3_1')) {
    var v = encodedValueById("item-18-instance-1_9_3_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_9_3() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_9_3_1')) {
    var v = encodedValueById("item-19-instance-1_9_3_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_9_4() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_9_4_1')) {
    var v = encodedValueById("item-18-instance-1_9_4_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_9_4() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_9_4_1')) {
    var v = encodedValueById("item-19-instance-1_9_4_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_9_5() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_9_5_1')) {
    var v = encodedValueById("item-18-instance-1_9_5_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_9_5() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_9_5_1')) {
    var v = encodedValueById("item-19-instance-1_9_5_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_9_6() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_9_6_1')) {
    var v = encodedValueById("item-18-instance-1_9_6_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_9_6() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_9_6_1')) {
    var v = encodedValueById("item-19-instance-1_9_6_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_9_7() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_9_7_1')) {
    var v = encodedValueById("item-18-instance-1_9_7_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_9_7() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_9_7_1')) {
    var v = encodedValueById("item-19-instance-1_9_7_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_9_8() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_9_8_1')) {
    var v = encodedValueById("item-18-instance-1_9_8_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_9_8() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_9_8_1')) {
    var v = encodedValueById("item-19-instance-1_9_8_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_9_9() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_9_9_1')) {
    var v = encodedValueById("item-18-instance-1_9_9_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_9_9() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_9_9_1')) {
    var v = encodedValueById("item-19-instance-1_9_9_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_9_10() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_9_10_1')) {
    var v = encodedValueById("item-18-instance-1_9_10_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_9_10() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_9_10_1')) {
    var v = encodedValueById("item-19-instance-1_9_10_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <values>
  function getXml17instance1_9() {

if (!$('#min-occurs-zero-17-instance-1_9').is(':checked')) return '';
    var xml = '\n' + spaces(4) + '<values>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-17-instance-1_9_1')) {
      xml += getXml18instance1_9_1();
      xml += getXml19instance1_9_1();
    }
    if (idVisible('repeating-enclosing-17-instance-1_9_2')) {
      xml += getXml18instance1_9_2();
      xml += getXml19instance1_9_2();
    }
    if (idVisible('repeating-enclosing-17-instance-1_9_3')) {
      xml += getXml18instance1_9_3();
      xml += getXml19instance1_9_3();
    }
    if (idVisible('repeating-enclosing-17-instance-1_9_4')) {
      xml += getXml18instance1_9_4();
      xml += getXml19instance1_9_4();
    }
    if (idVisible('repeating-enclosing-17-instance-1_9_5')) {
      xml += getXml18instance1_9_5();
      xml += getXml19instance1_9_5();
    }
    if (idVisible('repeating-enclosing-17-instance-1_9_6')) {
      xml += getXml18instance1_9_6();
      xml += getXml19instance1_9_6();
    }
    if (idVisible('repeating-enclosing-17-instance-1_9_7')) {
      xml += getXml18instance1_9_7();
      xml += getXml19instance1_9_7();
    }
    if (idVisible('repeating-enclosing-17-instance-1_9_8')) {
      xml += getXml18instance1_9_8();
      xml += getXml19instance1_9_8();
    }
    if (idVisible('repeating-enclosing-17-instance-1_9_9')) {
      xml += getXml18instance1_9_9();
      xml += getXml19instance1_9_9();
    }
    if (idVisible('repeating-enclosing-17-instance-1_9_10')) {
      xml += getXml18instance1_9_10();
      xml += getXml19instance1_9_10();
    }
    xml += '\n' + spaces(4) + '</values>';
    return xml;
  }

  //extract xml from element <category>
  function getXml15instance1_10() {

  var xml='';
  if (idVisible('repeating-enclosing-15-instance-1_10_1')) {
    var v = encodedValueById("item-15-instance-1_10_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<category>' + v + '</category>';
  }
   return xml;
  }

  //extract xml from element <categoryIRI>
  function getXml16instance1_10() {

  var xml='';
  if (idVisible('repeating-enclosing-16-instance-1_10_1')) {
    var v = encodedValueById("item-16-instance-1_10_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<categoryIRI>' + v + '</categoryIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_10_1() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_10_1_1')) {
    var v = encodedValueById("item-18-instance-1_10_1_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_10_1() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_10_1_1')) {
    var v = encodedValueById("item-19-instance-1_10_1_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_10_2() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_10_2_1')) {
    var v = encodedValueById("item-18-instance-1_10_2_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_10_2() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_10_2_1')) {
    var v = encodedValueById("item-19-instance-1_10_2_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_10_3() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_10_3_1')) {
    var v = encodedValueById("item-18-instance-1_10_3_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_10_3() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_10_3_1')) {
    var v = encodedValueById("item-19-instance-1_10_3_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_10_4() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_10_4_1')) {
    var v = encodedValueById("item-18-instance-1_10_4_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_10_4() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_10_4_1')) {
    var v = encodedValueById("item-19-instance-1_10_4_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_10_5() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_10_5_1')) {
    var v = encodedValueById("item-18-instance-1_10_5_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_10_5() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_10_5_1')) {
    var v = encodedValueById("item-19-instance-1_10_5_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_10_6() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_10_6_1')) {
    var v = encodedValueById("item-18-instance-1_10_6_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_10_6() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_10_6_1')) {
    var v = encodedValueById("item-19-instance-1_10_6_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_10_7() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_10_7_1')) {
    var v = encodedValueById("item-18-instance-1_10_7_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_10_7() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_10_7_1')) {
    var v = encodedValueById("item-19-instance-1_10_7_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_10_8() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_10_8_1')) {
    var v = encodedValueById("item-18-instance-1_10_8_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_10_8() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_10_8_1')) {
    var v = encodedValueById("item-19-instance-1_10_8_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_10_9() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_10_9_1')) {
    var v = encodedValueById("item-18-instance-1_10_9_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_10_9() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_10_9_1')) {
    var v = encodedValueById("item-19-instance-1_10_9_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <value>
  function getXml18instance1_10_10() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_10_10_1')) {
    var v = encodedValueById("item-18-instance-1_10_10_1");
    xml += '\n' + spaces(6) + '<value>' + v + '</value>';
  }
   return xml;
  }

  //extract xml from element <valueIRI>
  function getXml19instance1_10_10() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_10_10_1')) {
    var v = encodedValueById("item-19-instance-1_10_10_1");
    xml += '\n' + spaces(6) + '<valueIRI>' + v + '</valueIRI>';
  }
   return xml;
  }

  //extract xml from element <values>
  function getXml17instance1_10() {

if (!$('#min-occurs-zero-17-instance-1_10').is(':checked')) return '';
    var xml = '\n' + spaces(4) + '<values>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-17-instance-1_10_1')) {
      xml += getXml18instance1_10_1();
      xml += getXml19instance1_10_1();
    }
    if (idVisible('repeating-enclosing-17-instance-1_10_2')) {
      xml += getXml18instance1_10_2();
      xml += getXml19instance1_10_2();
    }
    if (idVisible('repeating-enclosing-17-instance-1_10_3')) {
      xml += getXml18instance1_10_3();
      xml += getXml19instance1_10_3();
    }
    if (idVisible('repeating-enclosing-17-instance-1_10_4')) {
      xml += getXml18instance1_10_4();
      xml += getXml19instance1_10_4();
    }
    if (idVisible('repeating-enclosing-17-instance-1_10_5')) {
      xml += getXml18instance1_10_5();
      xml += getXml19instance1_10_5();
    }
    if (idVisible('repeating-enclosing-17-instance-1_10_6')) {
      xml += getXml18instance1_10_6();
      xml += getXml19instance1_10_6();
    }
    if (idVisible('repeating-enclosing-17-instance-1_10_7')) {
      xml += getXml18instance1_10_7();
      xml += getXml19instance1_10_7();
    }
    if (idVisible('repeating-enclosing-17-instance-1_10_8')) {
      xml += getXml18instance1_10_8();
      xml += getXml19instance1_10_8();
    }
    if (idVisible('repeating-enclosing-17-instance-1_10_9')) {
      xml += getXml18instance1_10_9();
      xml += getXml19instance1_10_9();
    }
    if (idVisible('repeating-enclosing-17-instance-1_10_10')) {
      xml += getXml18instance1_10_10();
      xml += getXml19instance1_10_10();
    }
    xml += '\n' + spaces(4) + '</values>';
    return xml;
  }

  //extract xml from element <extraProperties>
  function getXml14instance1() {

if (!$('#min-occurs-zero-14-instance-1').is(':checked')) return '';
    var xml = '\n' + spaces(2) + '<extraProperties>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-14-instance-1_1')) {
      xml += getXml15instance1_1();
      xml += getXml16instance1_1();
      xml += getXml17instance1_1();
    }
    if (idVisible('repeating-enclosing-14-instance-1_2')) {
      xml += getXml15instance1_2();
      xml += getXml16instance1_2();
      xml += getXml17instance1_2();
    }
    if (idVisible('repeating-enclosing-14-instance-1_3')) {
      xml += getXml15instance1_3();
      xml += getXml16instance1_3();
      xml += getXml17instance1_3();
    }
    if (idVisible('repeating-enclosing-14-instance-1_4')) {
      xml += getXml15instance1_4();
      xml += getXml16instance1_4();
      xml += getXml17instance1_4();
    }
    if (idVisible('repeating-enclosing-14-instance-1_5')) {
      xml += getXml15instance1_5();
      xml += getXml16instance1_5();
      xml += getXml17instance1_5();
    }
    if (idVisible('repeating-enclosing-14-instance-1_6')) {
      xml += getXml15instance1_6();
      xml += getXml16instance1_6();
      xml += getXml17instance1_6();
    }
    if (idVisible('repeating-enclosing-14-instance-1_7')) {
      xml += getXml15instance1_7();
      xml += getXml16instance1_7();
      xml += getXml17instance1_7();
    }
    if (idVisible('repeating-enclosing-14-instance-1_8')) {
      xml += getXml15instance1_8();
      xml += getXml16instance1_8();
      xml += getXml17instance1_8();
    }
    if (idVisible('repeating-enclosing-14-instance-1_9')) {
      xml += getXml15instance1_9();
      xml += getXml16instance1_9();
      xml += getXml17instance1_9();
    }
    if (idVisible('repeating-enclosing-14-instance-1_10')) {
      xml += getXml15instance1_10();
      xml += getXml16instance1_10();
      xml += getXml17instance1_10();
    }
    xml += '\n' + spaces(2) + '</extraProperties>';
    return xml;
  }

  //extract xml from element <DataStandard>
  function getXml1instance() {

    var xml = '\n' + spaces(0) + '<DataStandard xmlns="http://mdc.isg.pitt.edu/dats2_2/">';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-1-instance-1')) {
      xml += getXml2instance1();
      xml += getXml5instance1();
      xml += getXml6instance1();
      xml += getXml9instance1();
      xml += getXml13instance1();
      xml += getXml14instance1();
    }
    xml += '\n' + spaces(0) + '</DataStandard>';
    return xml;
  }


            $("#form").submit(function () { return false; }); // so it won't submit

            

        });
    </script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/xsd-forms/js/xsd-forms-override.js"></script>
</head>
<c:choose>
    <c:when test="${preview eq true}">
        <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="true" preview="true" wantCollapse="true" iframe="false"></myTags:header>
    </c:when>
    <c:otherwise>
        <myTags:header pageTitle="MIDAS Digital Commons" loggedIn="true" preview="false" wantCollapse="true" iframe="false"></myTags:header>

    </c:otherwise>
</c:choose>
<body>
<div class="form">
    
    <div id="start"></div>
    <form method="POST" action="form.html" name="form">

        
  <div id="item-enclosing-1-instance-1" class="sequence">
    <div id="repeating-enclosing-1-instance-1" class="repeating-enclosing">
      <div class="sequence-label">Data Standard</div>
      <div id="sequence-1-instance-1" class="sequence-content">
        <div id="item-enclosing-2-instance-1_1" class="sequence">
          <div id="repeating-enclosing-2-instance-1_1" class="repeating-enclosing">
            <div class="sequence-label">Identifier</div>
            <div id="sequence-2-instance-1" class="sequence-content">
              <div id="item-enclosing-3-instance-1_1_1" class="item-enclosing">
                <div id="repeating-enclosing-3-instance-1_1_1" class="repeating-enclosing">
                  <div class="item-number">3</div>
                  <label class="item-label" for="item-input-3-instance-1_1_1">Identifier</label>
                  <div class="item-input">
                    <input number="3" name="item-input-3-instance-1_1_1" id="item-3-instance-1_1_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-3-instance-1_1_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-3-instance-1_1_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-4-instance-1_1_1" class="item-enclosing">
                <div id="repeat-button-4-instance-1_1" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-4-instance-1_1_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-4-instance-1_1_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">4</div>
                  <label class="item-label" for="item-input-4-instance-1_1_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="4" name="item-input-4-instance-1_1_1" id="item-4-instance-1_1_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-4-instance-1_1_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-4-instance-1_1_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div id="item-enclosing-5-instance-1_1" class="item-enclosing">
          <div id="repeating-enclosing-5-instance-1_1" class="repeating-enclosing">
            <div class="item-number">5</div>
            <label class="item-label" for="item-input-5-instance-1_1">Name</label>
            <div class="item-input">
              <input number="5" name="item-input-5-instance-1_1" id="item-5-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-5-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-5-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-6-instance-1_1" class="sequence">
          <div id="repeating-enclosing-6-instance-1_1" class="repeating-enclosing">
            <div class="sequence-label">Type</div>
            <div id="sequence-6-instance-1" class="sequence-content">
              <div id="item-enclosing-7-instance-1_1_1" class="item-enclosing">
                <div id="repeating-enclosing-7-instance-1_1_1" class="repeating-enclosing">
                  <div class="item-number">7</div>
                  <label class="item-label" for="item-input-7-instance-1_1_1">Value</label>
                  <div class="item-input">
                    <input number="7" name="item-input-7-instance-1_1_1" id="item-7-instance-1_1_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-7-instance-1_1_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-7-instance-1_1_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-8-instance-1_1_1" class="item-enclosing">
                <div id="repeating-enclosing-8-instance-1_1_1" class="repeating-enclosing">
                  <div class="item-number">8</div>
                  <label class="item-label" for="item-input-8-instance-1_1_1">Value IRI</label>
                  <div class="item-input">
                    <input number="8" name="item-input-8-instance-1_1_1" id="item-8-instance-1_1_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-8-instance-1_1_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-8-instance-1_1_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div id="item-enclosing-9-instance-1_1" class="sequence">
          <div class="min-occurs-zero-container invisible">
            <div class="min-occurs-zero-label">Click to enable</div>
            <input number="9" name="min-occurs-zero-name9-instance-1" checked="true" id="min-occurs-zero-9-instance-1" class="min-occurs-zero" type="checkbox">
            </input>
          </div>
          <div id="repeat-button-9-instance-1" class="btn btn-sm btn-default">Add Licenses</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-9-instance-1_1" class="repeating-enclosing invisible">
            <div class="sequence-label">Licenses</div>
            <div id="sequence-9-instance-1" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-9-instance-1_1" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-10-instance-1_1_1" class="item-enclosing">
                <div id="repeating-enclosing-10-instance-1_1_1" class="repeating-enclosing">
                  <div class="item-number">10</div>
                  <label class="item-label" for="item-input-10-instance-1_1_1">Identifier</label>
                  <div class="item-input">
                    <input number="10" name="item-input-10-instance-1_1_1" id="item-10-instance-1_1_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-10-instance-1_1_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-10-instance-1_1_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-11-instance-1_1_1" class="item-enclosing">
                <div id="repeat-button-11-instance-1_1" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-11-instance-1_1_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-11-instance-1_1_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">11</div>
                  <label class="item-label" for="item-input-11-instance-1_1_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="11" name="item-input-11-instance-1_1_1" id="item-11-instance-1_1_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-11-instance-1_1_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-11-instance-1_1_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-12-instance-1_1_1" class="item-enclosing">
                <div id="repeat-button-12-instance-1_1" class="btn btn-sm btn-default">Add Version</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-12-instance-1_1_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-12-instance-1_1_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">12</div>
                  <label class="item-label" for="item-input-12-instance-1_1_1">Version</label>
                  <div class="item-input">
                    <input number="12" name="item-input-12-instance-1_1_1" id="item-12-instance-1_1_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-12-instance-1_1_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-12-instance-1_1_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-9-instance-1_2" class="repeating-enclosing invisible">
            <div class="sequence-label">Licenses</div>
            <div id="sequence-9-instance-2" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-9-instance-1_2" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-10-instance-1_2_1" class="item-enclosing">
                <div id="repeating-enclosing-10-instance-1_2_1" class="repeating-enclosing">
                  <div class="item-number">10</div>
                  <label class="item-label" for="item-input-10-instance-1_2_1">Identifier</label>
                  <div class="item-input">
                    <input number="10" name="item-input-10-instance-1_2_1" id="item-10-instance-1_2_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-10-instance-1_2_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-10-instance-1_2_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-11-instance-1_2_1" class="item-enclosing">
                <div id="repeat-button-11-instance-1_2" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-11-instance-1_2_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-11-instance-1_2_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">11</div>
                  <label class="item-label" for="item-input-11-instance-1_2_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="11" name="item-input-11-instance-1_2_1" id="item-11-instance-1_2_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-11-instance-1_2_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-11-instance-1_2_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-12-instance-1_2_1" class="item-enclosing">
                <div id="repeat-button-12-instance-1_2" class="btn btn-sm btn-default">Add Version</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-12-instance-1_2_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-12-instance-1_2_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">12</div>
                  <label class="item-label" for="item-input-12-instance-1_2_1">Version</label>
                  <div class="item-input">
                    <input number="12" name="item-input-12-instance-1_2_1" id="item-12-instance-1_2_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-12-instance-1_2_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-12-instance-1_2_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-9-instance-1_3" class="repeating-enclosing invisible">
            <div class="sequence-label">Licenses</div>
            <div id="sequence-9-instance-3" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-9-instance-1_3" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-10-instance-1_3_1" class="item-enclosing">
                <div id="repeating-enclosing-10-instance-1_3_1" class="repeating-enclosing">
                  <div class="item-number">10</div>
                  <label class="item-label" for="item-input-10-instance-1_3_1">Identifier</label>
                  <div class="item-input">
                    <input number="10" name="item-input-10-instance-1_3_1" id="item-10-instance-1_3_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-10-instance-1_3_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-10-instance-1_3_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-11-instance-1_3_1" class="item-enclosing">
                <div id="repeat-button-11-instance-1_3" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-11-instance-1_3_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-11-instance-1_3_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">11</div>
                  <label class="item-label" for="item-input-11-instance-1_3_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="11" name="item-input-11-instance-1_3_1" id="item-11-instance-1_3_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-11-instance-1_3_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-11-instance-1_3_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-12-instance-1_3_1" class="item-enclosing">
                <div id="repeat-button-12-instance-1_3" class="btn btn-sm btn-default">Add Version</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-12-instance-1_3_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-12-instance-1_3_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">12</div>
                  <label class="item-label" for="item-input-12-instance-1_3_1">Version</label>
                  <div class="item-input">
                    <input number="12" name="item-input-12-instance-1_3_1" id="item-12-instance-1_3_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-12-instance-1_3_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-12-instance-1_3_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-9-instance-1_4" class="repeating-enclosing invisible">
            <div class="sequence-label">Licenses</div>
            <div id="sequence-9-instance-4" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-9-instance-1_4" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-10-instance-1_4_1" class="item-enclosing">
                <div id="repeating-enclosing-10-instance-1_4_1" class="repeating-enclosing">
                  <div class="item-number">10</div>
                  <label class="item-label" for="item-input-10-instance-1_4_1">Identifier</label>
                  <div class="item-input">
                    <input number="10" name="item-input-10-instance-1_4_1" id="item-10-instance-1_4_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-10-instance-1_4_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-10-instance-1_4_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-11-instance-1_4_1" class="item-enclosing">
                <div id="repeat-button-11-instance-1_4" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-11-instance-1_4_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-11-instance-1_4_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">11</div>
                  <label class="item-label" for="item-input-11-instance-1_4_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="11" name="item-input-11-instance-1_4_1" id="item-11-instance-1_4_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-11-instance-1_4_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-11-instance-1_4_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-12-instance-1_4_1" class="item-enclosing">
                <div id="repeat-button-12-instance-1_4" class="btn btn-sm btn-default">Add Version</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-12-instance-1_4_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-12-instance-1_4_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">12</div>
                  <label class="item-label" for="item-input-12-instance-1_4_1">Version</label>
                  <div class="item-input">
                    <input number="12" name="item-input-12-instance-1_4_1" id="item-12-instance-1_4_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-12-instance-1_4_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-12-instance-1_4_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-9-instance-1_5" class="repeating-enclosing invisible">
            <div class="sequence-label">Licenses</div>
            <div id="sequence-9-instance-5" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-9-instance-1_5" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-10-instance-1_5_1" class="item-enclosing">
                <div id="repeating-enclosing-10-instance-1_5_1" class="repeating-enclosing">
                  <div class="item-number">10</div>
                  <label class="item-label" for="item-input-10-instance-1_5_1">Identifier</label>
                  <div class="item-input">
                    <input number="10" name="item-input-10-instance-1_5_1" id="item-10-instance-1_5_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-10-instance-1_5_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-10-instance-1_5_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-11-instance-1_5_1" class="item-enclosing">
                <div id="repeat-button-11-instance-1_5" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-11-instance-1_5_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-11-instance-1_5_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">11</div>
                  <label class="item-label" for="item-input-11-instance-1_5_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="11" name="item-input-11-instance-1_5_1" id="item-11-instance-1_5_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-11-instance-1_5_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-11-instance-1_5_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-12-instance-1_5_1" class="item-enclosing">
                <div id="repeat-button-12-instance-1_5" class="btn btn-sm btn-default">Add Version</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-12-instance-1_5_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-12-instance-1_5_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">12</div>
                  <label class="item-label" for="item-input-12-instance-1_5_1">Version</label>
                  <div class="item-input">
                    <input number="12" name="item-input-12-instance-1_5_1" id="item-12-instance-1_5_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-12-instance-1_5_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-12-instance-1_5_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-9-instance-1_6" class="repeating-enclosing invisible">
            <div class="sequence-label">Licenses</div>
            <div id="sequence-9-instance-6" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-9-instance-1_6" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-10-instance-1_6_1" class="item-enclosing">
                <div id="repeating-enclosing-10-instance-1_6_1" class="repeating-enclosing">
                  <div class="item-number">10</div>
                  <label class="item-label" for="item-input-10-instance-1_6_1">Identifier</label>
                  <div class="item-input">
                    <input number="10" name="item-input-10-instance-1_6_1" id="item-10-instance-1_6_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-10-instance-1_6_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-10-instance-1_6_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-11-instance-1_6_1" class="item-enclosing">
                <div id="repeat-button-11-instance-1_6" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-11-instance-1_6_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-11-instance-1_6_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">11</div>
                  <label class="item-label" for="item-input-11-instance-1_6_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="11" name="item-input-11-instance-1_6_1" id="item-11-instance-1_6_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-11-instance-1_6_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-11-instance-1_6_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-12-instance-1_6_1" class="item-enclosing">
                <div id="repeat-button-12-instance-1_6" class="btn btn-sm btn-default">Add Version</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-12-instance-1_6_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-12-instance-1_6_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">12</div>
                  <label class="item-label" for="item-input-12-instance-1_6_1">Version</label>
                  <div class="item-input">
                    <input number="12" name="item-input-12-instance-1_6_1" id="item-12-instance-1_6_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-12-instance-1_6_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-12-instance-1_6_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-9-instance-1_7" class="repeating-enclosing invisible">
            <div class="sequence-label">Licenses</div>
            <div id="sequence-9-instance-7" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-9-instance-1_7" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-10-instance-1_7_1" class="item-enclosing">
                <div id="repeating-enclosing-10-instance-1_7_1" class="repeating-enclosing">
                  <div class="item-number">10</div>
                  <label class="item-label" for="item-input-10-instance-1_7_1">Identifier</label>
                  <div class="item-input">
                    <input number="10" name="item-input-10-instance-1_7_1" id="item-10-instance-1_7_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-10-instance-1_7_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-10-instance-1_7_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-11-instance-1_7_1" class="item-enclosing">
                <div id="repeat-button-11-instance-1_7" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-11-instance-1_7_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-11-instance-1_7_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">11</div>
                  <label class="item-label" for="item-input-11-instance-1_7_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="11" name="item-input-11-instance-1_7_1" id="item-11-instance-1_7_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-11-instance-1_7_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-11-instance-1_7_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-12-instance-1_7_1" class="item-enclosing">
                <div id="repeat-button-12-instance-1_7" class="btn btn-sm btn-default">Add Version</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-12-instance-1_7_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-12-instance-1_7_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">12</div>
                  <label class="item-label" for="item-input-12-instance-1_7_1">Version</label>
                  <div class="item-input">
                    <input number="12" name="item-input-12-instance-1_7_1" id="item-12-instance-1_7_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-12-instance-1_7_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-12-instance-1_7_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-9-instance-1_8" class="repeating-enclosing invisible">
            <div class="sequence-label">Licenses</div>
            <div id="sequence-9-instance-8" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-9-instance-1_8" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-10-instance-1_8_1" class="item-enclosing">
                <div id="repeating-enclosing-10-instance-1_8_1" class="repeating-enclosing">
                  <div class="item-number">10</div>
                  <label class="item-label" for="item-input-10-instance-1_8_1">Identifier</label>
                  <div class="item-input">
                    <input number="10" name="item-input-10-instance-1_8_1" id="item-10-instance-1_8_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-10-instance-1_8_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-10-instance-1_8_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-11-instance-1_8_1" class="item-enclosing">
                <div id="repeat-button-11-instance-1_8" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-11-instance-1_8_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-11-instance-1_8_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">11</div>
                  <label class="item-label" for="item-input-11-instance-1_8_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="11" name="item-input-11-instance-1_8_1" id="item-11-instance-1_8_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-11-instance-1_8_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-11-instance-1_8_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-12-instance-1_8_1" class="item-enclosing">
                <div id="repeat-button-12-instance-1_8" class="btn btn-sm btn-default">Add Version</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-12-instance-1_8_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-12-instance-1_8_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">12</div>
                  <label class="item-label" for="item-input-12-instance-1_8_1">Version</label>
                  <div class="item-input">
                    <input number="12" name="item-input-12-instance-1_8_1" id="item-12-instance-1_8_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-12-instance-1_8_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-12-instance-1_8_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-9-instance-1_9" class="repeating-enclosing invisible">
            <div class="sequence-label">Licenses</div>
            <div id="sequence-9-instance-9" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-9-instance-1_9" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-10-instance-1_9_1" class="item-enclosing">
                <div id="repeating-enclosing-10-instance-1_9_1" class="repeating-enclosing">
                  <div class="item-number">10</div>
                  <label class="item-label" for="item-input-10-instance-1_9_1">Identifier</label>
                  <div class="item-input">
                    <input number="10" name="item-input-10-instance-1_9_1" id="item-10-instance-1_9_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-10-instance-1_9_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-10-instance-1_9_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-11-instance-1_9_1" class="item-enclosing">
                <div id="repeat-button-11-instance-1_9" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-11-instance-1_9_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-11-instance-1_9_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">11</div>
                  <label class="item-label" for="item-input-11-instance-1_9_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="11" name="item-input-11-instance-1_9_1" id="item-11-instance-1_9_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-11-instance-1_9_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-11-instance-1_9_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-12-instance-1_9_1" class="item-enclosing">
                <div id="repeat-button-12-instance-1_9" class="btn btn-sm btn-default">Add Version</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-12-instance-1_9_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-12-instance-1_9_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">12</div>
                  <label class="item-label" for="item-input-12-instance-1_9_1">Version</label>
                  <div class="item-input">
                    <input number="12" name="item-input-12-instance-1_9_1" id="item-12-instance-1_9_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-12-instance-1_9_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-12-instance-1_9_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-9-instance-1_10" class="repeating-enclosing invisible">
            <div class="sequence-label">Licenses</div>
            <div id="sequence-9-instance-10" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-9-instance-1_10" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-10-instance-1_10_1" class="item-enclosing">
                <div id="repeating-enclosing-10-instance-1_10_1" class="repeating-enclosing">
                  <div class="item-number">10</div>
                  <label class="item-label" for="item-input-10-instance-1_10_1">Identifier</label>
                  <div class="item-input">
                    <input number="10" name="item-input-10-instance-1_10_1" id="item-10-instance-1_10_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-10-instance-1_10_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-10-instance-1_10_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-11-instance-1_10_1" class="item-enclosing">
                <div id="repeat-button-11-instance-1_10" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-11-instance-1_10_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-11-instance-1_10_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">11</div>
                  <label class="item-label" for="item-input-11-instance-1_10_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="11" name="item-input-11-instance-1_10_1" id="item-11-instance-1_10_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-11-instance-1_10_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-11-instance-1_10_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-12-instance-1_10_1" class="item-enclosing">
                <div id="repeat-button-12-instance-1_10" class="btn btn-sm btn-default">Add Version</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-12-instance-1_10_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-12-instance-1_10_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">12</div>
                  <label class="item-label" for="item-input-12-instance-1_10_1">Version</label>
                  <div class="item-input">
                    <input number="12" name="item-input-12-instance-1_10_1" id="item-12-instance-1_10_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-12-instance-1_10_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-12-instance-1_10_1" class="item-error">Invalid</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div id="item-enclosing-13-instance-1_1" class="item-enclosing">
          <div id="repeat-button-13-instance-1" class="btn btn-sm btn-default">Add Version</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-13-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-13-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">13</div>
            <label class="item-label" for="item-input-13-instance-1_1">Version</label>
            <div class="item-input">
              <input number="13" name="item-input-13-instance-1_1" id="item-13-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-13-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-13-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-14-instance-1_1" class="sequence">
          <div class="min-occurs-zero-container invisible">
            <div class="min-occurs-zero-label">Click to enable</div>
            <input number="14" name="min-occurs-zero-name14-instance-1" checked="true" id="min-occurs-zero-14-instance-1" class="min-occurs-zero" type="checkbox">
            </input>
          </div>
          <div id="repeat-button-14-instance-1" class="btn btn-sm btn-default">Add Extra Properties</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-14-instance-1_1" class="repeating-enclosing invisible">
            <div class="sequence-label">Extra Properties</div>
            <div id="sequence-14-instance-1" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-14-instance-1_1" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-15-instance-1_1_1" class="item-enclosing">
                <div id="repeat-button-15-instance-1_1" class="btn btn-sm btn-default">Add Category</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-15-instance-1_1_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-15-instance-1_1_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">15</div>
                  <label class="item-label" for="item-input-15-instance-1_1_1">Category</label>
                  <div class="item-input">
                    <input number="15" name="item-input-15-instance-1_1_1" id="item-15-instance-1_1_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-15-instance-1_1_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-15-instance-1_1_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-16-instance-1_1_1" class="item-enclosing">
                <div id="repeat-button-16-instance-1_1" class="btn btn-sm btn-default">Add Category Iri</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-16-instance-1_1_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-16-instance-1_1_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">16</div>
                  <label class="item-label" for="item-input-16-instance-1_1_1">Category IRI</label>
                  <div class="item-input">
                    <input number="16" name="item-input-16-instance-1_1_1" id="item-16-instance-1_1_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-16-instance-1_1_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-16-instance-1_1_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-17-instance-1_1_1" class="sequence">
                <div class="min-occurs-zero-container invisible">
                  <div class="min-occurs-zero-label">Click to enable</div>
                  <input number="17" name="min-occurs-zero-name17-instance-1_1" checked="true" id="min-occurs-zero-17-instance-1_1" class="min-occurs-zero" type="checkbox">
                  </input>
                </div>
                <div id="repeat-button-17-instance-1_1" class="btn btn-sm btn-default">Add Values</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-17-instance-1_1_1" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-1" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_1_1" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_1_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_1_1_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_1_1_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_1_1_1" id="item-18-instance-1_1_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_1_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_1_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_1_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_1_1_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_1_1_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_1_1_1" id="item-19-instance-1_1_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_1_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_1_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_1_2" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-2" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_1_2" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_1_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_1_2_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_1_2_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_1_2_1" id="item-18-instance-1_1_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_1_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_1_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_1_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_1_2_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_1_2_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_1_2_1" id="item-19-instance-1_1_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_1_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_1_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_1_3" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-3" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_1_3" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_1_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_1_3_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_1_3_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_1_3_1" id="item-18-instance-1_1_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_1_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_1_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_1_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_1_3_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_1_3_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_1_3_1" id="item-19-instance-1_1_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_1_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_1_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_1_4" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-4" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_1_4" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_1_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_1_4_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_1_4_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_1_4_1" id="item-18-instance-1_1_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_1_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_1_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_1_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_1_4_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_1_4_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_1_4_1" id="item-19-instance-1_1_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_1_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_1_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_1_5" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-5" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_1_5" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_1_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_1_5_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_1_5_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_1_5_1" id="item-18-instance-1_1_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_1_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_1_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_1_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_1_5_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_1_5_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_1_5_1" id="item-19-instance-1_1_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_1_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_1_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_1_6" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-6" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_1_6" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_1_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_1_6_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_1_6_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_1_6_1" id="item-18-instance-1_1_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_1_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_1_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_1_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_1_6_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_1_6_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_1_6_1" id="item-19-instance-1_1_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_1_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_1_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_1_7" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-7" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_1_7" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_1_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_1_7_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_1_7_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_1_7_1" id="item-18-instance-1_1_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_1_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_1_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_1_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_1_7_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_1_7_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_1_7_1" id="item-19-instance-1_1_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_1_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_1_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_1_8" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-8" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_1_8" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_1_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_1_8_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_1_8_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_1_8_1" id="item-18-instance-1_1_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_1_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_1_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_1_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_1_8_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_1_8_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_1_8_1" id="item-19-instance-1_1_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_1_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_1_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_1_9" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-9" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_1_9" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_1_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_1_9_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_1_9_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_1_9_1" id="item-18-instance-1_1_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_1_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_1_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_1_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_1_9_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_1_9_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_1_9_1" id="item-19-instance-1_1_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_1_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_1_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_1_10" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-10" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_1_10" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_1_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_1_10_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_1_10_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_1_10_1" id="item-18-instance-1_1_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_1_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_1_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_1_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_1_10_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_1_10_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_1_10_1" id="item-19-instance-1_1_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_1_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_1_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-14-instance-1_2" class="repeating-enclosing invisible">
            <div class="sequence-label">Extra Properties</div>
            <div id="sequence-14-instance-2" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-14-instance-1_2" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-15-instance-1_2_1" class="item-enclosing">
                <div id="repeat-button-15-instance-1_2" class="btn btn-sm btn-default">Add Category</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-15-instance-1_2_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-15-instance-1_2_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">15</div>
                  <label class="item-label" for="item-input-15-instance-1_2_1">Category</label>
                  <div class="item-input">
                    <input number="15" name="item-input-15-instance-1_2_1" id="item-15-instance-1_2_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-15-instance-1_2_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-15-instance-1_2_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-16-instance-1_2_1" class="item-enclosing">
                <div id="repeat-button-16-instance-1_2" class="btn btn-sm btn-default">Add Category Iri</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-16-instance-1_2_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-16-instance-1_2_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">16</div>
                  <label class="item-label" for="item-input-16-instance-1_2_1">Category IRI</label>
                  <div class="item-input">
                    <input number="16" name="item-input-16-instance-1_2_1" id="item-16-instance-1_2_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-16-instance-1_2_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-16-instance-1_2_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-17-instance-1_2_1" class="sequence">
                <div class="min-occurs-zero-container invisible">
                  <div class="min-occurs-zero-label">Click to enable</div>
                  <input number="17" name="min-occurs-zero-name17-instance-1_2" checked="true" id="min-occurs-zero-17-instance-1_2" class="min-occurs-zero" type="checkbox">
                  </input>
                </div>
                <div id="repeat-button-17-instance-1_2" class="btn btn-sm btn-default">Add Values</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-17-instance-1_2_1" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-1" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_2_1" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_2_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_2_1_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_2_1_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_2_1_1" id="item-18-instance-1_2_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_2_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_2_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_2_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_2_1_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_2_1_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_2_1_1" id="item-19-instance-1_2_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_2_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_2_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_2_2" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-2" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_2_2" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_2_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_2_2_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_2_2_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_2_2_1" id="item-18-instance-1_2_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_2_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_2_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_2_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_2_2_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_2_2_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_2_2_1" id="item-19-instance-1_2_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_2_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_2_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_2_3" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-3" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_2_3" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_2_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_2_3_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_2_3_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_2_3_1" id="item-18-instance-1_2_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_2_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_2_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_2_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_2_3_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_2_3_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_2_3_1" id="item-19-instance-1_2_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_2_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_2_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_2_4" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-4" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_2_4" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_2_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_2_4_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_2_4_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_2_4_1" id="item-18-instance-1_2_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_2_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_2_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_2_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_2_4_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_2_4_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_2_4_1" id="item-19-instance-1_2_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_2_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_2_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_2_5" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-5" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_2_5" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_2_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_2_5_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_2_5_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_2_5_1" id="item-18-instance-1_2_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_2_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_2_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_2_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_2_5_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_2_5_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_2_5_1" id="item-19-instance-1_2_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_2_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_2_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_2_6" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-6" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_2_6" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_2_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_2_6_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_2_6_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_2_6_1" id="item-18-instance-1_2_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_2_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_2_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_2_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_2_6_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_2_6_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_2_6_1" id="item-19-instance-1_2_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_2_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_2_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_2_7" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-7" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_2_7" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_2_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_2_7_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_2_7_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_2_7_1" id="item-18-instance-1_2_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_2_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_2_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_2_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_2_7_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_2_7_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_2_7_1" id="item-19-instance-1_2_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_2_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_2_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_2_8" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-8" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_2_8" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_2_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_2_8_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_2_8_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_2_8_1" id="item-18-instance-1_2_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_2_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_2_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_2_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_2_8_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_2_8_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_2_8_1" id="item-19-instance-1_2_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_2_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_2_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_2_9" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-9" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_2_9" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_2_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_2_9_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_2_9_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_2_9_1" id="item-18-instance-1_2_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_2_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_2_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_2_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_2_9_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_2_9_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_2_9_1" id="item-19-instance-1_2_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_2_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_2_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_2_10" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-10" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_2_10" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_2_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_2_10_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_2_10_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_2_10_1" id="item-18-instance-1_2_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_2_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_2_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_2_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_2_10_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_2_10_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_2_10_1" id="item-19-instance-1_2_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_2_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_2_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-14-instance-1_3" class="repeating-enclosing invisible">
            <div class="sequence-label">Extra Properties</div>
            <div id="sequence-14-instance-3" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-14-instance-1_3" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-15-instance-1_3_1" class="item-enclosing">
                <div id="repeat-button-15-instance-1_3" class="btn btn-sm btn-default">Add Category</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-15-instance-1_3_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-15-instance-1_3_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">15</div>
                  <label class="item-label" for="item-input-15-instance-1_3_1">Category</label>
                  <div class="item-input">
                    <input number="15" name="item-input-15-instance-1_3_1" id="item-15-instance-1_3_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-15-instance-1_3_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-15-instance-1_3_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-16-instance-1_3_1" class="item-enclosing">
                <div id="repeat-button-16-instance-1_3" class="btn btn-sm btn-default">Add Category Iri</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-16-instance-1_3_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-16-instance-1_3_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">16</div>
                  <label class="item-label" for="item-input-16-instance-1_3_1">Category IRI</label>
                  <div class="item-input">
                    <input number="16" name="item-input-16-instance-1_3_1" id="item-16-instance-1_3_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-16-instance-1_3_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-16-instance-1_3_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-17-instance-1_3_1" class="sequence">
                <div class="min-occurs-zero-container invisible">
                  <div class="min-occurs-zero-label">Click to enable</div>
                  <input number="17" name="min-occurs-zero-name17-instance-1_3" checked="true" id="min-occurs-zero-17-instance-1_3" class="min-occurs-zero" type="checkbox">
                  </input>
                </div>
                <div id="repeat-button-17-instance-1_3" class="btn btn-sm btn-default">Add Values</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-17-instance-1_3_1" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-1" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_3_1" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_3_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_3_1_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_3_1_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_3_1_1" id="item-18-instance-1_3_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_3_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_3_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_3_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_3_1_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_3_1_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_3_1_1" id="item-19-instance-1_3_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_3_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_3_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_3_2" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-2" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_3_2" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_3_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_3_2_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_3_2_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_3_2_1" id="item-18-instance-1_3_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_3_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_3_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_3_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_3_2_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_3_2_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_3_2_1" id="item-19-instance-1_3_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_3_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_3_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_3_3" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-3" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_3_3" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_3_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_3_3_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_3_3_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_3_3_1" id="item-18-instance-1_3_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_3_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_3_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_3_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_3_3_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_3_3_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_3_3_1" id="item-19-instance-1_3_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_3_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_3_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_3_4" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-4" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_3_4" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_3_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_3_4_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_3_4_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_3_4_1" id="item-18-instance-1_3_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_3_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_3_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_3_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_3_4_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_3_4_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_3_4_1" id="item-19-instance-1_3_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_3_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_3_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_3_5" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-5" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_3_5" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_3_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_3_5_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_3_5_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_3_5_1" id="item-18-instance-1_3_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_3_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_3_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_3_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_3_5_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_3_5_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_3_5_1" id="item-19-instance-1_3_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_3_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_3_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_3_6" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-6" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_3_6" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_3_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_3_6_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_3_6_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_3_6_1" id="item-18-instance-1_3_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_3_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_3_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_3_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_3_6_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_3_6_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_3_6_1" id="item-19-instance-1_3_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_3_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_3_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_3_7" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-7" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_3_7" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_3_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_3_7_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_3_7_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_3_7_1" id="item-18-instance-1_3_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_3_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_3_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_3_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_3_7_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_3_7_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_3_7_1" id="item-19-instance-1_3_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_3_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_3_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_3_8" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-8" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_3_8" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_3_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_3_8_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_3_8_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_3_8_1" id="item-18-instance-1_3_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_3_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_3_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_3_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_3_8_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_3_8_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_3_8_1" id="item-19-instance-1_3_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_3_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_3_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_3_9" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-9" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_3_9" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_3_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_3_9_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_3_9_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_3_9_1" id="item-18-instance-1_3_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_3_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_3_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_3_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_3_9_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_3_9_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_3_9_1" id="item-19-instance-1_3_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_3_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_3_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_3_10" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-10" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_3_10" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_3_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_3_10_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_3_10_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_3_10_1" id="item-18-instance-1_3_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_3_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_3_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_3_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_3_10_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_3_10_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_3_10_1" id="item-19-instance-1_3_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_3_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_3_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-14-instance-1_4" class="repeating-enclosing invisible">
            <div class="sequence-label">Extra Properties</div>
            <div id="sequence-14-instance-4" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-14-instance-1_4" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-15-instance-1_4_1" class="item-enclosing">
                <div id="repeat-button-15-instance-1_4" class="btn btn-sm btn-default">Add Category</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-15-instance-1_4_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-15-instance-1_4_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">15</div>
                  <label class="item-label" for="item-input-15-instance-1_4_1">Category</label>
                  <div class="item-input">
                    <input number="15" name="item-input-15-instance-1_4_1" id="item-15-instance-1_4_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-15-instance-1_4_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-15-instance-1_4_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-16-instance-1_4_1" class="item-enclosing">
                <div id="repeat-button-16-instance-1_4" class="btn btn-sm btn-default">Add Category Iri</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-16-instance-1_4_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-16-instance-1_4_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">16</div>
                  <label class="item-label" for="item-input-16-instance-1_4_1">Category IRI</label>
                  <div class="item-input">
                    <input number="16" name="item-input-16-instance-1_4_1" id="item-16-instance-1_4_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-16-instance-1_4_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-16-instance-1_4_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-17-instance-1_4_1" class="sequence">
                <div class="min-occurs-zero-container invisible">
                  <div class="min-occurs-zero-label">Click to enable</div>
                  <input number="17" name="min-occurs-zero-name17-instance-1_4" checked="true" id="min-occurs-zero-17-instance-1_4" class="min-occurs-zero" type="checkbox">
                  </input>
                </div>
                <div id="repeat-button-17-instance-1_4" class="btn btn-sm btn-default">Add Values</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-17-instance-1_4_1" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-1" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_4_1" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_4_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_4_1_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_4_1_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_4_1_1" id="item-18-instance-1_4_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_4_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_4_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_4_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_4_1_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_4_1_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_4_1_1" id="item-19-instance-1_4_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_4_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_4_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_4_2" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-2" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_4_2" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_4_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_4_2_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_4_2_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_4_2_1" id="item-18-instance-1_4_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_4_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_4_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_4_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_4_2_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_4_2_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_4_2_1" id="item-19-instance-1_4_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_4_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_4_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_4_3" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-3" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_4_3" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_4_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_4_3_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_4_3_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_4_3_1" id="item-18-instance-1_4_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_4_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_4_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_4_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_4_3_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_4_3_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_4_3_1" id="item-19-instance-1_4_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_4_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_4_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_4_4" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-4" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_4_4" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_4_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_4_4_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_4_4_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_4_4_1" id="item-18-instance-1_4_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_4_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_4_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_4_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_4_4_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_4_4_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_4_4_1" id="item-19-instance-1_4_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_4_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_4_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_4_5" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-5" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_4_5" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_4_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_4_5_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_4_5_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_4_5_1" id="item-18-instance-1_4_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_4_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_4_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_4_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_4_5_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_4_5_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_4_5_1" id="item-19-instance-1_4_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_4_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_4_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_4_6" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-6" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_4_6" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_4_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_4_6_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_4_6_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_4_6_1" id="item-18-instance-1_4_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_4_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_4_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_4_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_4_6_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_4_6_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_4_6_1" id="item-19-instance-1_4_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_4_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_4_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_4_7" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-7" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_4_7" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_4_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_4_7_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_4_7_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_4_7_1" id="item-18-instance-1_4_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_4_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_4_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_4_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_4_7_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_4_7_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_4_7_1" id="item-19-instance-1_4_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_4_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_4_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_4_8" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-8" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_4_8" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_4_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_4_8_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_4_8_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_4_8_1" id="item-18-instance-1_4_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_4_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_4_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_4_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_4_8_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_4_8_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_4_8_1" id="item-19-instance-1_4_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_4_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_4_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_4_9" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-9" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_4_9" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_4_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_4_9_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_4_9_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_4_9_1" id="item-18-instance-1_4_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_4_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_4_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_4_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_4_9_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_4_9_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_4_9_1" id="item-19-instance-1_4_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_4_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_4_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_4_10" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-10" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_4_10" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_4_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_4_10_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_4_10_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_4_10_1" id="item-18-instance-1_4_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_4_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_4_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_4_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_4_10_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_4_10_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_4_10_1" id="item-19-instance-1_4_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_4_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_4_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-14-instance-1_5" class="repeating-enclosing invisible">
            <div class="sequence-label">Extra Properties</div>
            <div id="sequence-14-instance-5" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-14-instance-1_5" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-15-instance-1_5_1" class="item-enclosing">
                <div id="repeat-button-15-instance-1_5" class="btn btn-sm btn-default">Add Category</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-15-instance-1_5_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-15-instance-1_5_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">15</div>
                  <label class="item-label" for="item-input-15-instance-1_5_1">Category</label>
                  <div class="item-input">
                    <input number="15" name="item-input-15-instance-1_5_1" id="item-15-instance-1_5_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-15-instance-1_5_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-15-instance-1_5_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-16-instance-1_5_1" class="item-enclosing">
                <div id="repeat-button-16-instance-1_5" class="btn btn-sm btn-default">Add Category Iri</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-16-instance-1_5_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-16-instance-1_5_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">16</div>
                  <label class="item-label" for="item-input-16-instance-1_5_1">Category IRI</label>
                  <div class="item-input">
                    <input number="16" name="item-input-16-instance-1_5_1" id="item-16-instance-1_5_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-16-instance-1_5_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-16-instance-1_5_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-17-instance-1_5_1" class="sequence">
                <div class="min-occurs-zero-container invisible">
                  <div class="min-occurs-zero-label">Click to enable</div>
                  <input number="17" name="min-occurs-zero-name17-instance-1_5" checked="true" id="min-occurs-zero-17-instance-1_5" class="min-occurs-zero" type="checkbox">
                  </input>
                </div>
                <div id="repeat-button-17-instance-1_5" class="btn btn-sm btn-default">Add Values</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-17-instance-1_5_1" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-1" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_5_1" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_5_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_5_1_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_5_1_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_5_1_1" id="item-18-instance-1_5_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_5_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_5_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_5_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_5_1_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_5_1_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_5_1_1" id="item-19-instance-1_5_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_5_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_5_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_5_2" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-2" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_5_2" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_5_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_5_2_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_5_2_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_5_2_1" id="item-18-instance-1_5_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_5_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_5_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_5_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_5_2_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_5_2_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_5_2_1" id="item-19-instance-1_5_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_5_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_5_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_5_3" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-3" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_5_3" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_5_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_5_3_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_5_3_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_5_3_1" id="item-18-instance-1_5_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_5_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_5_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_5_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_5_3_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_5_3_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_5_3_1" id="item-19-instance-1_5_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_5_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_5_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_5_4" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-4" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_5_4" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_5_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_5_4_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_5_4_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_5_4_1" id="item-18-instance-1_5_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_5_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_5_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_5_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_5_4_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_5_4_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_5_4_1" id="item-19-instance-1_5_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_5_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_5_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_5_5" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-5" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_5_5" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_5_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_5_5_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_5_5_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_5_5_1" id="item-18-instance-1_5_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_5_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_5_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_5_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_5_5_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_5_5_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_5_5_1" id="item-19-instance-1_5_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_5_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_5_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_5_6" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-6" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_5_6" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_5_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_5_6_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_5_6_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_5_6_1" id="item-18-instance-1_5_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_5_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_5_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_5_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_5_6_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_5_6_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_5_6_1" id="item-19-instance-1_5_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_5_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_5_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_5_7" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-7" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_5_7" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_5_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_5_7_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_5_7_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_5_7_1" id="item-18-instance-1_5_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_5_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_5_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_5_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_5_7_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_5_7_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_5_7_1" id="item-19-instance-1_5_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_5_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_5_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_5_8" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-8" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_5_8" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_5_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_5_8_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_5_8_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_5_8_1" id="item-18-instance-1_5_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_5_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_5_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_5_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_5_8_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_5_8_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_5_8_1" id="item-19-instance-1_5_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_5_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_5_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_5_9" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-9" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_5_9" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_5_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_5_9_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_5_9_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_5_9_1" id="item-18-instance-1_5_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_5_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_5_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_5_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_5_9_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_5_9_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_5_9_1" id="item-19-instance-1_5_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_5_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_5_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_5_10" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-10" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_5_10" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_5_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_5_10_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_5_10_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_5_10_1" id="item-18-instance-1_5_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_5_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_5_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_5_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_5_10_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_5_10_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_5_10_1" id="item-19-instance-1_5_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_5_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_5_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-14-instance-1_6" class="repeating-enclosing invisible">
            <div class="sequence-label">Extra Properties</div>
            <div id="sequence-14-instance-6" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-14-instance-1_6" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-15-instance-1_6_1" class="item-enclosing">
                <div id="repeat-button-15-instance-1_6" class="btn btn-sm btn-default">Add Category</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-15-instance-1_6_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-15-instance-1_6_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">15</div>
                  <label class="item-label" for="item-input-15-instance-1_6_1">Category</label>
                  <div class="item-input">
                    <input number="15" name="item-input-15-instance-1_6_1" id="item-15-instance-1_6_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-15-instance-1_6_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-15-instance-1_6_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-16-instance-1_6_1" class="item-enclosing">
                <div id="repeat-button-16-instance-1_6" class="btn btn-sm btn-default">Add Category Iri</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-16-instance-1_6_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-16-instance-1_6_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">16</div>
                  <label class="item-label" for="item-input-16-instance-1_6_1">Category IRI</label>
                  <div class="item-input">
                    <input number="16" name="item-input-16-instance-1_6_1" id="item-16-instance-1_6_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-16-instance-1_6_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-16-instance-1_6_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-17-instance-1_6_1" class="sequence">
                <div class="min-occurs-zero-container invisible">
                  <div class="min-occurs-zero-label">Click to enable</div>
                  <input number="17" name="min-occurs-zero-name17-instance-1_6" checked="true" id="min-occurs-zero-17-instance-1_6" class="min-occurs-zero" type="checkbox">
                  </input>
                </div>
                <div id="repeat-button-17-instance-1_6" class="btn btn-sm btn-default">Add Values</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-17-instance-1_6_1" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-1" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_6_1" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_6_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_6_1_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_6_1_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_6_1_1" id="item-18-instance-1_6_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_6_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_6_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_6_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_6_1_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_6_1_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_6_1_1" id="item-19-instance-1_6_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_6_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_6_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_6_2" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-2" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_6_2" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_6_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_6_2_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_6_2_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_6_2_1" id="item-18-instance-1_6_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_6_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_6_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_6_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_6_2_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_6_2_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_6_2_1" id="item-19-instance-1_6_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_6_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_6_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_6_3" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-3" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_6_3" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_6_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_6_3_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_6_3_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_6_3_1" id="item-18-instance-1_6_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_6_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_6_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_6_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_6_3_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_6_3_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_6_3_1" id="item-19-instance-1_6_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_6_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_6_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_6_4" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-4" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_6_4" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_6_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_6_4_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_6_4_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_6_4_1" id="item-18-instance-1_6_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_6_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_6_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_6_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_6_4_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_6_4_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_6_4_1" id="item-19-instance-1_6_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_6_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_6_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_6_5" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-5" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_6_5" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_6_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_6_5_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_6_5_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_6_5_1" id="item-18-instance-1_6_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_6_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_6_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_6_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_6_5_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_6_5_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_6_5_1" id="item-19-instance-1_6_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_6_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_6_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_6_6" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-6" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_6_6" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_6_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_6_6_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_6_6_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_6_6_1" id="item-18-instance-1_6_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_6_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_6_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_6_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_6_6_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_6_6_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_6_6_1" id="item-19-instance-1_6_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_6_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_6_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_6_7" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-7" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_6_7" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_6_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_6_7_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_6_7_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_6_7_1" id="item-18-instance-1_6_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_6_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_6_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_6_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_6_7_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_6_7_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_6_7_1" id="item-19-instance-1_6_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_6_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_6_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_6_8" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-8" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_6_8" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_6_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_6_8_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_6_8_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_6_8_1" id="item-18-instance-1_6_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_6_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_6_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_6_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_6_8_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_6_8_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_6_8_1" id="item-19-instance-1_6_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_6_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_6_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_6_9" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-9" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_6_9" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_6_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_6_9_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_6_9_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_6_9_1" id="item-18-instance-1_6_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_6_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_6_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_6_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_6_9_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_6_9_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_6_9_1" id="item-19-instance-1_6_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_6_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_6_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_6_10" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-10" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_6_10" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_6_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_6_10_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_6_10_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_6_10_1" id="item-18-instance-1_6_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_6_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_6_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_6_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_6_10_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_6_10_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_6_10_1" id="item-19-instance-1_6_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_6_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_6_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-14-instance-1_7" class="repeating-enclosing invisible">
            <div class="sequence-label">Extra Properties</div>
            <div id="sequence-14-instance-7" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-14-instance-1_7" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-15-instance-1_7_1" class="item-enclosing">
                <div id="repeat-button-15-instance-1_7" class="btn btn-sm btn-default">Add Category</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-15-instance-1_7_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-15-instance-1_7_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">15</div>
                  <label class="item-label" for="item-input-15-instance-1_7_1">Category</label>
                  <div class="item-input">
                    <input number="15" name="item-input-15-instance-1_7_1" id="item-15-instance-1_7_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-15-instance-1_7_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-15-instance-1_7_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-16-instance-1_7_1" class="item-enclosing">
                <div id="repeat-button-16-instance-1_7" class="btn btn-sm btn-default">Add Category Iri</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-16-instance-1_7_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-16-instance-1_7_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">16</div>
                  <label class="item-label" for="item-input-16-instance-1_7_1">Category IRI</label>
                  <div class="item-input">
                    <input number="16" name="item-input-16-instance-1_7_1" id="item-16-instance-1_7_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-16-instance-1_7_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-16-instance-1_7_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-17-instance-1_7_1" class="sequence">
                <div class="min-occurs-zero-container invisible">
                  <div class="min-occurs-zero-label">Click to enable</div>
                  <input number="17" name="min-occurs-zero-name17-instance-1_7" checked="true" id="min-occurs-zero-17-instance-1_7" class="min-occurs-zero" type="checkbox">
                  </input>
                </div>
                <div id="repeat-button-17-instance-1_7" class="btn btn-sm btn-default">Add Values</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-17-instance-1_7_1" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-1" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_7_1" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_7_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_7_1_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_7_1_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_7_1_1" id="item-18-instance-1_7_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_7_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_7_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_7_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_7_1_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_7_1_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_7_1_1" id="item-19-instance-1_7_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_7_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_7_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_7_2" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-2" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_7_2" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_7_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_7_2_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_7_2_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_7_2_1" id="item-18-instance-1_7_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_7_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_7_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_7_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_7_2_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_7_2_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_7_2_1" id="item-19-instance-1_7_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_7_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_7_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_7_3" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-3" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_7_3" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_7_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_7_3_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_7_3_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_7_3_1" id="item-18-instance-1_7_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_7_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_7_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_7_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_7_3_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_7_3_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_7_3_1" id="item-19-instance-1_7_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_7_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_7_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_7_4" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-4" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_7_4" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_7_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_7_4_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_7_4_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_7_4_1" id="item-18-instance-1_7_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_7_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_7_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_7_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_7_4_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_7_4_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_7_4_1" id="item-19-instance-1_7_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_7_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_7_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_7_5" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-5" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_7_5" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_7_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_7_5_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_7_5_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_7_5_1" id="item-18-instance-1_7_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_7_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_7_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_7_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_7_5_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_7_5_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_7_5_1" id="item-19-instance-1_7_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_7_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_7_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_7_6" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-6" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_7_6" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_7_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_7_6_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_7_6_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_7_6_1" id="item-18-instance-1_7_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_7_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_7_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_7_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_7_6_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_7_6_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_7_6_1" id="item-19-instance-1_7_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_7_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_7_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_7_7" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-7" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_7_7" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_7_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_7_7_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_7_7_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_7_7_1" id="item-18-instance-1_7_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_7_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_7_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_7_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_7_7_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_7_7_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_7_7_1" id="item-19-instance-1_7_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_7_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_7_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_7_8" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-8" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_7_8" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_7_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_7_8_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_7_8_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_7_8_1" id="item-18-instance-1_7_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_7_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_7_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_7_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_7_8_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_7_8_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_7_8_1" id="item-19-instance-1_7_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_7_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_7_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_7_9" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-9" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_7_9" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_7_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_7_9_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_7_9_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_7_9_1" id="item-18-instance-1_7_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_7_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_7_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_7_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_7_9_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_7_9_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_7_9_1" id="item-19-instance-1_7_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_7_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_7_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_7_10" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-10" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_7_10" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_7_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_7_10_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_7_10_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_7_10_1" id="item-18-instance-1_7_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_7_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_7_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_7_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_7_10_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_7_10_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_7_10_1" id="item-19-instance-1_7_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_7_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_7_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-14-instance-1_8" class="repeating-enclosing invisible">
            <div class="sequence-label">Extra Properties</div>
            <div id="sequence-14-instance-8" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-14-instance-1_8" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-15-instance-1_8_1" class="item-enclosing">
                <div id="repeat-button-15-instance-1_8" class="btn btn-sm btn-default">Add Category</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-15-instance-1_8_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-15-instance-1_8_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">15</div>
                  <label class="item-label" for="item-input-15-instance-1_8_1">Category</label>
                  <div class="item-input">
                    <input number="15" name="item-input-15-instance-1_8_1" id="item-15-instance-1_8_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-15-instance-1_8_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-15-instance-1_8_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-16-instance-1_8_1" class="item-enclosing">
                <div id="repeat-button-16-instance-1_8" class="btn btn-sm btn-default">Add Category Iri</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-16-instance-1_8_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-16-instance-1_8_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">16</div>
                  <label class="item-label" for="item-input-16-instance-1_8_1">Category IRI</label>
                  <div class="item-input">
                    <input number="16" name="item-input-16-instance-1_8_1" id="item-16-instance-1_8_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-16-instance-1_8_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-16-instance-1_8_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-17-instance-1_8_1" class="sequence">
                <div class="min-occurs-zero-container invisible">
                  <div class="min-occurs-zero-label">Click to enable</div>
                  <input number="17" name="min-occurs-zero-name17-instance-1_8" checked="true" id="min-occurs-zero-17-instance-1_8" class="min-occurs-zero" type="checkbox">
                  </input>
                </div>
                <div id="repeat-button-17-instance-1_8" class="btn btn-sm btn-default">Add Values</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-17-instance-1_8_1" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-1" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_8_1" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_8_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_8_1_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_8_1_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_8_1_1" id="item-18-instance-1_8_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_8_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_8_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_8_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_8_1_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_8_1_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_8_1_1" id="item-19-instance-1_8_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_8_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_8_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_8_2" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-2" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_8_2" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_8_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_8_2_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_8_2_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_8_2_1" id="item-18-instance-1_8_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_8_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_8_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_8_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_8_2_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_8_2_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_8_2_1" id="item-19-instance-1_8_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_8_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_8_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_8_3" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-3" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_8_3" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_8_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_8_3_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_8_3_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_8_3_1" id="item-18-instance-1_8_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_8_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_8_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_8_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_8_3_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_8_3_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_8_3_1" id="item-19-instance-1_8_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_8_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_8_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_8_4" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-4" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_8_4" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_8_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_8_4_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_8_4_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_8_4_1" id="item-18-instance-1_8_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_8_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_8_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_8_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_8_4_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_8_4_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_8_4_1" id="item-19-instance-1_8_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_8_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_8_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_8_5" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-5" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_8_5" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_8_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_8_5_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_8_5_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_8_5_1" id="item-18-instance-1_8_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_8_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_8_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_8_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_8_5_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_8_5_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_8_5_1" id="item-19-instance-1_8_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_8_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_8_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_8_6" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-6" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_8_6" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_8_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_8_6_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_8_6_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_8_6_1" id="item-18-instance-1_8_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_8_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_8_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_8_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_8_6_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_8_6_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_8_6_1" id="item-19-instance-1_8_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_8_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_8_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_8_7" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-7" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_8_7" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_8_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_8_7_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_8_7_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_8_7_1" id="item-18-instance-1_8_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_8_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_8_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_8_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_8_7_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_8_7_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_8_7_1" id="item-19-instance-1_8_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_8_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_8_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_8_8" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-8" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_8_8" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_8_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_8_8_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_8_8_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_8_8_1" id="item-18-instance-1_8_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_8_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_8_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_8_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_8_8_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_8_8_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_8_8_1" id="item-19-instance-1_8_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_8_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_8_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_8_9" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-9" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_8_9" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_8_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_8_9_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_8_9_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_8_9_1" id="item-18-instance-1_8_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_8_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_8_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_8_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_8_9_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_8_9_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_8_9_1" id="item-19-instance-1_8_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_8_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_8_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_8_10" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-10" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_8_10" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_8_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_8_10_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_8_10_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_8_10_1" id="item-18-instance-1_8_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_8_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_8_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_8_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_8_10_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_8_10_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_8_10_1" id="item-19-instance-1_8_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_8_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_8_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-14-instance-1_9" class="repeating-enclosing invisible">
            <div class="sequence-label">Extra Properties</div>
            <div id="sequence-14-instance-9" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-14-instance-1_9" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-15-instance-1_9_1" class="item-enclosing">
                <div id="repeat-button-15-instance-1_9" class="btn btn-sm btn-default">Add Category</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-15-instance-1_9_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-15-instance-1_9_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">15</div>
                  <label class="item-label" for="item-input-15-instance-1_9_1">Category</label>
                  <div class="item-input">
                    <input number="15" name="item-input-15-instance-1_9_1" id="item-15-instance-1_9_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-15-instance-1_9_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-15-instance-1_9_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-16-instance-1_9_1" class="item-enclosing">
                <div id="repeat-button-16-instance-1_9" class="btn btn-sm btn-default">Add Category Iri</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-16-instance-1_9_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-16-instance-1_9_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">16</div>
                  <label class="item-label" for="item-input-16-instance-1_9_1">Category IRI</label>
                  <div class="item-input">
                    <input number="16" name="item-input-16-instance-1_9_1" id="item-16-instance-1_9_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-16-instance-1_9_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-16-instance-1_9_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-17-instance-1_9_1" class="sequence">
                <div class="min-occurs-zero-container invisible">
                  <div class="min-occurs-zero-label">Click to enable</div>
                  <input number="17" name="min-occurs-zero-name17-instance-1_9" checked="true" id="min-occurs-zero-17-instance-1_9" class="min-occurs-zero" type="checkbox">
                  </input>
                </div>
                <div id="repeat-button-17-instance-1_9" class="btn btn-sm btn-default">Add Values</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-17-instance-1_9_1" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-1" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_9_1" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_9_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_9_1_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_9_1_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_9_1_1" id="item-18-instance-1_9_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_9_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_9_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_9_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_9_1_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_9_1_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_9_1_1" id="item-19-instance-1_9_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_9_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_9_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_9_2" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-2" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_9_2" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_9_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_9_2_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_9_2_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_9_2_1" id="item-18-instance-1_9_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_9_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_9_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_9_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_9_2_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_9_2_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_9_2_1" id="item-19-instance-1_9_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_9_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_9_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_9_3" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-3" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_9_3" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_9_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_9_3_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_9_3_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_9_3_1" id="item-18-instance-1_9_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_9_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_9_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_9_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_9_3_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_9_3_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_9_3_1" id="item-19-instance-1_9_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_9_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_9_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_9_4" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-4" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_9_4" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_9_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_9_4_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_9_4_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_9_4_1" id="item-18-instance-1_9_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_9_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_9_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_9_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_9_4_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_9_4_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_9_4_1" id="item-19-instance-1_9_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_9_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_9_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_9_5" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-5" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_9_5" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_9_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_9_5_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_9_5_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_9_5_1" id="item-18-instance-1_9_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_9_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_9_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_9_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_9_5_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_9_5_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_9_5_1" id="item-19-instance-1_9_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_9_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_9_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_9_6" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-6" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_9_6" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_9_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_9_6_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_9_6_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_9_6_1" id="item-18-instance-1_9_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_9_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_9_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_9_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_9_6_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_9_6_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_9_6_1" id="item-19-instance-1_9_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_9_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_9_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_9_7" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-7" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_9_7" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_9_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_9_7_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_9_7_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_9_7_1" id="item-18-instance-1_9_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_9_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_9_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_9_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_9_7_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_9_7_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_9_7_1" id="item-19-instance-1_9_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_9_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_9_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_9_8" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-8" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_9_8" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_9_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_9_8_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_9_8_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_9_8_1" id="item-18-instance-1_9_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_9_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_9_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_9_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_9_8_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_9_8_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_9_8_1" id="item-19-instance-1_9_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_9_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_9_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_9_9" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-9" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_9_9" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_9_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_9_9_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_9_9_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_9_9_1" id="item-18-instance-1_9_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_9_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_9_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_9_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_9_9_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_9_9_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_9_9_1" id="item-19-instance-1_9_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_9_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_9_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_9_10" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-10" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_9_10" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_9_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_9_10_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_9_10_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_9_10_1" id="item-18-instance-1_9_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_9_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_9_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_9_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_9_10_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_9_10_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_9_10_1" id="item-19-instance-1_9_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_9_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_9_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div id="repeating-enclosing-14-instance-1_10" class="repeating-enclosing invisible">
            <div class="sequence-label">Extra Properties</div>
            <div id="sequence-14-instance-10" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-14-instance-1_10" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-15-instance-1_10_1" class="item-enclosing">
                <div id="repeat-button-15-instance-1_10" class="btn btn-sm btn-default">Add Category</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-15-instance-1_10_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-15-instance-1_10_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">15</div>
                  <label class="item-label" for="item-input-15-instance-1_10_1">Category</label>
                  <div class="item-input">
                    <input number="15" name="item-input-15-instance-1_10_1" id="item-15-instance-1_10_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-15-instance-1_10_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-15-instance-1_10_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-16-instance-1_10_1" class="item-enclosing">
                <div id="repeat-button-16-instance-1_10" class="btn btn-sm btn-default">Add Category Iri</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-16-instance-1_10_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-16-instance-1_10_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">16</div>
                  <label class="item-label" for="item-input-16-instance-1_10_1">Category IRI</label>
                  <div class="item-input">
                    <input number="16" name="item-input-16-instance-1_10_1" id="item-16-instance-1_10_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-16-instance-1_10_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-16-instance-1_10_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-17-instance-1_10_1" class="sequence">
                <div class="min-occurs-zero-container invisible">
                  <div class="min-occurs-zero-label">Click to enable</div>
                  <input number="17" name="min-occurs-zero-name17-instance-1_10" checked="true" id="min-occurs-zero-17-instance-1_10" class="min-occurs-zero" type="checkbox">
                  </input>
                </div>
                <div id="repeat-button-17-instance-1_10" class="btn btn-sm btn-default">Add Values</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-17-instance-1_10_1" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-1" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_10_1" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_10_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_10_1_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_10_1_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_10_1_1" id="item-18-instance-1_10_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_10_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_10_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_10_1_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_10_1_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_10_1_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_10_1_1" id="item-19-instance-1_10_1_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_10_1_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_10_1_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_10_2" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-2" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_10_2" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_10_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_10_2_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_10_2_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_10_2_1" id="item-18-instance-1_10_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_10_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_10_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_10_2_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_10_2_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_10_2_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_10_2_1" id="item-19-instance-1_10_2_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_10_2_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_10_2_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_10_3" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-3" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_10_3" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_10_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_10_3_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_10_3_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_10_3_1" id="item-18-instance-1_10_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_10_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_10_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_10_3_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_10_3_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_10_3_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_10_3_1" id="item-19-instance-1_10_3_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_10_3_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_10_3_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_10_4" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-4" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_10_4" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_10_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_10_4_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_10_4_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_10_4_1" id="item-18-instance-1_10_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_10_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_10_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_10_4_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_10_4_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_10_4_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_10_4_1" id="item-19-instance-1_10_4_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_10_4_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_10_4_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_10_5" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-5" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_10_5" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_10_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_10_5_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_10_5_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_10_5_1" id="item-18-instance-1_10_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_10_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_10_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_10_5_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_10_5_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_10_5_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_10_5_1" id="item-19-instance-1_10_5_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_10_5_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_10_5_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_10_6" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-6" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_10_6" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_10_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_10_6_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_10_6_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_10_6_1" id="item-18-instance-1_10_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_10_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_10_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_10_6_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_10_6_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_10_6_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_10_6_1" id="item-19-instance-1_10_6_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_10_6_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_10_6_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_10_7" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-7" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_10_7" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_10_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_10_7_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_10_7_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_10_7_1" id="item-18-instance-1_10_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_10_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_10_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_10_7_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_10_7_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_10_7_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_10_7_1" id="item-19-instance-1_10_7_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_10_7_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_10_7_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_10_8" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-8" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_10_8" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_10_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_10_8_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_10_8_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_10_8_1" id="item-18-instance-1_10_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_10_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_10_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_10_8_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_10_8_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_10_8_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_10_8_1" id="item-19-instance-1_10_8_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_10_8_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_10_8_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_10_9" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-9" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_10_9" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_10_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_10_9_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_10_9_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_10_9_1" id="item-18-instance-1_10_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_10_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_10_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_10_9_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_10_9_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_10_9_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_10_9_1" id="item-19-instance-1_10_9_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_10_9_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_10_9_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
                <div id="repeating-enclosing-17-instance-1_10_10" class="repeating-enclosing invisible">
                  <div class="sequence-label">Values</div>
                  <div id="sequence-17-instance-10" class="sequence-content">
                    <div class="remove-button-container">
                      <div id="remove-button-17-instance-1_10_10" class="btn btn-xs btn-default">-</div>
                    </div>
                    <div id="item-enclosing-18-instance-1_10_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-18-instance-1_10_10_1" class="repeating-enclosing">
                        <div class="item-number">18</div>
                        <label class="item-label" for="item-input-18-instance-1_10_10_1">Value</label>
                        <div class="item-input">
                          <input number="18" name="item-input-18-instance-1_10_10_1" id="item-18-instance-1_10_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-18-instance-1_10_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-18-instance-1_10_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                    <div id="item-enclosing-19-instance-1_10_10_1" class="item-enclosing">
                      <div id="repeating-enclosing-19-instance-1_10_10_1" class="repeating-enclosing">
                        <div class="item-number">19</div>
                        <label class="item-label" for="item-input-19-instance-1_10_10_1">Value IRI</label>
                        <div class="item-input">
                          <input number="19" name="item-input-19-instance-1_10_10_1" id="item-19-instance-1_10_10_1" class=" item-input-text" type="text">
                          </input>
                          <div id="item-path-19-instance-1_10_10_1" class="item-path" enabled="true"></div>
                        </div>
                        <div class="clr">
                        </div>
                        <div id="item-error-19-instance-1_10_10_1" class="item-error">Invalid</div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

        <div id="validation-errors" class="validationErrors">The form is not yet complete. Check through the form for error messages</div>
        <div id="submit" class="submit">Submit</div>
        <p><div id="submit-comments"></div></p>

    </form>
    
</div>
</body>
<myTags:footer></myTags:footer>

</html>
