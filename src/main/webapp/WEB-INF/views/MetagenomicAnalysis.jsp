<html>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<head>
    <myTags:favicon></myTags:favicon>
    <title>MIDAS Digital Commons</title>
    <base href='.'>
    <link defer rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/bootstrap/3.3.6/bootstrap.min.css">
    <link href="${pageContext.request.contextPath}/resources/css/combined.css" rel="stylesheet">

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
    <script src="https://code.jquery.com/jquery-2.1.3.min.js" integrity="sha256-ivk71nXhz9nsyFDoYoGf2sbjrR9ddh+XDkCcfZxjvcM=" crossorigin="anonymous"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/xsd-forms/js/jquery-ui-1.8.16.custom.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/xsd-forms/js/jquery-ui-timepicker-addon.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/xsd-forms/js/xml2json.js"></script>

    <!-- Bootstrap JS -->
    <script src="${pageContext.request.contextPath}/resources/js/tether.min.js" defer></script>
    <script src="${pageContext.request.contextPath}/resources/js/bootstrap/3.3.6/bootstrap.min.js" defer></script>
    <script>document.write("<link href='${pageContext.request.contextPath}/resources/css/main.css?v=" + Date.now() + "'rel='stylesheet'>");</script>

    <script src="${pageContext.request.contextPath}/resources/js/raphael.min.js"></script>
    <script src="http://flowchart.js.org/flowchart-latest.js"></script>
    
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/xsd-forms/js/xsd-forms-override.js"></script>

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
                    window.onbeforeunload = null;
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

  $('#item-2-instance-1_1').prop('checked',false);

  // product
  var validate2instance1_1 = function () {
    var ok = true;
    var v = $('#item-2-instance-1_1');
    var pathDiv = $('#item-path-2-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-2-instance-1_1').change( function() {
    var ok = validate2instance1_1();
    showError('item-error-2-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-2-instance-1_1').attr('enabled','false');
  $('#repeat-button-2-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-2-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-3-instance-1_1').click(function() {
    $('#repeating-enclosing-3-instance-1_1').hide();
  });

  $('#item-3-instance-1_1').prop('checked',false);

  // title
  var validate3instance1_1 = function () {
    var ok = true;
    var v = $('#item-3-instance-1_1');
    var pathDiv = $('#item-path-3-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-3-instance-1_1').change( function() {
    var ok = validate3instance1_1();
    showError('item-error-3-instance-1_1',ok);
  });
  
  $('#remove-button-4-instance-1_1').click(function() {
    $('#repeating-enclosing-4-instance-1_1').hide();
  });

  $('#item-4-instance-1_1').prop('checked',false);

  // humanReadableSynopsis
  var validate4instance1_1 = function () {
    var ok = true;
    var v = $('#item-4-instance-1_1');
    var pathDiv = $('#item-path-4-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    return ok;
  }
  
  $('#item-4-instance-1_1').change( function() {
    var ok = validate4instance1_1();
    showError('item-error-4-instance-1_1',ok);
  });
  
$('#min-occurs-zero-5-instance-1').change( function () {
  changeMinOccursZeroCheckbox($(this),$('#repeating-enclosing-5-instance-1_1'));
})

$('#min-occurs-zero-5-instance-1').change();
  $('#remove-button-5-instance-1_1').click(function() {
    $('#repeating-enclosing-5-instance-1_1').hide();
  });

  $('#remove-button-6-instance-1_1_1').click(function() {
    $('#repeating-enclosing-6-instance-1_1_1').hide();
  });

  $('#item-6-instance-1_1_1').prop('checked',false);

  // identifier
  var validate6instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-6-instance-1_1_1');
    var pathDiv = $('#item-path-6-instance-1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-6-instance-1_1_1').change( function() {
    var ok = validate6instance1_1_1();
    showError('item-error-6-instance-1_1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-6-instance-1_1_1').attr('enabled','false');
  $('#repeat-button-6-instance-1_1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-6-instance-1_1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-7-instance-1_1_1').click(function() {
    $('#repeating-enclosing-7-instance-1_1_1').hide();
  });

  $('#item-7-instance-1_1_1').prop('checked',false);

  // identifierSource
  var validate7instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-7-instance-1_1_1');
    var pathDiv = $('#item-path-7-instance-1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-7-instance-1_1_1').change( function() {
    var ok = validate7instance1_1_1();
    showError('item-error-7-instance-1_1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-7-instance-1_1_1').attr('enabled','false');
  $('#repeat-button-7-instance-1_1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-7-instance-1_1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-8-instance-1_1_1').click(function() {
    $('#repeating-enclosing-8-instance-1_1_1').hide();
  });

  $('#item-8-instance-1_1_1').prop('checked',false);

  // identifierDescription
  var validate8instance1_1_1 = function () {
    var ok = true;
    var v = $('#item-8-instance-1_1_1');
    var pathDiv = $('#item-path-8-instance-1_1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-8-instance-1_1_1').change( function() {
    var ok = validate8instance1_1_1();
    showError('item-error-8-instance-1_1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-8-instance-1_1_1').attr('enabled','false');
  $('#repeat-button-8-instance-1_1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-8-instance-1_1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#repeat-button-5-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-5-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-9-instance-1_1').click(function() {
    $('#repeating-enclosing-9-instance-1_1').hide();
  });

  $('#item-9-instance-1_1').prop('checked',false);

  // dataInputFormats
  var validate9instance1_1 = function () {
    var ok = true;
    var v = $('#item-9-instance-1_1');
    var pathDiv = $('#item-path-9-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-9-instance-1_1').change( function() {
    var ok = validate9instance1_1();
    showError('item-error-9-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-9-instance-1_1').attr('enabled','false');
  $('#remove-button-9-instance-1_2').click(function() {
    $('#repeating-enclosing-9-instance-1_2').hide();
  });

  $('#item-9-instance-1_2').prop('checked',false);

  // dataInputFormats
  var validate9instance1_2 = function () {
    var ok = true;
    var v = $('#item-9-instance-1_2');
    var pathDiv = $('#item-path-9-instance-1_2');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-9-instance-1_2').change( function() {
    var ok = validate9instance1_2();
    showError('item-error-9-instance-1_2',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-9-instance-1_2').attr('enabled','false');
  $('#remove-button-9-instance-1_3').click(function() {
    $('#repeating-enclosing-9-instance-1_3').hide();
  });

  $('#item-9-instance-1_3').prop('checked',false);

  // dataInputFormats
  var validate9instance1_3 = function () {
    var ok = true;
    var v = $('#item-9-instance-1_3');
    var pathDiv = $('#item-path-9-instance-1_3');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-9-instance-1_3').change( function() {
    var ok = validate9instance1_3();
    showError('item-error-9-instance-1_3',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-9-instance-1_3').attr('enabled','false');
  $('#remove-button-9-instance-1_4').click(function() {
    $('#repeating-enclosing-9-instance-1_4').hide();
  });

  $('#item-9-instance-1_4').prop('checked',false);

  // dataInputFormats
  var validate9instance1_4 = function () {
    var ok = true;
    var v = $('#item-9-instance-1_4');
    var pathDiv = $('#item-path-9-instance-1_4');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-9-instance-1_4').change( function() {
    var ok = validate9instance1_4();
    showError('item-error-9-instance-1_4',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-9-instance-1_4').attr('enabled','false');
  $('#remove-button-9-instance-1_5').click(function() {
    $('#repeating-enclosing-9-instance-1_5').hide();
  });

  $('#item-9-instance-1_5').prop('checked',false);

  // dataInputFormats
  var validate9instance1_5 = function () {
    var ok = true;
    var v = $('#item-9-instance-1_5');
    var pathDiv = $('#item-path-9-instance-1_5');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-9-instance-1_5').change( function() {
    var ok = validate9instance1_5();
    showError('item-error-9-instance-1_5',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-9-instance-1_5').attr('enabled','false');
  $('#remove-button-9-instance-1_6').click(function() {
    $('#repeating-enclosing-9-instance-1_6').hide();
  });

  $('#item-9-instance-1_6').prop('checked',false);

  // dataInputFormats
  var validate9instance1_6 = function () {
    var ok = true;
    var v = $('#item-9-instance-1_6');
    var pathDiv = $('#item-path-9-instance-1_6');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-9-instance-1_6').change( function() {
    var ok = validate9instance1_6();
    showError('item-error-9-instance-1_6',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-9-instance-1_6').attr('enabled','false');
  $('#remove-button-9-instance-1_7').click(function() {
    $('#repeating-enclosing-9-instance-1_7').hide();
  });

  $('#item-9-instance-1_7').prop('checked',false);

  // dataInputFormats
  var validate9instance1_7 = function () {
    var ok = true;
    var v = $('#item-9-instance-1_7');
    var pathDiv = $('#item-path-9-instance-1_7');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-9-instance-1_7').change( function() {
    var ok = validate9instance1_7();
    showError('item-error-9-instance-1_7',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-9-instance-1_7').attr('enabled','false');
  $('#remove-button-9-instance-1_8').click(function() {
    $('#repeating-enclosing-9-instance-1_8').hide();
  });

  $('#item-9-instance-1_8').prop('checked',false);

  // dataInputFormats
  var validate9instance1_8 = function () {
    var ok = true;
    var v = $('#item-9-instance-1_8');
    var pathDiv = $('#item-path-9-instance-1_8');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-9-instance-1_8').change( function() {
    var ok = validate9instance1_8();
    showError('item-error-9-instance-1_8',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-9-instance-1_8').attr('enabled','false');
  $('#remove-button-9-instance-1_9').click(function() {
    $('#repeating-enclosing-9-instance-1_9').hide();
  });

  $('#item-9-instance-1_9').prop('checked',false);

  // dataInputFormats
  var validate9instance1_9 = function () {
    var ok = true;
    var v = $('#item-9-instance-1_9');
    var pathDiv = $('#item-path-9-instance-1_9');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-9-instance-1_9').change( function() {
    var ok = validate9instance1_9();
    showError('item-error-9-instance-1_9',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-9-instance-1_9').attr('enabled','false');
  $('#remove-button-9-instance-1_10').click(function() {
    $('#repeating-enclosing-9-instance-1_10').hide();
  });

  $('#item-9-instance-1_10').prop('checked',false);

  // dataInputFormats
  var validate9instance1_10 = function () {
    var ok = true;
    var v = $('#item-9-instance-1_10');
    var pathDiv = $('#item-path-9-instance-1_10');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-9-instance-1_10').change( function() {
    var ok = validate9instance1_10();
    showError('item-error-9-instance-1_10',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-9-instance-1_10').attr('enabled','false');
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

  $('#remove-button-10-instance-1_1').click(function() {
    $('#repeating-enclosing-10-instance-1_1').hide();
  });

  $('#item-10-instance-1_1').prop('checked',false);

  // dataOutputFormats
  var validate10instance1_1 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_1');
    var pathDiv = $('#item-path-10-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-10-instance-1_1').change( function() {
    var ok = validate10instance1_1();
    showError('item-error-10-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-10-instance-1_1').attr('enabled','false');
  $('#remove-button-10-instance-1_2').click(function() {
    $('#repeating-enclosing-10-instance-1_2').hide();
  });

  $('#item-10-instance-1_2').prop('checked',false);

  // dataOutputFormats
  var validate10instance1_2 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_2');
    var pathDiv = $('#item-path-10-instance-1_2');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-10-instance-1_2').change( function() {
    var ok = validate10instance1_2();
    showError('item-error-10-instance-1_2',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-10-instance-1_2').attr('enabled','false');
  $('#remove-button-10-instance-1_3').click(function() {
    $('#repeating-enclosing-10-instance-1_3').hide();
  });

  $('#item-10-instance-1_3').prop('checked',false);

  // dataOutputFormats
  var validate10instance1_3 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_3');
    var pathDiv = $('#item-path-10-instance-1_3');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-10-instance-1_3').change( function() {
    var ok = validate10instance1_3();
    showError('item-error-10-instance-1_3',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-10-instance-1_3').attr('enabled','false');
  $('#remove-button-10-instance-1_4').click(function() {
    $('#repeating-enclosing-10-instance-1_4').hide();
  });

  $('#item-10-instance-1_4').prop('checked',false);

  // dataOutputFormats
  var validate10instance1_4 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_4');
    var pathDiv = $('#item-path-10-instance-1_4');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-10-instance-1_4').change( function() {
    var ok = validate10instance1_4();
    showError('item-error-10-instance-1_4',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-10-instance-1_4').attr('enabled','false');
  $('#remove-button-10-instance-1_5').click(function() {
    $('#repeating-enclosing-10-instance-1_5').hide();
  });

  $('#item-10-instance-1_5').prop('checked',false);

  // dataOutputFormats
  var validate10instance1_5 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_5');
    var pathDiv = $('#item-path-10-instance-1_5');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-10-instance-1_5').change( function() {
    var ok = validate10instance1_5();
    showError('item-error-10-instance-1_5',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-10-instance-1_5').attr('enabled','false');
  $('#remove-button-10-instance-1_6').click(function() {
    $('#repeating-enclosing-10-instance-1_6').hide();
  });

  $('#item-10-instance-1_6').prop('checked',false);

  // dataOutputFormats
  var validate10instance1_6 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_6');
    var pathDiv = $('#item-path-10-instance-1_6');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-10-instance-1_6').change( function() {
    var ok = validate10instance1_6();
    showError('item-error-10-instance-1_6',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-10-instance-1_6').attr('enabled','false');
  $('#remove-button-10-instance-1_7').click(function() {
    $('#repeating-enclosing-10-instance-1_7').hide();
  });

  $('#item-10-instance-1_7').prop('checked',false);

  // dataOutputFormats
  var validate10instance1_7 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_7');
    var pathDiv = $('#item-path-10-instance-1_7');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-10-instance-1_7').change( function() {
    var ok = validate10instance1_7();
    showError('item-error-10-instance-1_7',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-10-instance-1_7').attr('enabled','false');
  $('#remove-button-10-instance-1_8').click(function() {
    $('#repeating-enclosing-10-instance-1_8').hide();
  });

  $('#item-10-instance-1_8').prop('checked',false);

  // dataOutputFormats
  var validate10instance1_8 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_8');
    var pathDiv = $('#item-path-10-instance-1_8');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-10-instance-1_8').change( function() {
    var ok = validate10instance1_8();
    showError('item-error-10-instance-1_8',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-10-instance-1_8').attr('enabled','false');
  $('#remove-button-10-instance-1_9').click(function() {
    $('#repeating-enclosing-10-instance-1_9').hide();
  });

  $('#item-10-instance-1_9').prop('checked',false);

  // dataOutputFormats
  var validate10instance1_9 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_9');
    var pathDiv = $('#item-path-10-instance-1_9');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-10-instance-1_9').change( function() {
    var ok = validate10instance1_9();
    showError('item-error-10-instance-1_9',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-10-instance-1_9').attr('enabled','false');
  $('#remove-button-10-instance-1_10').click(function() {
    $('#repeating-enclosing-10-instance-1_10').hide();
  });

  $('#item-10-instance-1_10').prop('checked',false);

  // dataOutputFormats
  var validate10instance1_10 = function () {
    var ok = true;
    var v = $('#item-10-instance-1_10');
    var pathDiv = $('#item-path-10-instance-1_10');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-10-instance-1_10').change( function() {
    var ok = validate10instance1_10();
    showError('item-error-10-instance-1_10',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-10-instance-1_10').attr('enabled','false');
  $('#repeat-button-10-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-10-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-10-instance-1_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-10-instance-1_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-10-instance-1_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-10-instance-1_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-10-instance-1_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-10-instance-1_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-10-instance-1_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-10-instance-1_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-10-instance-1_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-11-instance-1_1').click(function() {
    $('#repeating-enclosing-11-instance-1_1').hide();
  });

  $('#item-11-instance-1_1').prop('checked',false);

  // sourceCodeRelease
  var validate11instance1_1 = function () {
    var ok = true;
    var v = $('#item-11-instance-1_1');
    var pathDiv = $('#item-path-11-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-11-instance-1_1').change( function() {
    var ok = validate11instance1_1();
    showError('item-error-11-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-11-instance-1_1').attr('enabled','false');
  $('#repeat-button-11-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-11-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-12-instance-1_1').click(function() {
    $('#repeating-enclosing-12-instance-1_1').hide();
  });

  $('#item-12-instance-1_1').prop('checked',false);

  // webApplication
  var validate12instance1_1 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_1');
    var pathDiv = $('#item-path-12-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_1').change( function() {
    var ok = validate12instance1_1();
    showError('item-error-12-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_1').attr('enabled','false');
  $('#remove-button-12-instance-1_2').click(function() {
    $('#repeating-enclosing-12-instance-1_2').hide();
  });

  $('#item-12-instance-1_2').prop('checked',false);

  // webApplication
  var validate12instance1_2 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_2');
    var pathDiv = $('#item-path-12-instance-1_2');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_2').change( function() {
    var ok = validate12instance1_2();
    showError('item-error-12-instance-1_2',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_2').attr('enabled','false');
  $('#remove-button-12-instance-1_3').click(function() {
    $('#repeating-enclosing-12-instance-1_3').hide();
  });

  $('#item-12-instance-1_3').prop('checked',false);

  // webApplication
  var validate12instance1_3 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_3');
    var pathDiv = $('#item-path-12-instance-1_3');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_3').change( function() {
    var ok = validate12instance1_3();
    showError('item-error-12-instance-1_3',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_3').attr('enabled','false');
  $('#remove-button-12-instance-1_4').click(function() {
    $('#repeating-enclosing-12-instance-1_4').hide();
  });

  $('#item-12-instance-1_4').prop('checked',false);

  // webApplication
  var validate12instance1_4 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_4');
    var pathDiv = $('#item-path-12-instance-1_4');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_4').change( function() {
    var ok = validate12instance1_4();
    showError('item-error-12-instance-1_4',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_4').attr('enabled','false');
  $('#remove-button-12-instance-1_5').click(function() {
    $('#repeating-enclosing-12-instance-1_5').hide();
  });

  $('#item-12-instance-1_5').prop('checked',false);

  // webApplication
  var validate12instance1_5 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_5');
    var pathDiv = $('#item-path-12-instance-1_5');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_5').change( function() {
    var ok = validate12instance1_5();
    showError('item-error-12-instance-1_5',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_5').attr('enabled','false');
  $('#remove-button-12-instance-1_6').click(function() {
    $('#repeating-enclosing-12-instance-1_6').hide();
  });

  $('#item-12-instance-1_6').prop('checked',false);

  // webApplication
  var validate12instance1_6 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_6');
    var pathDiv = $('#item-path-12-instance-1_6');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_6').change( function() {
    var ok = validate12instance1_6();
    showError('item-error-12-instance-1_6',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_6').attr('enabled','false');
  $('#remove-button-12-instance-1_7').click(function() {
    $('#repeating-enclosing-12-instance-1_7').hide();
  });

  $('#item-12-instance-1_7').prop('checked',false);

  // webApplication
  var validate12instance1_7 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_7');
    var pathDiv = $('#item-path-12-instance-1_7');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_7').change( function() {
    var ok = validate12instance1_7();
    showError('item-error-12-instance-1_7',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_7').attr('enabled','false');
  $('#remove-button-12-instance-1_8').click(function() {
    $('#repeating-enclosing-12-instance-1_8').hide();
  });

  $('#item-12-instance-1_8').prop('checked',false);

  // webApplication
  var validate12instance1_8 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_8');
    var pathDiv = $('#item-path-12-instance-1_8');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_8').change( function() {
    var ok = validate12instance1_8();
    showError('item-error-12-instance-1_8',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_8').attr('enabled','false');
  $('#remove-button-12-instance-1_9').click(function() {
    $('#repeating-enclosing-12-instance-1_9').hide();
  });

  $('#item-12-instance-1_9').prop('checked',false);

  // webApplication
  var validate12instance1_9 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_9');
    var pathDiv = $('#item-path-12-instance-1_9');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_9').change( function() {
    var ok = validate12instance1_9();
    showError('item-error-12-instance-1_9',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_9').attr('enabled','false');
  $('#remove-button-12-instance-1_10').click(function() {
    $('#repeating-enclosing-12-instance-1_10').hide();
  });

  $('#item-12-instance-1_10').prop('checked',false);

  // webApplication
  var validate12instance1_10 = function () {
    var ok = true;
    var v = $('#item-12-instance-1_10');
    var pathDiv = $('#item-path-12-instance-1_10');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-12-instance-1_10').change( function() {
    var ok = validate12instance1_10();
    showError('item-error-12-instance-1_10',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-12-instance-1_10').attr('enabled','false');
  $('#repeat-button-12-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-12-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-12-instance-1_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-12-instance-1_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-12-instance-1_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-12-instance-1_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-12-instance-1_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-12-instance-1_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-12-instance-1_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-12-instance-1_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-12-instance-1_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-13-instance-1_1').click(function() {
    $('#repeating-enclosing-13-instance-1_1').hide();
  });

  $('#item-13-instance-1_1').prop('checked',false);

  // license
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

  $('#remove-button-14-instance-1_1').click(function() {
    $('#repeating-enclosing-14-instance-1_1').hide();
  });

  $('#item-14-instance-1_1').prop('checked',false);

  // source
  var validate14instance1_1 = function () {
    var ok = true;
    var v = $('#item-14-instance-1_1');
    var pathDiv = $('#item-path-14-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-14-instance-1_1').change( function() {
    var ok = validate14instance1_1();
    showError('item-error-14-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-14-instance-1_1').attr('enabled','false');
  $('#repeat-button-14-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-14-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-15-instance-1_1').click(function() {
    $('#repeating-enclosing-15-instance-1_1').hide();
  });

  $('#item-15-instance-1_1').prop('checked',false);

  // developers
  var validate15instance1_1 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_1');
    var pathDiv = $('#item-path-15-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_1').change( function() {
    var ok = validate15instance1_1();
    showError('item-error-15-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_1').attr('enabled','false');
  $('#remove-button-15-instance-1_2').click(function() {
    $('#repeating-enclosing-15-instance-1_2').hide();
  });

  $('#item-15-instance-1_2').prop('checked',false);

  // developers
  var validate15instance1_2 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_2');
    var pathDiv = $('#item-path-15-instance-1_2');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_2').change( function() {
    var ok = validate15instance1_2();
    showError('item-error-15-instance-1_2',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_2').attr('enabled','false');
  $('#remove-button-15-instance-1_3').click(function() {
    $('#repeating-enclosing-15-instance-1_3').hide();
  });

  $('#item-15-instance-1_3').prop('checked',false);

  // developers
  var validate15instance1_3 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_3');
    var pathDiv = $('#item-path-15-instance-1_3');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_3').change( function() {
    var ok = validate15instance1_3();
    showError('item-error-15-instance-1_3',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_3').attr('enabled','false');
  $('#remove-button-15-instance-1_4').click(function() {
    $('#repeating-enclosing-15-instance-1_4').hide();
  });

  $('#item-15-instance-1_4').prop('checked',false);

  // developers
  var validate15instance1_4 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_4');
    var pathDiv = $('#item-path-15-instance-1_4');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_4').change( function() {
    var ok = validate15instance1_4();
    showError('item-error-15-instance-1_4',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_4').attr('enabled','false');
  $('#remove-button-15-instance-1_5').click(function() {
    $('#repeating-enclosing-15-instance-1_5').hide();
  });

  $('#item-15-instance-1_5').prop('checked',false);

  // developers
  var validate15instance1_5 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_5');
    var pathDiv = $('#item-path-15-instance-1_5');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_5').change( function() {
    var ok = validate15instance1_5();
    showError('item-error-15-instance-1_5',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_5').attr('enabled','false');
  $('#remove-button-15-instance-1_6').click(function() {
    $('#repeating-enclosing-15-instance-1_6').hide();
  });

  $('#item-15-instance-1_6').prop('checked',false);

  // developers
  var validate15instance1_6 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_6');
    var pathDiv = $('#item-path-15-instance-1_6');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_6').change( function() {
    var ok = validate15instance1_6();
    showError('item-error-15-instance-1_6',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_6').attr('enabled','false');
  $('#remove-button-15-instance-1_7').click(function() {
    $('#repeating-enclosing-15-instance-1_7').hide();
  });

  $('#item-15-instance-1_7').prop('checked',false);

  // developers
  var validate15instance1_7 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_7');
    var pathDiv = $('#item-path-15-instance-1_7');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_7').change( function() {
    var ok = validate15instance1_7();
    showError('item-error-15-instance-1_7',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_7').attr('enabled','false');
  $('#remove-button-15-instance-1_8').click(function() {
    $('#repeating-enclosing-15-instance-1_8').hide();
  });

  $('#item-15-instance-1_8').prop('checked',false);

  // developers
  var validate15instance1_8 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_8');
    var pathDiv = $('#item-path-15-instance-1_8');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_8').change( function() {
    var ok = validate15instance1_8();
    showError('item-error-15-instance-1_8',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_8').attr('enabled','false');
  $('#remove-button-15-instance-1_9').click(function() {
    $('#repeating-enclosing-15-instance-1_9').hide();
  });

  $('#item-15-instance-1_9').prop('checked',false);

  // developers
  var validate15instance1_9 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_9');
    var pathDiv = $('#item-path-15-instance-1_9');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_9').change( function() {
    var ok = validate15instance1_9();
    showError('item-error-15-instance-1_9',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_9').attr('enabled','false');
  $('#remove-button-15-instance-1_10').click(function() {
    $('#repeating-enclosing-15-instance-1_10').hide();
  });

  $('#item-15-instance-1_10').prop('checked',false);

  // developers
  var validate15instance1_10 = function () {
    var ok = true;
    var v = $('#item-15-instance-1_10');
    var pathDiv = $('#item-path-15-instance-1_10');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-15-instance-1_10').change( function() {
    var ok = validate15instance1_10();
    showError('item-error-15-instance-1_10',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-15-instance-1_10').attr('enabled','false');
  $('#repeat-button-15-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-15-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-15-instance-1_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-15-instance-1_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-15-instance-1_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-15-instance-1_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-15-instance-1_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-15-instance-1_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-15-instance-1_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-15-instance-1_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-15-instance-1_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-16-instance-1_1').click(function() {
    $('#repeating-enclosing-16-instance-1_1').hide();
  });

  $('#item-16-instance-1_1').prop('checked',false);

  // website
  var validate16instance1_1 = function () {
    var ok = true;
    var v = $('#item-16-instance-1_1');
    var pathDiv = $('#item-path-16-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-16-instance-1_1').change( function() {
    var ok = validate16instance1_1();
    showError('item-error-16-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-16-instance-1_1').attr('enabled','false');
  $('#repeat-button-16-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-16-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-17-instance-1_1').click(function() {
    $('#repeating-enclosing-17-instance-1_1').hide();
  });

  $('#item-17-instance-1_1').prop('checked',false);

  // documentation
  var validate17instance1_1 = function () {
    var ok = true;
    var v = $('#item-17-instance-1_1');
    var pathDiv = $('#item-path-17-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-17-instance-1_1').change( function() {
    var ok = validate17instance1_1();
    showError('item-error-17-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-17-instance-1_1').attr('enabled','false');
  $('#repeat-button-17-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-17-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-18-instance-1_1').click(function() {
    $('#repeating-enclosing-18-instance-1_1').hide();
  });

  $('#item-18-instance-1_1').prop('checked',false);

  // publicationsThatUsedRelease
  var validate18instance1_1 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_1');
    var pathDiv = $('#item-path-18-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-18-instance-1_1').change( function() {
    var ok = validate18instance1_1();
    showError('item-error-18-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-18-instance-1_1').attr('enabled','false');
  $('#remove-button-18-instance-1_2').click(function() {
    $('#repeating-enclosing-18-instance-1_2').hide();
  });

  $('#item-18-instance-1_2').prop('checked',false);

  // publicationsThatUsedRelease
  var validate18instance1_2 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_2');
    var pathDiv = $('#item-path-18-instance-1_2');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-18-instance-1_2').change( function() {
    var ok = validate18instance1_2();
    showError('item-error-18-instance-1_2',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-18-instance-1_2').attr('enabled','false');
  $('#remove-button-18-instance-1_3').click(function() {
    $('#repeating-enclosing-18-instance-1_3').hide();
  });

  $('#item-18-instance-1_3').prop('checked',false);

  // publicationsThatUsedRelease
  var validate18instance1_3 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_3');
    var pathDiv = $('#item-path-18-instance-1_3');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-18-instance-1_3').change( function() {
    var ok = validate18instance1_3();
    showError('item-error-18-instance-1_3',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-18-instance-1_3').attr('enabled','false');
  $('#remove-button-18-instance-1_4').click(function() {
    $('#repeating-enclosing-18-instance-1_4').hide();
  });

  $('#item-18-instance-1_4').prop('checked',false);

  // publicationsThatUsedRelease
  var validate18instance1_4 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_4');
    var pathDiv = $('#item-path-18-instance-1_4');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-18-instance-1_4').change( function() {
    var ok = validate18instance1_4();
    showError('item-error-18-instance-1_4',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-18-instance-1_4').attr('enabled','false');
  $('#remove-button-18-instance-1_5').click(function() {
    $('#repeating-enclosing-18-instance-1_5').hide();
  });

  $('#item-18-instance-1_5').prop('checked',false);

  // publicationsThatUsedRelease
  var validate18instance1_5 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_5');
    var pathDiv = $('#item-path-18-instance-1_5');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-18-instance-1_5').change( function() {
    var ok = validate18instance1_5();
    showError('item-error-18-instance-1_5',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-18-instance-1_5').attr('enabled','false');
  $('#remove-button-18-instance-1_6').click(function() {
    $('#repeating-enclosing-18-instance-1_6').hide();
  });

  $('#item-18-instance-1_6').prop('checked',false);

  // publicationsThatUsedRelease
  var validate18instance1_6 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_6');
    var pathDiv = $('#item-path-18-instance-1_6');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-18-instance-1_6').change( function() {
    var ok = validate18instance1_6();
    showError('item-error-18-instance-1_6',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-18-instance-1_6').attr('enabled','false');
  $('#remove-button-18-instance-1_7').click(function() {
    $('#repeating-enclosing-18-instance-1_7').hide();
  });

  $('#item-18-instance-1_7').prop('checked',false);

  // publicationsThatUsedRelease
  var validate18instance1_7 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_7');
    var pathDiv = $('#item-path-18-instance-1_7');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-18-instance-1_7').change( function() {
    var ok = validate18instance1_7();
    showError('item-error-18-instance-1_7',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-18-instance-1_7').attr('enabled','false');
  $('#remove-button-18-instance-1_8').click(function() {
    $('#repeating-enclosing-18-instance-1_8').hide();
  });

  $('#item-18-instance-1_8').prop('checked',false);

  // publicationsThatUsedRelease
  var validate18instance1_8 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_8');
    var pathDiv = $('#item-path-18-instance-1_8');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-18-instance-1_8').change( function() {
    var ok = validate18instance1_8();
    showError('item-error-18-instance-1_8',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-18-instance-1_8').attr('enabled','false');
  $('#remove-button-18-instance-1_9').click(function() {
    $('#repeating-enclosing-18-instance-1_9').hide();
  });

  $('#item-18-instance-1_9').prop('checked',false);

  // publicationsThatUsedRelease
  var validate18instance1_9 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_9');
    var pathDiv = $('#item-path-18-instance-1_9');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-18-instance-1_9').change( function() {
    var ok = validate18instance1_9();
    showError('item-error-18-instance-1_9',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-18-instance-1_9').attr('enabled','false');
  $('#remove-button-18-instance-1_10').click(function() {
    $('#repeating-enclosing-18-instance-1_10').hide();
  });

  $('#item-18-instance-1_10').prop('checked',false);

  // publicationsThatUsedRelease
  var validate18instance1_10 = function () {
    var ok = true;
    var v = $('#item-18-instance-1_10');
    var pathDiv = $('#item-path-18-instance-1_10');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-18-instance-1_10').change( function() {
    var ok = validate18instance1_10();
    showError('item-error-18-instance-1_10',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-18-instance-1_10').attr('enabled','false');
  $('#repeat-button-18-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-18-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-18-instance-1_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-18-instance-1_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-18-instance-1_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-18-instance-1_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-18-instance-1_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-18-instance-1_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-18-instance-1_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-18-instance-1_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-18-instance-1_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-19-instance-1_1').click(function() {
    $('#repeating-enclosing-19-instance-1_1').hide();
  });

  $('#item-19-instance-1_1').prop('checked',false);

  // executables
  var validate19instance1_1 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_1');
    var pathDiv = $('#item-path-19-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-19-instance-1_1').change( function() {
    var ok = validate19instance1_1();
    showError('item-error-19-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-19-instance-1_1').attr('enabled','false');
  $('#remove-button-19-instance-1_2').click(function() {
    $('#repeating-enclosing-19-instance-1_2').hide();
  });

  $('#item-19-instance-1_2').prop('checked',false);

  // executables
  var validate19instance1_2 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_2');
    var pathDiv = $('#item-path-19-instance-1_2');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-19-instance-1_2').change( function() {
    var ok = validate19instance1_2();
    showError('item-error-19-instance-1_2',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-19-instance-1_2').attr('enabled','false');
  $('#remove-button-19-instance-1_3').click(function() {
    $('#repeating-enclosing-19-instance-1_3').hide();
  });

  $('#item-19-instance-1_3').prop('checked',false);

  // executables
  var validate19instance1_3 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_3');
    var pathDiv = $('#item-path-19-instance-1_3');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-19-instance-1_3').change( function() {
    var ok = validate19instance1_3();
    showError('item-error-19-instance-1_3',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-19-instance-1_3').attr('enabled','false');
  $('#remove-button-19-instance-1_4').click(function() {
    $('#repeating-enclosing-19-instance-1_4').hide();
  });

  $('#item-19-instance-1_4').prop('checked',false);

  // executables
  var validate19instance1_4 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_4');
    var pathDiv = $('#item-path-19-instance-1_4');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-19-instance-1_4').change( function() {
    var ok = validate19instance1_4();
    showError('item-error-19-instance-1_4',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-19-instance-1_4').attr('enabled','false');
  $('#remove-button-19-instance-1_5').click(function() {
    $('#repeating-enclosing-19-instance-1_5').hide();
  });

  $('#item-19-instance-1_5').prop('checked',false);

  // executables
  var validate19instance1_5 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_5');
    var pathDiv = $('#item-path-19-instance-1_5');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-19-instance-1_5').change( function() {
    var ok = validate19instance1_5();
    showError('item-error-19-instance-1_5',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-19-instance-1_5').attr('enabled','false');
  $('#remove-button-19-instance-1_6').click(function() {
    $('#repeating-enclosing-19-instance-1_6').hide();
  });

  $('#item-19-instance-1_6').prop('checked',false);

  // executables
  var validate19instance1_6 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_6');
    var pathDiv = $('#item-path-19-instance-1_6');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-19-instance-1_6').change( function() {
    var ok = validate19instance1_6();
    showError('item-error-19-instance-1_6',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-19-instance-1_6').attr('enabled','false');
  $('#remove-button-19-instance-1_7').click(function() {
    $('#repeating-enclosing-19-instance-1_7').hide();
  });

  $('#item-19-instance-1_7').prop('checked',false);

  // executables
  var validate19instance1_7 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_7');
    var pathDiv = $('#item-path-19-instance-1_7');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-19-instance-1_7').change( function() {
    var ok = validate19instance1_7();
    showError('item-error-19-instance-1_7',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-19-instance-1_7').attr('enabled','false');
  $('#remove-button-19-instance-1_8').click(function() {
    $('#repeating-enclosing-19-instance-1_8').hide();
  });

  $('#item-19-instance-1_8').prop('checked',false);

  // executables
  var validate19instance1_8 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_8');
    var pathDiv = $('#item-path-19-instance-1_8');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-19-instance-1_8').change( function() {
    var ok = validate19instance1_8();
    showError('item-error-19-instance-1_8',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-19-instance-1_8').attr('enabled','false');
  $('#remove-button-19-instance-1_9').click(function() {
    $('#repeating-enclosing-19-instance-1_9').hide();
  });

  $('#item-19-instance-1_9').prop('checked',false);

  // executables
  var validate19instance1_9 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_9');
    var pathDiv = $('#item-path-19-instance-1_9');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-19-instance-1_9').change( function() {
    var ok = validate19instance1_9();
    showError('item-error-19-instance-1_9',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-19-instance-1_9').attr('enabled','false');
  $('#remove-button-19-instance-1_10').click(function() {
    $('#repeating-enclosing-19-instance-1_10').hide();
  });

  $('#item-19-instance-1_10').prop('checked',false);

  // executables
  var validate19instance1_10 = function () {
    var ok = true;
    var v = $('#item-19-instance-1_10');
    var pathDiv = $('#item-path-19-instance-1_10');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-19-instance-1_10').change( function() {
    var ok = validate19instance1_10();
    showError('item-error-19-instance-1_10',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-19-instance-1_10').attr('enabled','false');
  $('#repeat-button-19-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-19-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-19-instance-1_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-19-instance-1_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-19-instance-1_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-19-instance-1_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-19-instance-1_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-19-instance-1_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-19-instance-1_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-19-instance-1_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-19-instance-1_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-20-instance-1_1').click(function() {
    $('#repeating-enclosing-20-instance-1_1').hide();
  });

  $('#item-20-instance-1_1').prop('checked',false);

  // version
  var validate20instance1_1 = function () {
    var ok = true;
    var v = $('#item-20-instance-1_1');
    var pathDiv = $('#item-path-20-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-20-instance-1_1').change( function() {
    var ok = validate20instance1_1();
    showError('item-error-20-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-20-instance-1_1').attr('enabled','false');
  $('#remove-button-20-instance-1_2').click(function() {
    $('#repeating-enclosing-20-instance-1_2').hide();
  });

  $('#item-20-instance-1_2').prop('checked',false);

  // version
  var validate20instance1_2 = function () {
    var ok = true;
    var v = $('#item-20-instance-1_2');
    var pathDiv = $('#item-path-20-instance-1_2');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-20-instance-1_2').change( function() {
    var ok = validate20instance1_2();
    showError('item-error-20-instance-1_2',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-20-instance-1_2').attr('enabled','false');
  $('#remove-button-20-instance-1_3').click(function() {
    $('#repeating-enclosing-20-instance-1_3').hide();
  });

  $('#item-20-instance-1_3').prop('checked',false);

  // version
  var validate20instance1_3 = function () {
    var ok = true;
    var v = $('#item-20-instance-1_3');
    var pathDiv = $('#item-path-20-instance-1_3');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-20-instance-1_3').change( function() {
    var ok = validate20instance1_3();
    showError('item-error-20-instance-1_3',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-20-instance-1_3').attr('enabled','false');
  $('#remove-button-20-instance-1_4').click(function() {
    $('#repeating-enclosing-20-instance-1_4').hide();
  });

  $('#item-20-instance-1_4').prop('checked',false);

  // version
  var validate20instance1_4 = function () {
    var ok = true;
    var v = $('#item-20-instance-1_4');
    var pathDiv = $('#item-path-20-instance-1_4');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-20-instance-1_4').change( function() {
    var ok = validate20instance1_4();
    showError('item-error-20-instance-1_4',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-20-instance-1_4').attr('enabled','false');
  $('#remove-button-20-instance-1_5').click(function() {
    $('#repeating-enclosing-20-instance-1_5').hide();
  });

  $('#item-20-instance-1_5').prop('checked',false);

  // version
  var validate20instance1_5 = function () {
    var ok = true;
    var v = $('#item-20-instance-1_5');
    var pathDiv = $('#item-path-20-instance-1_5');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-20-instance-1_5').change( function() {
    var ok = validate20instance1_5();
    showError('item-error-20-instance-1_5',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-20-instance-1_5').attr('enabled','false');
  $('#remove-button-20-instance-1_6').click(function() {
    $('#repeating-enclosing-20-instance-1_6').hide();
  });

  $('#item-20-instance-1_6').prop('checked',false);

  // version
  var validate20instance1_6 = function () {
    var ok = true;
    var v = $('#item-20-instance-1_6');
    var pathDiv = $('#item-path-20-instance-1_6');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-20-instance-1_6').change( function() {
    var ok = validate20instance1_6();
    showError('item-error-20-instance-1_6',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-20-instance-1_6').attr('enabled','false');
  $('#remove-button-20-instance-1_7').click(function() {
    $('#repeating-enclosing-20-instance-1_7').hide();
  });

  $('#item-20-instance-1_7').prop('checked',false);

  // version
  var validate20instance1_7 = function () {
    var ok = true;
    var v = $('#item-20-instance-1_7');
    var pathDiv = $('#item-path-20-instance-1_7');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-20-instance-1_7').change( function() {
    var ok = validate20instance1_7();
    showError('item-error-20-instance-1_7',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-20-instance-1_7').attr('enabled','false');
  $('#remove-button-20-instance-1_8').click(function() {
    $('#repeating-enclosing-20-instance-1_8').hide();
  });

  $('#item-20-instance-1_8').prop('checked',false);

  // version
  var validate20instance1_8 = function () {
    var ok = true;
    var v = $('#item-20-instance-1_8');
    var pathDiv = $('#item-path-20-instance-1_8');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-20-instance-1_8').change( function() {
    var ok = validate20instance1_8();
    showError('item-error-20-instance-1_8',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-20-instance-1_8').attr('enabled','false');
  $('#remove-button-20-instance-1_9').click(function() {
    $('#repeating-enclosing-20-instance-1_9').hide();
  });

  $('#item-20-instance-1_9').prop('checked',false);

  // version
  var validate20instance1_9 = function () {
    var ok = true;
    var v = $('#item-20-instance-1_9');
    var pathDiv = $('#item-path-20-instance-1_9');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-20-instance-1_9').change( function() {
    var ok = validate20instance1_9();
    showError('item-error-20-instance-1_9',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-20-instance-1_9').attr('enabled','false');
  $('#remove-button-20-instance-1_10').click(function() {
    $('#repeating-enclosing-20-instance-1_10').hide();
  });

  $('#item-20-instance-1_10').prop('checked',false);

  // version
  var validate20instance1_10 = function () {
    var ok = true;
    var v = $('#item-20-instance-1_10');
    var pathDiv = $('#item-path-20-instance-1_10');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-20-instance-1_10').change( function() {
    var ok = validate20instance1_10();
    showError('item-error-20-instance-1_10',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-20-instance-1_10').attr('enabled','false');
  $('#repeat-button-20-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-20-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-20-instance-1_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-20-instance-1_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-20-instance-1_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-20-instance-1_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-20-instance-1_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-20-instance-1_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-20-instance-1_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-20-instance-1_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-20-instance-1_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-21-instance-1_1').click(function() {
    $('#repeating-enclosing-21-instance-1_1').hide();
  });

  $('#item-21-instance-1_1').prop('checked',false);

  // publicationsAboutRelease
  var validate21instance1_1 = function () {
    var ok = true;
    var v = $('#item-21-instance-1_1');
    var pathDiv = $('#item-path-21-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-21-instance-1_1').change( function() {
    var ok = validate21instance1_1();
    showError('item-error-21-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-21-instance-1_1').attr('enabled','false');
  $('#remove-button-21-instance-1_2').click(function() {
    $('#repeating-enclosing-21-instance-1_2').hide();
  });

  $('#item-21-instance-1_2').prop('checked',false);

  // publicationsAboutRelease
  var validate21instance1_2 = function () {
    var ok = true;
    var v = $('#item-21-instance-1_2');
    var pathDiv = $('#item-path-21-instance-1_2');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-21-instance-1_2').change( function() {
    var ok = validate21instance1_2();
    showError('item-error-21-instance-1_2',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-21-instance-1_2').attr('enabled','false');
  $('#remove-button-21-instance-1_3').click(function() {
    $('#repeating-enclosing-21-instance-1_3').hide();
  });

  $('#item-21-instance-1_3').prop('checked',false);

  // publicationsAboutRelease
  var validate21instance1_3 = function () {
    var ok = true;
    var v = $('#item-21-instance-1_3');
    var pathDiv = $('#item-path-21-instance-1_3');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-21-instance-1_3').change( function() {
    var ok = validate21instance1_3();
    showError('item-error-21-instance-1_3',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-21-instance-1_3').attr('enabled','false');
  $('#remove-button-21-instance-1_4').click(function() {
    $('#repeating-enclosing-21-instance-1_4').hide();
  });

  $('#item-21-instance-1_4').prop('checked',false);

  // publicationsAboutRelease
  var validate21instance1_4 = function () {
    var ok = true;
    var v = $('#item-21-instance-1_4');
    var pathDiv = $('#item-path-21-instance-1_4');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-21-instance-1_4').change( function() {
    var ok = validate21instance1_4();
    showError('item-error-21-instance-1_4',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-21-instance-1_4').attr('enabled','false');
  $('#remove-button-21-instance-1_5').click(function() {
    $('#repeating-enclosing-21-instance-1_5').hide();
  });

  $('#item-21-instance-1_5').prop('checked',false);

  // publicationsAboutRelease
  var validate21instance1_5 = function () {
    var ok = true;
    var v = $('#item-21-instance-1_5');
    var pathDiv = $('#item-path-21-instance-1_5');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-21-instance-1_5').change( function() {
    var ok = validate21instance1_5();
    showError('item-error-21-instance-1_5',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-21-instance-1_5').attr('enabled','false');
  $('#remove-button-21-instance-1_6').click(function() {
    $('#repeating-enclosing-21-instance-1_6').hide();
  });

  $('#item-21-instance-1_6').prop('checked',false);

  // publicationsAboutRelease
  var validate21instance1_6 = function () {
    var ok = true;
    var v = $('#item-21-instance-1_6');
    var pathDiv = $('#item-path-21-instance-1_6');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-21-instance-1_6').change( function() {
    var ok = validate21instance1_6();
    showError('item-error-21-instance-1_6',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-21-instance-1_6').attr('enabled','false');
  $('#remove-button-21-instance-1_7').click(function() {
    $('#repeating-enclosing-21-instance-1_7').hide();
  });

  $('#item-21-instance-1_7').prop('checked',false);

  // publicationsAboutRelease
  var validate21instance1_7 = function () {
    var ok = true;
    var v = $('#item-21-instance-1_7');
    var pathDiv = $('#item-path-21-instance-1_7');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-21-instance-1_7').change( function() {
    var ok = validate21instance1_7();
    showError('item-error-21-instance-1_7',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-21-instance-1_7').attr('enabled','false');
  $('#remove-button-21-instance-1_8').click(function() {
    $('#repeating-enclosing-21-instance-1_8').hide();
  });

  $('#item-21-instance-1_8').prop('checked',false);

  // publicationsAboutRelease
  var validate21instance1_8 = function () {
    var ok = true;
    var v = $('#item-21-instance-1_8');
    var pathDiv = $('#item-path-21-instance-1_8');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-21-instance-1_8').change( function() {
    var ok = validate21instance1_8();
    showError('item-error-21-instance-1_8',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-21-instance-1_8').attr('enabled','false');
  $('#remove-button-21-instance-1_9').click(function() {
    $('#repeating-enclosing-21-instance-1_9').hide();
  });

  $('#item-21-instance-1_9').prop('checked',false);

  // publicationsAboutRelease
  var validate21instance1_9 = function () {
    var ok = true;
    var v = $('#item-21-instance-1_9');
    var pathDiv = $('#item-path-21-instance-1_9');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-21-instance-1_9').change( function() {
    var ok = validate21instance1_9();
    showError('item-error-21-instance-1_9',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-21-instance-1_9').attr('enabled','false');
  $('#remove-button-21-instance-1_10').click(function() {
    $('#repeating-enclosing-21-instance-1_10').hide();
  });

  $('#item-21-instance-1_10').prop('checked',false);

  // publicationsAboutRelease
  var validate21instance1_10 = function () {
    var ok = true;
    var v = $('#item-21-instance-1_10');
    var pathDiv = $('#item-path-21-instance-1_10');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-21-instance-1_10').change( function() {
    var ok = validate21instance1_10();
    showError('item-error-21-instance-1_10',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-21-instance-1_10').attr('enabled','false');
  $('#repeat-button-21-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-21-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-21-instance-1_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-21-instance-1_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-21-instance-1_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-21-instance-1_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-21-instance-1_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-21-instance-1_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-21-instance-1_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-21-instance-1_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-21-instance-1_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-22-instance-1_1').click(function() {
    $('#repeating-enclosing-22-instance-1_1').hide();
  });

  $('#item-22-instance-1_1').prop('checked',false);

  // grants
  var validate22instance1_1 = function () {
    var ok = true;
    var v = $('#item-22-instance-1_1');
    var pathDiv = $('#item-path-22-instance-1_1');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-22-instance-1_1').change( function() {
    var ok = validate22instance1_1();
    showError('item-error-22-instance-1_1',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-22-instance-1_1').attr('enabled','false');
  $('#remove-button-22-instance-1_2').click(function() {
    $('#repeating-enclosing-22-instance-1_2').hide();
  });

  $('#item-22-instance-1_2').prop('checked',false);

  // grants
  var validate22instance1_2 = function () {
    var ok = true;
    var v = $('#item-22-instance-1_2');
    var pathDiv = $('#item-path-22-instance-1_2');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-22-instance-1_2').change( function() {
    var ok = validate22instance1_2();
    showError('item-error-22-instance-1_2',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-22-instance-1_2').attr('enabled','false');
  $('#remove-button-22-instance-1_3').click(function() {
    $('#repeating-enclosing-22-instance-1_3').hide();
  });

  $('#item-22-instance-1_3').prop('checked',false);

  // grants
  var validate22instance1_3 = function () {
    var ok = true;
    var v = $('#item-22-instance-1_3');
    var pathDiv = $('#item-path-22-instance-1_3');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-22-instance-1_3').change( function() {
    var ok = validate22instance1_3();
    showError('item-error-22-instance-1_3',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-22-instance-1_3').attr('enabled','false');
  $('#remove-button-22-instance-1_4').click(function() {
    $('#repeating-enclosing-22-instance-1_4').hide();
  });

  $('#item-22-instance-1_4').prop('checked',false);

  // grants
  var validate22instance1_4 = function () {
    var ok = true;
    var v = $('#item-22-instance-1_4');
    var pathDiv = $('#item-path-22-instance-1_4');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-22-instance-1_4').change( function() {
    var ok = validate22instance1_4();
    showError('item-error-22-instance-1_4',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-22-instance-1_4').attr('enabled','false');
  $('#remove-button-22-instance-1_5').click(function() {
    $('#repeating-enclosing-22-instance-1_5').hide();
  });

  $('#item-22-instance-1_5').prop('checked',false);

  // grants
  var validate22instance1_5 = function () {
    var ok = true;
    var v = $('#item-22-instance-1_5');
    var pathDiv = $('#item-path-22-instance-1_5');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-22-instance-1_5').change( function() {
    var ok = validate22instance1_5();
    showError('item-error-22-instance-1_5',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-22-instance-1_5').attr('enabled','false');
  $('#remove-button-22-instance-1_6').click(function() {
    $('#repeating-enclosing-22-instance-1_6').hide();
  });

  $('#item-22-instance-1_6').prop('checked',false);

  // grants
  var validate22instance1_6 = function () {
    var ok = true;
    var v = $('#item-22-instance-1_6');
    var pathDiv = $('#item-path-22-instance-1_6');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-22-instance-1_6').change( function() {
    var ok = validate22instance1_6();
    showError('item-error-22-instance-1_6',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-22-instance-1_6').attr('enabled','false');
  $('#remove-button-22-instance-1_7').click(function() {
    $('#repeating-enclosing-22-instance-1_7').hide();
  });

  $('#item-22-instance-1_7').prop('checked',false);

  // grants
  var validate22instance1_7 = function () {
    var ok = true;
    var v = $('#item-22-instance-1_7');
    var pathDiv = $('#item-path-22-instance-1_7');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-22-instance-1_7').change( function() {
    var ok = validate22instance1_7();
    showError('item-error-22-instance-1_7',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-22-instance-1_7').attr('enabled','false');
  $('#remove-button-22-instance-1_8').click(function() {
    $('#repeating-enclosing-22-instance-1_8').hide();
  });

  $('#item-22-instance-1_8').prop('checked',false);

  // grants
  var validate22instance1_8 = function () {
    var ok = true;
    var v = $('#item-22-instance-1_8');
    var pathDiv = $('#item-path-22-instance-1_8');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-22-instance-1_8').change( function() {
    var ok = validate22instance1_8();
    showError('item-error-22-instance-1_8',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-22-instance-1_8').attr('enabled','false');
  $('#remove-button-22-instance-1_9').click(function() {
    $('#repeating-enclosing-22-instance-1_9').hide();
  });

  $('#item-22-instance-1_9').prop('checked',false);

  // grants
  var validate22instance1_9 = function () {
    var ok = true;
    var v = $('#item-22-instance-1_9');
    var pathDiv = $('#item-path-22-instance-1_9');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-22-instance-1_9').change( function() {
    var ok = validate22instance1_9();
    showError('item-error-22-instance-1_9',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-22-instance-1_9').attr('enabled','false');
  $('#remove-button-22-instance-1_10').click(function() {
    $('#repeating-enclosing-22-instance-1_10').hide();
  });

  $('#item-22-instance-1_10').prop('checked',false);

  // grants
  var validate22instance1_10 = function () {
    var ok = true;
    var v = $('#item-22-instance-1_10');
    var pathDiv = $('#item-path-22-instance-1_10');
    //length test
    if (v.val().length <1)
      ok = false;
    // minOccurs=0, ok if blank
    var isBlank  = (v.val() == null) || (v.val().length==0);
    if (isBlank) ok = true;
    return ok;
  }
  
  $('#item-22-instance-1_10').change( function() {
    var ok = validate22instance1_10();
    showError('item-error-22-instance-1_10',ok);
  });
  
  //disable item-path due to minOccurs=0 and default is empty
  $('#item-path-22-instance-1_10').attr('enabled','false');
  $('#repeat-button-22-instance-1').click( function() {
    // loop through all repeats until find first nonInvisible repeat and make it visible
    var elem;
    elem = $('#repeating-enclosing-22-instance-1_1');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-22-instance-1_2');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-22-instance-1_3');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-22-instance-1_4');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-22-instance-1_5');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-22-instance-1_6');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-22-instance-1_7');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-22-instance-1_8');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-22-instance-1_9');
    if (!elemVisible(elem))
      { elem.show(); return; }
    elem = $('#repeating-enclosing-22-instance-1_10');
    if (!elemVisible(elem))
      { elem.show(); return; }
  })

  $('#remove-button-23-instance-1_1').click(function() {
    $('#repeating-enclosing-23-instance-1_1').hide();
  });

  $('#item-23-instance-1_1').prop('checked',false);

  // availableOnOlympus
  var validate23instance1_1 = function () {
    var ok = true;
    var v = $('#item-23-instance-1_1');
    var pathDiv = $('#item-path-23-instance-1_1');
    return ok;
  }
  
  $('#item-23-instance-1_1').change( function() {
    var ok = validate23instance1_1();
    showError('item-error-23-instance-1_1',ok);
  });
  
  $('#remove-button-24-instance-1_1').click(function() {
    $('#repeating-enclosing-24-instance-1_1').hide();
  });

  $('#item-24-instance-1_1').prop('checked',false);

  // availableOnUIDS
  var validate24instance1_1 = function () {
    var ok = true;
    var v = $('#item-24-instance-1_1');
    var pathDiv = $('#item-path-24-instance-1_1');
    return ok;
  }
  
  $('#item-24-instance-1_1').change( function() {
    var ok = validate24instance1_1();
    showError('item-error-24-instance-1_1',ok);
  });
  
  $('#remove-button-25-instance-1_1').click(function() {
    $('#repeating-enclosing-25-instance-1_1').hide();
  });

  $('#item-25-instance-1_1').prop('checked',false);

  // signInRequired
  var validate25instance1_1 = function () {
    var ok = true;
    var v = $('#item-25-instance-1_1');
    var pathDiv = $('#item-path-25-instance-1_1');
    return ok;
  }
  
  $('#item-25-instance-1_1').change( function() {
    var ok = validate25instance1_1();
    showError('item-error-25-instance-1_1',ok);
  });
  
  //extract xml from element <product>
  function getXml2instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-2-instance-1_1')) {
    var v = encodedValueById("item-2-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<product>' + v + '</product>';
  }
   return xml;
  }

  //extract xml from element <title>
  function getXml3instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-3-instance-1_1')) {
    var v = encodedValueById("item-3-instance-1_1");
    xml += '\n' + spaces(2) + '<title>' + v + '</title>';
  }
   return xml;
  }

  //extract xml from element <humanReadableSynopsis>
  function getXml4instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-4-instance-1_1')) {
    var v = encodedValueById("item-4-instance-1_1");
    xml += '\n' + spaces(2) + '<humanReadableSynopsis>' + v + '</humanReadableSynopsis>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml6instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-6-instance-1_1_1')) {
    var v = encodedValueById("item-6-instance-1_1_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifier>' + v + '</identifier>';
  }
   return xml;
  }

  //extract xml from element <identifierSource>
  function getXml7instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-7-instance-1_1_1')) {
    var v = encodedValueById("item-7-instance-1_1_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierSource>' + v + '</identifierSource>';
  }
   return xml;
  }

  //extract xml from element <identifierDescription>
  function getXml8instance1_1() {

  var xml='';
  if (idVisible('repeating-enclosing-8-instance-1_1_1')) {
    var v = encodedValueById("item-8-instance-1_1_1");
    if (v.length>0)
      xml += '\n' + spaces(4) + '<identifierDescription>' + v + '</identifierDescription>';
  }
   return xml;
  }

  //extract xml from element <identifier>
  function getXml5instance1() {

if (!$('#min-occurs-zero-5-instance-1').is(':checked')) return '';
    var xml = '\n' + spaces(2) + '<identifier>';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-5-instance-1_1')) {
      xml += getXml6instance1_1();
      xml += getXml7instance1_1();
      xml += getXml8instance1_1();
    }
    xml += '\n' + spaces(2) + '</identifier>';
    return xml;
  }

  //extract xml from element <dataInputFormats>
  function getXml9instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-9-instance-1_1')) {
    var v = encodedValueById("item-9-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataInputFormats>' + v + '</dataInputFormats>';
  }
  if (idVisible('repeating-enclosing-9-instance-1_2')) {
    var v = encodedValueById("item-9-instance-1_2");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataInputFormats>' + v + '</dataInputFormats>';
  }
  if (idVisible('repeating-enclosing-9-instance-1_3')) {
    var v = encodedValueById("item-9-instance-1_3");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataInputFormats>' + v + '</dataInputFormats>';
  }
  if (idVisible('repeating-enclosing-9-instance-1_4')) {
    var v = encodedValueById("item-9-instance-1_4");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataInputFormats>' + v + '</dataInputFormats>';
  }
  if (idVisible('repeating-enclosing-9-instance-1_5')) {
    var v = encodedValueById("item-9-instance-1_5");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataInputFormats>' + v + '</dataInputFormats>';
  }
  if (idVisible('repeating-enclosing-9-instance-1_6')) {
    var v = encodedValueById("item-9-instance-1_6");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataInputFormats>' + v + '</dataInputFormats>';
  }
  if (idVisible('repeating-enclosing-9-instance-1_7')) {
    var v = encodedValueById("item-9-instance-1_7");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataInputFormats>' + v + '</dataInputFormats>';
  }
  if (idVisible('repeating-enclosing-9-instance-1_8')) {
    var v = encodedValueById("item-9-instance-1_8");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataInputFormats>' + v + '</dataInputFormats>';
  }
  if (idVisible('repeating-enclosing-9-instance-1_9')) {
    var v = encodedValueById("item-9-instance-1_9");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataInputFormats>' + v + '</dataInputFormats>';
  }
  if (idVisible('repeating-enclosing-9-instance-1_10')) {
    var v = encodedValueById("item-9-instance-1_10");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataInputFormats>' + v + '</dataInputFormats>';
  }
   return xml;
  }

  //extract xml from element <dataOutputFormats>
  function getXml10instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-10-instance-1_1')) {
    var v = encodedValueById("item-10-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataOutputFormats>' + v + '</dataOutputFormats>';
  }
  if (idVisible('repeating-enclosing-10-instance-1_2')) {
    var v = encodedValueById("item-10-instance-1_2");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataOutputFormats>' + v + '</dataOutputFormats>';
  }
  if (idVisible('repeating-enclosing-10-instance-1_3')) {
    var v = encodedValueById("item-10-instance-1_3");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataOutputFormats>' + v + '</dataOutputFormats>';
  }
  if (idVisible('repeating-enclosing-10-instance-1_4')) {
    var v = encodedValueById("item-10-instance-1_4");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataOutputFormats>' + v + '</dataOutputFormats>';
  }
  if (idVisible('repeating-enclosing-10-instance-1_5')) {
    var v = encodedValueById("item-10-instance-1_5");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataOutputFormats>' + v + '</dataOutputFormats>';
  }
  if (idVisible('repeating-enclosing-10-instance-1_6')) {
    var v = encodedValueById("item-10-instance-1_6");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataOutputFormats>' + v + '</dataOutputFormats>';
  }
  if (idVisible('repeating-enclosing-10-instance-1_7')) {
    var v = encodedValueById("item-10-instance-1_7");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataOutputFormats>' + v + '</dataOutputFormats>';
  }
  if (idVisible('repeating-enclosing-10-instance-1_8')) {
    var v = encodedValueById("item-10-instance-1_8");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataOutputFormats>' + v + '</dataOutputFormats>';
  }
  if (idVisible('repeating-enclosing-10-instance-1_9')) {
    var v = encodedValueById("item-10-instance-1_9");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataOutputFormats>' + v + '</dataOutputFormats>';
  }
  if (idVisible('repeating-enclosing-10-instance-1_10')) {
    var v = encodedValueById("item-10-instance-1_10");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<dataOutputFormats>' + v + '</dataOutputFormats>';
  }
   return xml;
  }

  //extract xml from element <sourceCodeRelease>
  function getXml11instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-11-instance-1_1')) {
    var v = encodedValueById("item-11-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<sourceCodeRelease>' + v + '</sourceCodeRelease>';
  }
   return xml;
  }

  //extract xml from element <webApplication>
  function getXml12instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-12-instance-1_1')) {
    var v = encodedValueById("item-12-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<webApplication>' + v + '</webApplication>';
  }
  if (idVisible('repeating-enclosing-12-instance-1_2')) {
    var v = encodedValueById("item-12-instance-1_2");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<webApplication>' + v + '</webApplication>';
  }
  if (idVisible('repeating-enclosing-12-instance-1_3')) {
    var v = encodedValueById("item-12-instance-1_3");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<webApplication>' + v + '</webApplication>';
  }
  if (idVisible('repeating-enclosing-12-instance-1_4')) {
    var v = encodedValueById("item-12-instance-1_4");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<webApplication>' + v + '</webApplication>';
  }
  if (idVisible('repeating-enclosing-12-instance-1_5')) {
    var v = encodedValueById("item-12-instance-1_5");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<webApplication>' + v + '</webApplication>';
  }
  if (idVisible('repeating-enclosing-12-instance-1_6')) {
    var v = encodedValueById("item-12-instance-1_6");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<webApplication>' + v + '</webApplication>';
  }
  if (idVisible('repeating-enclosing-12-instance-1_7')) {
    var v = encodedValueById("item-12-instance-1_7");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<webApplication>' + v + '</webApplication>';
  }
  if (idVisible('repeating-enclosing-12-instance-1_8')) {
    var v = encodedValueById("item-12-instance-1_8");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<webApplication>' + v + '</webApplication>';
  }
  if (idVisible('repeating-enclosing-12-instance-1_9')) {
    var v = encodedValueById("item-12-instance-1_9");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<webApplication>' + v + '</webApplication>';
  }
  if (idVisible('repeating-enclosing-12-instance-1_10')) {
    var v = encodedValueById("item-12-instance-1_10");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<webApplication>' + v + '</webApplication>';
  }
   return xml;
  }

  //extract xml from element <license>
  function getXml13instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-13-instance-1_1')) {
    var v = encodedValueById("item-13-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<license>' + v + '</license>';
  }
   return xml;
  }

  //extract xml from element <source>
  function getXml14instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-14-instance-1_1')) {
    var v = encodedValueById("item-14-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<source>' + v + '</source>';
  }
   return xml;
  }

  //extract xml from element <developers>
  function getXml15instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-15-instance-1_1')) {
    var v = encodedValueById("item-15-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<developers>' + v + '</developers>';
  }
  if (idVisible('repeating-enclosing-15-instance-1_2')) {
    var v = encodedValueById("item-15-instance-1_2");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<developers>' + v + '</developers>';
  }
  if (idVisible('repeating-enclosing-15-instance-1_3')) {
    var v = encodedValueById("item-15-instance-1_3");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<developers>' + v + '</developers>';
  }
  if (idVisible('repeating-enclosing-15-instance-1_4')) {
    var v = encodedValueById("item-15-instance-1_4");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<developers>' + v + '</developers>';
  }
  if (idVisible('repeating-enclosing-15-instance-1_5')) {
    var v = encodedValueById("item-15-instance-1_5");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<developers>' + v + '</developers>';
  }
  if (idVisible('repeating-enclosing-15-instance-1_6')) {
    var v = encodedValueById("item-15-instance-1_6");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<developers>' + v + '</developers>';
  }
  if (idVisible('repeating-enclosing-15-instance-1_7')) {
    var v = encodedValueById("item-15-instance-1_7");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<developers>' + v + '</developers>';
  }
  if (idVisible('repeating-enclosing-15-instance-1_8')) {
    var v = encodedValueById("item-15-instance-1_8");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<developers>' + v + '</developers>';
  }
  if (idVisible('repeating-enclosing-15-instance-1_9')) {
    var v = encodedValueById("item-15-instance-1_9");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<developers>' + v + '</developers>';
  }
  if (idVisible('repeating-enclosing-15-instance-1_10')) {
    var v = encodedValueById("item-15-instance-1_10");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<developers>' + v + '</developers>';
  }
   return xml;
  }

  //extract xml from element <website>
  function getXml16instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-16-instance-1_1')) {
    var v = encodedValueById("item-16-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<website>' + v + '</website>';
  }
   return xml;
  }

  //extract xml from element <documentation>
  function getXml17instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-17-instance-1_1')) {
    var v = encodedValueById("item-17-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<documentation>' + v + '</documentation>';
  }
   return xml;
  }

  //extract xml from element <publicationsThatUsedRelease>
  function getXml18instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-18-instance-1_1')) {
    var v = encodedValueById("item-18-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsThatUsedRelease>' + v + '</publicationsThatUsedRelease>';
  }
  if (idVisible('repeating-enclosing-18-instance-1_2')) {
    var v = encodedValueById("item-18-instance-1_2");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsThatUsedRelease>' + v + '</publicationsThatUsedRelease>';
  }
  if (idVisible('repeating-enclosing-18-instance-1_3')) {
    var v = encodedValueById("item-18-instance-1_3");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsThatUsedRelease>' + v + '</publicationsThatUsedRelease>';
  }
  if (idVisible('repeating-enclosing-18-instance-1_4')) {
    var v = encodedValueById("item-18-instance-1_4");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsThatUsedRelease>' + v + '</publicationsThatUsedRelease>';
  }
  if (idVisible('repeating-enclosing-18-instance-1_5')) {
    var v = encodedValueById("item-18-instance-1_5");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsThatUsedRelease>' + v + '</publicationsThatUsedRelease>';
  }
  if (idVisible('repeating-enclosing-18-instance-1_6')) {
    var v = encodedValueById("item-18-instance-1_6");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsThatUsedRelease>' + v + '</publicationsThatUsedRelease>';
  }
  if (idVisible('repeating-enclosing-18-instance-1_7')) {
    var v = encodedValueById("item-18-instance-1_7");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsThatUsedRelease>' + v + '</publicationsThatUsedRelease>';
  }
  if (idVisible('repeating-enclosing-18-instance-1_8')) {
    var v = encodedValueById("item-18-instance-1_8");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsThatUsedRelease>' + v + '</publicationsThatUsedRelease>';
  }
  if (idVisible('repeating-enclosing-18-instance-1_9')) {
    var v = encodedValueById("item-18-instance-1_9");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsThatUsedRelease>' + v + '</publicationsThatUsedRelease>';
  }
  if (idVisible('repeating-enclosing-18-instance-1_10')) {
    var v = encodedValueById("item-18-instance-1_10");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsThatUsedRelease>' + v + '</publicationsThatUsedRelease>';
  }
   return xml;
  }

  //extract xml from element <executables>
  function getXml19instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-19-instance-1_1')) {
    var v = encodedValueById("item-19-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<executables>' + v + '</executables>';
  }
  if (idVisible('repeating-enclosing-19-instance-1_2')) {
    var v = encodedValueById("item-19-instance-1_2");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<executables>' + v + '</executables>';
  }
  if (idVisible('repeating-enclosing-19-instance-1_3')) {
    var v = encodedValueById("item-19-instance-1_3");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<executables>' + v + '</executables>';
  }
  if (idVisible('repeating-enclosing-19-instance-1_4')) {
    var v = encodedValueById("item-19-instance-1_4");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<executables>' + v + '</executables>';
  }
  if (idVisible('repeating-enclosing-19-instance-1_5')) {
    var v = encodedValueById("item-19-instance-1_5");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<executables>' + v + '</executables>';
  }
  if (idVisible('repeating-enclosing-19-instance-1_6')) {
    var v = encodedValueById("item-19-instance-1_6");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<executables>' + v + '</executables>';
  }
  if (idVisible('repeating-enclosing-19-instance-1_7')) {
    var v = encodedValueById("item-19-instance-1_7");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<executables>' + v + '</executables>';
  }
  if (idVisible('repeating-enclosing-19-instance-1_8')) {
    var v = encodedValueById("item-19-instance-1_8");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<executables>' + v + '</executables>';
  }
  if (idVisible('repeating-enclosing-19-instance-1_9')) {
    var v = encodedValueById("item-19-instance-1_9");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<executables>' + v + '</executables>';
  }
  if (idVisible('repeating-enclosing-19-instance-1_10')) {
    var v = encodedValueById("item-19-instance-1_10");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<executables>' + v + '</executables>';
  }
   return xml;
  }

  //extract xml from element <version>
  function getXml20instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-20-instance-1_1')) {
    var v = encodedValueById("item-20-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<version>' + v + '</version>';
  }
  if (idVisible('repeating-enclosing-20-instance-1_2')) {
    var v = encodedValueById("item-20-instance-1_2");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<version>' + v + '</version>';
  }
  if (idVisible('repeating-enclosing-20-instance-1_3')) {
    var v = encodedValueById("item-20-instance-1_3");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<version>' + v + '</version>';
  }
  if (idVisible('repeating-enclosing-20-instance-1_4')) {
    var v = encodedValueById("item-20-instance-1_4");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<version>' + v + '</version>';
  }
  if (idVisible('repeating-enclosing-20-instance-1_5')) {
    var v = encodedValueById("item-20-instance-1_5");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<version>' + v + '</version>';
  }
  if (idVisible('repeating-enclosing-20-instance-1_6')) {
    var v = encodedValueById("item-20-instance-1_6");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<version>' + v + '</version>';
  }
  if (idVisible('repeating-enclosing-20-instance-1_7')) {
    var v = encodedValueById("item-20-instance-1_7");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<version>' + v + '</version>';
  }
  if (idVisible('repeating-enclosing-20-instance-1_8')) {
    var v = encodedValueById("item-20-instance-1_8");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<version>' + v + '</version>';
  }
  if (idVisible('repeating-enclosing-20-instance-1_9')) {
    var v = encodedValueById("item-20-instance-1_9");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<version>' + v + '</version>';
  }
  if (idVisible('repeating-enclosing-20-instance-1_10')) {
    var v = encodedValueById("item-20-instance-1_10");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<version>' + v + '</version>';
  }
   return xml;
  }

  //extract xml from element <publicationsAboutRelease>
  function getXml21instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-21-instance-1_1')) {
    var v = encodedValueById("item-21-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsAboutRelease>' + v + '</publicationsAboutRelease>';
  }
  if (idVisible('repeating-enclosing-21-instance-1_2')) {
    var v = encodedValueById("item-21-instance-1_2");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsAboutRelease>' + v + '</publicationsAboutRelease>';
  }
  if (idVisible('repeating-enclosing-21-instance-1_3')) {
    var v = encodedValueById("item-21-instance-1_3");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsAboutRelease>' + v + '</publicationsAboutRelease>';
  }
  if (idVisible('repeating-enclosing-21-instance-1_4')) {
    var v = encodedValueById("item-21-instance-1_4");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsAboutRelease>' + v + '</publicationsAboutRelease>';
  }
  if (idVisible('repeating-enclosing-21-instance-1_5')) {
    var v = encodedValueById("item-21-instance-1_5");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsAboutRelease>' + v + '</publicationsAboutRelease>';
  }
  if (idVisible('repeating-enclosing-21-instance-1_6')) {
    var v = encodedValueById("item-21-instance-1_6");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsAboutRelease>' + v + '</publicationsAboutRelease>';
  }
  if (idVisible('repeating-enclosing-21-instance-1_7')) {
    var v = encodedValueById("item-21-instance-1_7");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsAboutRelease>' + v + '</publicationsAboutRelease>';
  }
  if (idVisible('repeating-enclosing-21-instance-1_8')) {
    var v = encodedValueById("item-21-instance-1_8");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsAboutRelease>' + v + '</publicationsAboutRelease>';
  }
  if (idVisible('repeating-enclosing-21-instance-1_9')) {
    var v = encodedValueById("item-21-instance-1_9");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsAboutRelease>' + v + '</publicationsAboutRelease>';
  }
  if (idVisible('repeating-enclosing-21-instance-1_10')) {
    var v = encodedValueById("item-21-instance-1_10");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<publicationsAboutRelease>' + v + '</publicationsAboutRelease>';
  }
   return xml;
  }

  //extract xml from element <grants>
  function getXml22instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-22-instance-1_1')) {
    var v = encodedValueById("item-22-instance-1_1");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<grants>' + v + '</grants>';
  }
  if (idVisible('repeating-enclosing-22-instance-1_2')) {
    var v = encodedValueById("item-22-instance-1_2");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<grants>' + v + '</grants>';
  }
  if (idVisible('repeating-enclosing-22-instance-1_3')) {
    var v = encodedValueById("item-22-instance-1_3");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<grants>' + v + '</grants>';
  }
  if (idVisible('repeating-enclosing-22-instance-1_4')) {
    var v = encodedValueById("item-22-instance-1_4");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<grants>' + v + '</grants>';
  }
  if (idVisible('repeating-enclosing-22-instance-1_5')) {
    var v = encodedValueById("item-22-instance-1_5");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<grants>' + v + '</grants>';
  }
  if (idVisible('repeating-enclosing-22-instance-1_6')) {
    var v = encodedValueById("item-22-instance-1_6");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<grants>' + v + '</grants>';
  }
  if (idVisible('repeating-enclosing-22-instance-1_7')) {
    var v = encodedValueById("item-22-instance-1_7");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<grants>' + v + '</grants>';
  }
  if (idVisible('repeating-enclosing-22-instance-1_8')) {
    var v = encodedValueById("item-22-instance-1_8");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<grants>' + v + '</grants>';
  }
  if (idVisible('repeating-enclosing-22-instance-1_9')) {
    var v = encodedValueById("item-22-instance-1_9");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<grants>' + v + '</grants>';
  }
  if (idVisible('repeating-enclosing-22-instance-1_10')) {
    var v = encodedValueById("item-22-instance-1_10");
    if (v.length>0)
      xml += '\n' + spaces(2) + '<grants>' + v + '</grants>';
  }
   return xml;
  }

  //extract xml from element <availableOnOlympus>
  function getXml23instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-23-instance-1_1')) {
    var v = $('#item-23-instance-1_1').is(':checked');
    xml += '\n' + spaces(2) + '<availableOnOlympus>' + toBoolean(v) + '</availableOnOlympus>';
  }
   return xml;
  }

  //extract xml from element <availableOnUIDS>
  function getXml24instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-24-instance-1_1')) {
    var v = $('#item-24-instance-1_1').is(':checked');
    xml += '\n' + spaces(2) + '<availableOnUIDS>' + toBoolean(v) + '</availableOnUIDS>';
  }
   return xml;
  }

  //extract xml from element <signInRequired>
  function getXml25instance1() {

  var xml='';
  if (idVisible('repeating-enclosing-25-instance-1_1')) {
    var v = $('#item-25-instance-1_1').is(':checked');
    xml += '\n' + spaces(2) + '<signInRequired>' + toBoolean(v) + '</signInRequired>';
  }
   return xml;
  }

  //extract xml from element <MetagenomicAnalysis>
  function getXml1instance() {

    var xml = '\n' + spaces(0) + '<MetagenomicAnalysis xmlns="http://mdc.isg.pitt.edu/v1_0/">';
    //now add sequence children for each instanceNo
    if (idVisible('repeating-enclosing-1-instance-1')) {
      xml += getXml2instance1();
      xml += getXml3instance1();
      xml += getXml4instance1();
      xml += getXml5instance1();
      xml += getXml9instance1();
      xml += getXml10instance1();
      xml += getXml11instance1();
      xml += getXml12instance1();
      xml += getXml13instance1();
      xml += getXml14instance1();
      xml += getXml15instance1();
      xml += getXml16instance1();
      xml += getXml17instance1();
      xml += getXml18instance1();
      xml += getXml19instance1();
      xml += getXml20instance1();
      xml += getXml21instance1();
      xml += getXml22instance1();
      xml += getXml23instance1();
      xml += getXml24instance1();
      xml += getXml25instance1();
    }
    xml += '\n' + spaces(0) + '</MetagenomicAnalysis>';
    return xml;
  }


            $("#form").submit(function () { return false; }); // so it won't submit

            
            window.onbeforeunload = function() {
                var empty_inputs=0;
                $('.form :text').each(function(){
                    if( $.trim($(this).val()) != "" ) {
                        empty_inputs++;
                    }
                });

                if (empty_inputs>0) {
                    return "Are you sure you want to leave this page?";
                } else {
                    window.onbeforeunload = null;
                }
            };

            
            $.urlParam = function(name){
                var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
                if(results === null) {
                    return null;
                }
                return results[1] || null;
            };

            try {
                var entryId = $.urlParam("entryId");
                var revisionId = $.urlParam("revisionId");
                var requestUrl = "${pageContext.request.contextPath}" + "/add/item/" + entryId + "?revisionId=" + revisionId;
                $.getJSON(requestUrl, function(data) {
                   var entryData = data['entry'];
                   $("input").each(function( index ) {
                       var path = $(this).attr("path");
                       if(path != null) {
                           try {
                               var value = eval("entryData" + path);
                               if(value != null) {
                                   if($(this).attr("type") === "checkbox") {
                                       $(this).prop('checked', value);
                                   } else {
                                       $(this).val(value);
                                   }

                                   if($(this).is(":hidden")) {
                                       $(this).parents().show();
                                   }
                               }
                           } catch(err) {
                               // pass
                           }
                       }
                   });
                });
            } catch(err) {
                // pass
            }

            $(document).ready(function () {
                $('.category-div').clone().attr("id", "category-div").prependTo('.sequence-content:first');
                $('#category-div').show();

                $('#category-div').find(".item-input-text").change(function() {
                    $('#category-div').find('.item-error').hide();
                });

                var categoryId = $.urlParam("categoryId");
                console.log(categoryId);
                if(categoryId !== undefined && categoryId !== null) {
                    $('#category-div').find(".item-input-text").val(categoryId);
                }

                var xsdFormsPath = location.origin + "${pageContext.request.contextPath}" + "/resources/xsd-forms/";
                var addEntryPath = location.origin + "${pageContext.request.contextPath}" + "/add-entry";

                var formFrame = document.body,
                    formDocument = (formFrame.contentWindow || formFrame.contentDocument),
                    form;
                var form = document.getElementsByTagName("form")[0];
                XSD_FORM.makeReadable();

                document.getElementById("submit").classList.add("btn");
                document.getElementById("submit").classList.add("btn-default");
                document.getElementById("submit").onclick = function () {
                    $("#submit").addClass("disabled");
                    $("#submit-spinner").show();

                    var entryId = $.urlParam("entryId");
                    var revisionId = $.urlParam("revisionId");

                    var xmlString;

                    var hasCategory = true;
                    var categoryValue = $('#category-div').find(".item-input-text").val();
                    if(categoryValue == 'none' || categoryValue == null) {
                        hasCategory = false;
                        $('#category-div').find('.item-error').show();
                    }
                    if (document.getElementById("submit-comments").getElementsByTagName("pre")[0] && hasCategory) {
                        xmlString = document.getElementById("submit-comments").getElementsByTagName("pre")[0].textContent;
                        if (XSD_FORM.validate()) {
                            $.post(
                                addEntryPath + getQueryParamString(),
                                {'xmlString': xmlString,
                                'categoryValue': categoryValue,
                                'entryId': entryId,
                                'revisionId': revisionId},
                                function onSuccess(data, status, xhr) {
                                    console.info(data);
                                    console.info(status);
                                    console.info(xhr);
                                    alert("An email request has been sent to the administrator. Approval is pending.");
                                    $("#submit").removeClass("disabled");
                                    $("#submit-spinner").hide();
                                    window.location = "${pageContext.request.contextPath}/";
                                    return;
                                },
                                "json"
                            ).fail(function() {
                                alert("There was an error submitting your entry. Please refresh your page and try again.");
                                $("#submit").removeClass("disabled");
                                $("#submit-spinner").hide();
                            });
                        } else {
                            $("#submit").removeClass("disabled");
                            $("#submit-spinner").hide();
                        }
                    } else {
                        $("#submit").removeClass("disabled");
                        $("#submit-spinner").hide();
                    }
                    return;
                }
            });
        });
        function getQueryParamString() {
            if("${datasetType}" == "custom") {
                return "?datasetType=${datasetType}&customValue=${customValue}";
            }
            else if("${datasetType}" == "DiseaseSurveillanceData" || "${datasetType}" == "MortalityData") {
                return "?datasetType=${datasetType}";
            } else {
                return "";
            }
        }
    </script>

</head>
<myTags:header pageTitle="MIDAS Digital Commons" loggedIn="${loggedIn}" addEntry="true"></myTags:header>
<body>
<div class="form col-xs-12 margin-bottom-30">
    
    <div id="start"></div>
    <form method="POST" action="form.html" name="form">
        
  <div id="item-enclosing-1-instance-1" class="sequence">
    <div id="repeating-enclosing-1-instance-1" class="repeating-enclosing">
      <div class="sequence-label">Metagenomic Analysis</div>
      <div id="sequence-1-instance-1" class="sequence-content">
        <div id="item-enclosing-2-instance-1_1" class="item-enclosing">
          <div id="repeat-button-2-instance-1" class="btn btn-sm btn-default">Add Product Name</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-2-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-2-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">2</div>
            <label class="item-label" for="item-input-2-instance-1_1">Product Name</label>
            <div class="item-input">
              <input number="2" name="item-input-2-instance-1_1" path="['product']" id="item-2-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-2-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-2-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-3-instance-1_1" class="item-enclosing">
          <div id="repeating-enclosing-3-instance-1_1" class="repeating-enclosing">
            <div class="item-number">3</div>
            <label class="item-label" for="item-input-3-instance-1_1">Title</label>
            <div class="item-input">
              <input number="3" name="item-input-3-instance-1_1" path="['title']" id="item-3-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-3-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-3-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-4-instance-1_1" class="item-enclosing">
          <div id="repeating-enclosing-4-instance-1_1" class="repeating-enclosing">
            <div class="item-number">4</div>
            <label class="item-label" for="item-input-4-instance-1_1">Human Readable Synopsis</label>
            <div class="item-input">
              <input number="4" name="item-input-4-instance-1_1" path="['humanReadableSynopsis']" id="item-4-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-4-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-4-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-5-instance-1_1" class="sequence">
          <div class="min-occurs-zero-container invisible">
            <div class="min-occurs-zero-label">Click to enable</div>
            <input number="5" name="min-occurs-zero-name5-instance-1" checked="true" id="min-occurs-zero-5-instance-1" class="min-occurs-zero" type="checkbox">
            </input>
          </div>
          <div id="repeat-button-5-instance-1" class="btn btn-sm btn-default">Add Identifier</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-5-instance-1_1" class="repeating-enclosing invisible">
            <div class="sequence-label">Identifier</div>
            <div id="sequence-5-instance-1" class="sequence-content">
              <div class="remove-button-container">
                <div id="remove-button-5-instance-1_1" class="btn btn-xs btn-default">-</div>
              </div>
              <div id="item-enclosing-6-instance-1_1_1" class="item-enclosing">
                <div id="repeat-button-6-instance-1_1" class="btn btn-sm btn-default">Add Identifier</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-6-instance-1_1_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-6-instance-1_1_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">6</div>
                  <label class="item-label" for="item-input-6-instance-1_1_1">Identifier</label>
                  <div class="item-input">
                    <input number="6" name="item-input-6-instance-1_1_1" path="['identifier']['identifier']" id="item-6-instance-1_1_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-6-instance-1_1_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-6-instance-1_1_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-7-instance-1_1_1" class="item-enclosing">
                <div id="repeat-button-7-instance-1_1" class="btn btn-sm btn-default">Add Identifier Source</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-7-instance-1_1_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-7-instance-1_1_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">7</div>
                  <label class="item-label" for="item-input-7-instance-1_1_1">Identifier Source</label>
                  <div class="item-input">
                    <input number="7" name="item-input-7-instance-1_1_1" path="['identifier']['identifierSource']" id="item-7-instance-1_1_1" class=" item-input-text" type="text">
                    </input>
                    <div id="item-path-7-instance-1_1_1" class="item-path" enabled="true"></div>
                  </div>
                  <div class="clr">
                  </div>
                  <div id="item-error-7-instance-1_1_1" class="item-error">Invalid</div>
                </div>
              </div>
              <div id="item-enclosing-8-instance-1_1_1" class="item-enclosing">
                <div id="repeat-button-8-instance-1_1" class="btn btn-sm btn-default">Add Identifier Description</div>
                <div class="clr">
                </div>
                <div id="repeating-enclosing-8-instance-1_1_1" class="repeating-enclosing invisible">
                  <div class="remove-button-container">
                    <div id="remove-button-8-instance-1_1_1" class="btn btn-xs btn-default">-</div>
                  </div>
                  <div class="item-number">8</div>
                  <label class="item-label" for="item-input-8-instance-1_1_1">Identifier Description</label>
                  <div class="item-input">
                    <input number="8" name="item-input-8-instance-1_1_1" path="['identifier']['identifierDescription']" id="item-8-instance-1_1_1" class=" item-input-text" type="text">
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
        <div id="item-enclosing-9-instance-1_1" class="item-enclosing">
          <div id="repeat-button-9-instance-1" class="btn btn-sm btn-default">Add Data Input Format</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-9-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-9-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">9</div>
            <label class="item-label" for="item-input-9-instance-1_1">Data Input Format</label>
            <div class="item-input">
              <input number="9" name="item-input-9-instance-1_1" path="['dataInputFormats'][0]" id="item-9-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-9-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-9-instance-1_1" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-9-instance-1_2" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-9-instance-1_2" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">9</div>
            <label class="item-label" for="item-input-9-instance-1_2">Data Input Format</label>
            <div class="item-input">
              <input number="9" name="item-input-9-instance-1_2" path="['dataInputFormats'][1]" id="item-9-instance-1_2" class=" item-input-text" type="text">
              </input>
              <div id="item-path-9-instance-1_2" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-9-instance-1_2" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-9-instance-1_3" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-9-instance-1_3" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">9</div>
            <label class="item-label" for="item-input-9-instance-1_3">Data Input Format</label>
            <div class="item-input">
              <input number="9" name="item-input-9-instance-1_3" path="['dataInputFormats'][2]" id="item-9-instance-1_3" class=" item-input-text" type="text">
              </input>
              <div id="item-path-9-instance-1_3" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-9-instance-1_3" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-9-instance-1_4" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-9-instance-1_4" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">9</div>
            <label class="item-label" for="item-input-9-instance-1_4">Data Input Format</label>
            <div class="item-input">
              <input number="9" name="item-input-9-instance-1_4" path="['dataInputFormats'][3]" id="item-9-instance-1_4" class=" item-input-text" type="text">
              </input>
              <div id="item-path-9-instance-1_4" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-9-instance-1_4" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-9-instance-1_5" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-9-instance-1_5" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">9</div>
            <label class="item-label" for="item-input-9-instance-1_5">Data Input Format</label>
            <div class="item-input">
              <input number="9" name="item-input-9-instance-1_5" path="['dataInputFormats'][4]" id="item-9-instance-1_5" class=" item-input-text" type="text">
              </input>
              <div id="item-path-9-instance-1_5" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-9-instance-1_5" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-9-instance-1_6" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-9-instance-1_6" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">9</div>
            <label class="item-label" for="item-input-9-instance-1_6">Data Input Format</label>
            <div class="item-input">
              <input number="9" name="item-input-9-instance-1_6" path="['dataInputFormats'][5]" id="item-9-instance-1_6" class=" item-input-text" type="text">
              </input>
              <div id="item-path-9-instance-1_6" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-9-instance-1_6" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-9-instance-1_7" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-9-instance-1_7" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">9</div>
            <label class="item-label" for="item-input-9-instance-1_7">Data Input Format</label>
            <div class="item-input">
              <input number="9" name="item-input-9-instance-1_7" path="['dataInputFormats'][6]" id="item-9-instance-1_7" class=" item-input-text" type="text">
              </input>
              <div id="item-path-9-instance-1_7" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-9-instance-1_7" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-9-instance-1_8" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-9-instance-1_8" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">9</div>
            <label class="item-label" for="item-input-9-instance-1_8">Data Input Format</label>
            <div class="item-input">
              <input number="9" name="item-input-9-instance-1_8" path="['dataInputFormats'][7]" id="item-9-instance-1_8" class=" item-input-text" type="text">
              </input>
              <div id="item-path-9-instance-1_8" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-9-instance-1_8" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-9-instance-1_9" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-9-instance-1_9" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">9</div>
            <label class="item-label" for="item-input-9-instance-1_9">Data Input Format</label>
            <div class="item-input">
              <input number="9" name="item-input-9-instance-1_9" path="['dataInputFormats'][8]" id="item-9-instance-1_9" class=" item-input-text" type="text">
              </input>
              <div id="item-path-9-instance-1_9" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-9-instance-1_9" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-9-instance-1_10" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-9-instance-1_10" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">9</div>
            <label class="item-label" for="item-input-9-instance-1_10">Data Input Format</label>
            <div class="item-input">
              <input number="9" name="item-input-9-instance-1_10" path="['dataInputFormats'][9]" id="item-9-instance-1_10" class=" item-input-text" type="text">
              </input>
              <div id="item-path-9-instance-1_10" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-9-instance-1_10" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-10-instance-1_1" class="item-enclosing">
          <div id="repeat-button-10-instance-1" class="btn btn-sm btn-default">Add Data Output Format</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-10-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-10-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">10</div>
            <label class="item-label" for="item-input-10-instance-1_1">Data Output Format</label>
            <div class="item-input">
              <input number="10" name="item-input-10-instance-1_1" path="['dataOutputFormats'][0]" id="item-10-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-10-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-10-instance-1_1" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-10-instance-1_2" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-10-instance-1_2" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">10</div>
            <label class="item-label" for="item-input-10-instance-1_2">Data Output Format</label>
            <div class="item-input">
              <input number="10" name="item-input-10-instance-1_2" path="['dataOutputFormats'][1]" id="item-10-instance-1_2" class=" item-input-text" type="text">
              </input>
              <div id="item-path-10-instance-1_2" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-10-instance-1_2" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-10-instance-1_3" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-10-instance-1_3" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">10</div>
            <label class="item-label" for="item-input-10-instance-1_3">Data Output Format</label>
            <div class="item-input">
              <input number="10" name="item-input-10-instance-1_3" path="['dataOutputFormats'][2]" id="item-10-instance-1_3" class=" item-input-text" type="text">
              </input>
              <div id="item-path-10-instance-1_3" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-10-instance-1_3" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-10-instance-1_4" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-10-instance-1_4" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">10</div>
            <label class="item-label" for="item-input-10-instance-1_4">Data Output Format</label>
            <div class="item-input">
              <input number="10" name="item-input-10-instance-1_4" path="['dataOutputFormats'][3]" id="item-10-instance-1_4" class=" item-input-text" type="text">
              </input>
              <div id="item-path-10-instance-1_4" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-10-instance-1_4" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-10-instance-1_5" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-10-instance-1_5" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">10</div>
            <label class="item-label" for="item-input-10-instance-1_5">Data Output Format</label>
            <div class="item-input">
              <input number="10" name="item-input-10-instance-1_5" path="['dataOutputFormats'][4]" id="item-10-instance-1_5" class=" item-input-text" type="text">
              </input>
              <div id="item-path-10-instance-1_5" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-10-instance-1_5" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-10-instance-1_6" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-10-instance-1_6" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">10</div>
            <label class="item-label" for="item-input-10-instance-1_6">Data Output Format</label>
            <div class="item-input">
              <input number="10" name="item-input-10-instance-1_6" path="['dataOutputFormats'][5]" id="item-10-instance-1_6" class=" item-input-text" type="text">
              </input>
              <div id="item-path-10-instance-1_6" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-10-instance-1_6" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-10-instance-1_7" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-10-instance-1_7" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">10</div>
            <label class="item-label" for="item-input-10-instance-1_7">Data Output Format</label>
            <div class="item-input">
              <input number="10" name="item-input-10-instance-1_7" path="['dataOutputFormats'][6]" id="item-10-instance-1_7" class=" item-input-text" type="text">
              </input>
              <div id="item-path-10-instance-1_7" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-10-instance-1_7" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-10-instance-1_8" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-10-instance-1_8" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">10</div>
            <label class="item-label" for="item-input-10-instance-1_8">Data Output Format</label>
            <div class="item-input">
              <input number="10" name="item-input-10-instance-1_8" path="['dataOutputFormats'][7]" id="item-10-instance-1_8" class=" item-input-text" type="text">
              </input>
              <div id="item-path-10-instance-1_8" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-10-instance-1_8" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-10-instance-1_9" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-10-instance-1_9" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">10</div>
            <label class="item-label" for="item-input-10-instance-1_9">Data Output Format</label>
            <div class="item-input">
              <input number="10" name="item-input-10-instance-1_9" path="['dataOutputFormats'][8]" id="item-10-instance-1_9" class=" item-input-text" type="text">
              </input>
              <div id="item-path-10-instance-1_9" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-10-instance-1_9" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-10-instance-1_10" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-10-instance-1_10" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">10</div>
            <label class="item-label" for="item-input-10-instance-1_10">Data Output Format</label>
            <div class="item-input">
              <input number="10" name="item-input-10-instance-1_10" path="['dataOutputFormats'][9]" id="item-10-instance-1_10" class=" item-input-text" type="text">
              </input>
              <div id="item-path-10-instance-1_10" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-10-instance-1_10" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-11-instance-1_1" class="item-enclosing">
          <div id="repeat-button-11-instance-1" class="btn btn-sm btn-default">Add Source Code Release</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-11-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-11-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">11</div>
            <label class="item-label" for="item-input-11-instance-1_1">Source Code Release</label>
            <div class="item-input">
              <input number="11" name="item-input-11-instance-1_1" path="['sourceCodeRelease']" id="item-11-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-11-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-11-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-12-instance-1_1" class="item-enclosing">
          <div id="repeat-button-12-instance-1" class="btn btn-sm btn-default">Add Web Application</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-12-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-12-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">12</div>
            <label class="item-label" for="item-input-12-instance-1_1">Web Application</label>
            <div class="item-input">
              <input number="12" name="item-input-12-instance-1_1" path="['webApplication'][0]" id="item-12-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-12-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-12-instance-1_1" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-12-instance-1_2" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-12-instance-1_2" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">12</div>
            <label class="item-label" for="item-input-12-instance-1_2">Web Application</label>
            <div class="item-input">
              <input number="12" name="item-input-12-instance-1_2" path="['webApplication'][1]" id="item-12-instance-1_2" class=" item-input-text" type="text">
              </input>
              <div id="item-path-12-instance-1_2" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-12-instance-1_2" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-12-instance-1_3" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-12-instance-1_3" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">12</div>
            <label class="item-label" for="item-input-12-instance-1_3">Web Application</label>
            <div class="item-input">
              <input number="12" name="item-input-12-instance-1_3" path="['webApplication'][2]" id="item-12-instance-1_3" class=" item-input-text" type="text">
              </input>
              <div id="item-path-12-instance-1_3" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-12-instance-1_3" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-12-instance-1_4" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-12-instance-1_4" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">12</div>
            <label class="item-label" for="item-input-12-instance-1_4">Web Application</label>
            <div class="item-input">
              <input number="12" name="item-input-12-instance-1_4" path="['webApplication'][3]" id="item-12-instance-1_4" class=" item-input-text" type="text">
              </input>
              <div id="item-path-12-instance-1_4" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-12-instance-1_4" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-12-instance-1_5" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-12-instance-1_5" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">12</div>
            <label class="item-label" for="item-input-12-instance-1_5">Web Application</label>
            <div class="item-input">
              <input number="12" name="item-input-12-instance-1_5" path="['webApplication'][4]" id="item-12-instance-1_5" class=" item-input-text" type="text">
              </input>
              <div id="item-path-12-instance-1_5" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-12-instance-1_5" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-12-instance-1_6" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-12-instance-1_6" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">12</div>
            <label class="item-label" for="item-input-12-instance-1_6">Web Application</label>
            <div class="item-input">
              <input number="12" name="item-input-12-instance-1_6" path="['webApplication'][5]" id="item-12-instance-1_6" class=" item-input-text" type="text">
              </input>
              <div id="item-path-12-instance-1_6" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-12-instance-1_6" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-12-instance-1_7" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-12-instance-1_7" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">12</div>
            <label class="item-label" for="item-input-12-instance-1_7">Web Application</label>
            <div class="item-input">
              <input number="12" name="item-input-12-instance-1_7" path="['webApplication'][6]" id="item-12-instance-1_7" class=" item-input-text" type="text">
              </input>
              <div id="item-path-12-instance-1_7" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-12-instance-1_7" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-12-instance-1_8" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-12-instance-1_8" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">12</div>
            <label class="item-label" for="item-input-12-instance-1_8">Web Application</label>
            <div class="item-input">
              <input number="12" name="item-input-12-instance-1_8" path="['webApplication'][7]" id="item-12-instance-1_8" class=" item-input-text" type="text">
              </input>
              <div id="item-path-12-instance-1_8" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-12-instance-1_8" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-12-instance-1_9" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-12-instance-1_9" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">12</div>
            <label class="item-label" for="item-input-12-instance-1_9">Web Application</label>
            <div class="item-input">
              <input number="12" name="item-input-12-instance-1_9" path="['webApplication'][8]" id="item-12-instance-1_9" class=" item-input-text" type="text">
              </input>
              <div id="item-path-12-instance-1_9" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-12-instance-1_9" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-12-instance-1_10" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-12-instance-1_10" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">12</div>
            <label class="item-label" for="item-input-12-instance-1_10">Web Application</label>
            <div class="item-input">
              <input number="12" name="item-input-12-instance-1_10" path="['webApplication'][9]" id="item-12-instance-1_10" class=" item-input-text" type="text">
              </input>
              <div id="item-path-12-instance-1_10" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-12-instance-1_10" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-13-instance-1_1" class="item-enclosing">
          <div id="repeat-button-13-instance-1" class="btn btn-sm btn-default">Add License</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-13-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-13-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">13</div>
            <label class="item-label" for="item-input-13-instance-1_1">License</label>
            <div class="item-input">
              <input number="13" name="item-input-13-instance-1_1" path="['license']" id="item-13-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-13-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-13-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-14-instance-1_1" class="item-enclosing">
          <div id="repeat-button-14-instance-1" class="btn btn-sm btn-default">Add Source</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-14-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-14-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">14</div>
            <label class="item-label" for="item-input-14-instance-1_1">Source</label>
            <div class="item-input">
              <input number="14" name="item-input-14-instance-1_1" path="['source']" id="item-14-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-14-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-14-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-15-instance-1_1" class="item-enclosing">
          <div id="repeat-button-15-instance-1" class="btn btn-sm btn-default">Add Developer</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-15-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-15-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">15</div>
            <label class="item-label" for="item-input-15-instance-1_1">Developer</label>
            <div class="item-input">
              <input number="15" name="item-input-15-instance-1_1" path="['developers'][0]" id="item-15-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-15-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-15-instance-1_1" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-15-instance-1_2" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-15-instance-1_2" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">15</div>
            <label class="item-label" for="item-input-15-instance-1_2">Developer</label>
            <div class="item-input">
              <input number="15" name="item-input-15-instance-1_2" path="['developers'][1]" id="item-15-instance-1_2" class=" item-input-text" type="text">
              </input>
              <div id="item-path-15-instance-1_2" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-15-instance-1_2" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-15-instance-1_3" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-15-instance-1_3" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">15</div>
            <label class="item-label" for="item-input-15-instance-1_3">Developer</label>
            <div class="item-input">
              <input number="15" name="item-input-15-instance-1_3" path="['developers'][2]" id="item-15-instance-1_3" class=" item-input-text" type="text">
              </input>
              <div id="item-path-15-instance-1_3" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-15-instance-1_3" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-15-instance-1_4" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-15-instance-1_4" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">15</div>
            <label class="item-label" for="item-input-15-instance-1_4">Developer</label>
            <div class="item-input">
              <input number="15" name="item-input-15-instance-1_4" path="['developers'][3]" id="item-15-instance-1_4" class=" item-input-text" type="text">
              </input>
              <div id="item-path-15-instance-1_4" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-15-instance-1_4" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-15-instance-1_5" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-15-instance-1_5" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">15</div>
            <label class="item-label" for="item-input-15-instance-1_5">Developer</label>
            <div class="item-input">
              <input number="15" name="item-input-15-instance-1_5" path="['developers'][4]" id="item-15-instance-1_5" class=" item-input-text" type="text">
              </input>
              <div id="item-path-15-instance-1_5" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-15-instance-1_5" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-15-instance-1_6" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-15-instance-1_6" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">15</div>
            <label class="item-label" for="item-input-15-instance-1_6">Developer</label>
            <div class="item-input">
              <input number="15" name="item-input-15-instance-1_6" path="['developers'][5]" id="item-15-instance-1_6" class=" item-input-text" type="text">
              </input>
              <div id="item-path-15-instance-1_6" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-15-instance-1_6" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-15-instance-1_7" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-15-instance-1_7" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">15</div>
            <label class="item-label" for="item-input-15-instance-1_7">Developer</label>
            <div class="item-input">
              <input number="15" name="item-input-15-instance-1_7" path="['developers'][6]" id="item-15-instance-1_7" class=" item-input-text" type="text">
              </input>
              <div id="item-path-15-instance-1_7" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-15-instance-1_7" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-15-instance-1_8" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-15-instance-1_8" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">15</div>
            <label class="item-label" for="item-input-15-instance-1_8">Developer</label>
            <div class="item-input">
              <input number="15" name="item-input-15-instance-1_8" path="['developers'][7]" id="item-15-instance-1_8" class=" item-input-text" type="text">
              </input>
              <div id="item-path-15-instance-1_8" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-15-instance-1_8" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-15-instance-1_9" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-15-instance-1_9" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">15</div>
            <label class="item-label" for="item-input-15-instance-1_9">Developer</label>
            <div class="item-input">
              <input number="15" name="item-input-15-instance-1_9" path="['developers'][8]" id="item-15-instance-1_9" class=" item-input-text" type="text">
              </input>
              <div id="item-path-15-instance-1_9" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-15-instance-1_9" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-15-instance-1_10" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-15-instance-1_10" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">15</div>
            <label class="item-label" for="item-input-15-instance-1_10">Developer</label>
            <div class="item-input">
              <input number="15" name="item-input-15-instance-1_10" path="['developers'][9]" id="item-15-instance-1_10" class=" item-input-text" type="text">
              </input>
              <div id="item-path-15-instance-1_10" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-15-instance-1_10" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-16-instance-1_1" class="item-enclosing">
          <div id="repeat-button-16-instance-1" class="btn btn-sm btn-default">Add Website</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-16-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-16-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">16</div>
            <label class="item-label" for="item-input-16-instance-1_1">Website</label>
            <div class="item-input">
              <input number="16" name="item-input-16-instance-1_1" path="['website']" id="item-16-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-16-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-16-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-17-instance-1_1" class="item-enclosing">
          <div id="repeat-button-17-instance-1" class="btn btn-sm btn-default">Add Documentation</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-17-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-17-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">17</div>
            <label class="item-label" for="item-input-17-instance-1_1">Documentation</label>
            <div class="item-input">
              <input number="17" name="item-input-17-instance-1_1" path="['documentation']" id="item-17-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-17-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-17-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-18-instance-1_1" class="item-enclosing">
          <div id="repeat-button-18-instance-1" class="btn btn-sm btn-default">Add Publication That Used Release</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-18-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-18-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">18</div>
            <label class="item-label" for="item-input-18-instance-1_1">Publication That Used Release</label>
            <div class="item-input">
              <input number="18" name="item-input-18-instance-1_1" path="['publicationsThatUsedRelease'][0]" id="item-18-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-18-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-18-instance-1_1" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-18-instance-1_2" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-18-instance-1_2" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">18</div>
            <label class="item-label" for="item-input-18-instance-1_2">Publication That Used Release</label>
            <div class="item-input">
              <input number="18" name="item-input-18-instance-1_2" path="['publicationsThatUsedRelease'][1]" id="item-18-instance-1_2" class=" item-input-text" type="text">
              </input>
              <div id="item-path-18-instance-1_2" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-18-instance-1_2" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-18-instance-1_3" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-18-instance-1_3" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">18</div>
            <label class="item-label" for="item-input-18-instance-1_3">Publication That Used Release</label>
            <div class="item-input">
              <input number="18" name="item-input-18-instance-1_3" path="['publicationsThatUsedRelease'][2]" id="item-18-instance-1_3" class=" item-input-text" type="text">
              </input>
              <div id="item-path-18-instance-1_3" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-18-instance-1_3" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-18-instance-1_4" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-18-instance-1_4" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">18</div>
            <label class="item-label" for="item-input-18-instance-1_4">Publication That Used Release</label>
            <div class="item-input">
              <input number="18" name="item-input-18-instance-1_4" path="['publicationsThatUsedRelease'][3]" id="item-18-instance-1_4" class=" item-input-text" type="text">
              </input>
              <div id="item-path-18-instance-1_4" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-18-instance-1_4" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-18-instance-1_5" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-18-instance-1_5" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">18</div>
            <label class="item-label" for="item-input-18-instance-1_5">Publication That Used Release</label>
            <div class="item-input">
              <input number="18" name="item-input-18-instance-1_5" path="['publicationsThatUsedRelease'][4]" id="item-18-instance-1_5" class=" item-input-text" type="text">
              </input>
              <div id="item-path-18-instance-1_5" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-18-instance-1_5" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-18-instance-1_6" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-18-instance-1_6" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">18</div>
            <label class="item-label" for="item-input-18-instance-1_6">Publication That Used Release</label>
            <div class="item-input">
              <input number="18" name="item-input-18-instance-1_6" path="['publicationsThatUsedRelease'][5]" id="item-18-instance-1_6" class=" item-input-text" type="text">
              </input>
              <div id="item-path-18-instance-1_6" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-18-instance-1_6" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-18-instance-1_7" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-18-instance-1_7" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">18</div>
            <label class="item-label" for="item-input-18-instance-1_7">Publication That Used Release</label>
            <div class="item-input">
              <input number="18" name="item-input-18-instance-1_7" path="['publicationsThatUsedRelease'][6]" id="item-18-instance-1_7" class=" item-input-text" type="text">
              </input>
              <div id="item-path-18-instance-1_7" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-18-instance-1_7" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-18-instance-1_8" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-18-instance-1_8" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">18</div>
            <label class="item-label" for="item-input-18-instance-1_8">Publication That Used Release</label>
            <div class="item-input">
              <input number="18" name="item-input-18-instance-1_8" path="['publicationsThatUsedRelease'][7]" id="item-18-instance-1_8" class=" item-input-text" type="text">
              </input>
              <div id="item-path-18-instance-1_8" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-18-instance-1_8" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-18-instance-1_9" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-18-instance-1_9" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">18</div>
            <label class="item-label" for="item-input-18-instance-1_9">Publication That Used Release</label>
            <div class="item-input">
              <input number="18" name="item-input-18-instance-1_9" path="['publicationsThatUsedRelease'][8]" id="item-18-instance-1_9" class=" item-input-text" type="text">
              </input>
              <div id="item-path-18-instance-1_9" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-18-instance-1_9" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-18-instance-1_10" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-18-instance-1_10" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">18</div>
            <label class="item-label" for="item-input-18-instance-1_10">Publication That Used Release</label>
            <div class="item-input">
              <input number="18" name="item-input-18-instance-1_10" path="['publicationsThatUsedRelease'][9]" id="item-18-instance-1_10" class=" item-input-text" type="text">
              </input>
              <div id="item-path-18-instance-1_10" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-18-instance-1_10" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-19-instance-1_1" class="item-enclosing">
          <div id="repeat-button-19-instance-1" class="btn btn-sm btn-default">Add Executable</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-19-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-19-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">19</div>
            <label class="item-label" for="item-input-19-instance-1_1">Executable</label>
            <div class="item-input">
              <input number="19" name="item-input-19-instance-1_1" path="['executables'][0]" id="item-19-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-19-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-19-instance-1_1" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-19-instance-1_2" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-19-instance-1_2" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">19</div>
            <label class="item-label" for="item-input-19-instance-1_2">Executable</label>
            <div class="item-input">
              <input number="19" name="item-input-19-instance-1_2" path="['executables'][1]" id="item-19-instance-1_2" class=" item-input-text" type="text">
              </input>
              <div id="item-path-19-instance-1_2" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-19-instance-1_2" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-19-instance-1_3" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-19-instance-1_3" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">19</div>
            <label class="item-label" for="item-input-19-instance-1_3">Executable</label>
            <div class="item-input">
              <input number="19" name="item-input-19-instance-1_3" path="['executables'][2]" id="item-19-instance-1_3" class=" item-input-text" type="text">
              </input>
              <div id="item-path-19-instance-1_3" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-19-instance-1_3" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-19-instance-1_4" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-19-instance-1_4" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">19</div>
            <label class="item-label" for="item-input-19-instance-1_4">Executable</label>
            <div class="item-input">
              <input number="19" name="item-input-19-instance-1_4" path="['executables'][3]" id="item-19-instance-1_4" class=" item-input-text" type="text">
              </input>
              <div id="item-path-19-instance-1_4" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-19-instance-1_4" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-19-instance-1_5" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-19-instance-1_5" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">19</div>
            <label class="item-label" for="item-input-19-instance-1_5">Executable</label>
            <div class="item-input">
              <input number="19" name="item-input-19-instance-1_5" path="['executables'][4]" id="item-19-instance-1_5" class=" item-input-text" type="text">
              </input>
              <div id="item-path-19-instance-1_5" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-19-instance-1_5" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-19-instance-1_6" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-19-instance-1_6" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">19</div>
            <label class="item-label" for="item-input-19-instance-1_6">Executable</label>
            <div class="item-input">
              <input number="19" name="item-input-19-instance-1_6" path="['executables'][5]" id="item-19-instance-1_6" class=" item-input-text" type="text">
              </input>
              <div id="item-path-19-instance-1_6" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-19-instance-1_6" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-19-instance-1_7" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-19-instance-1_7" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">19</div>
            <label class="item-label" for="item-input-19-instance-1_7">Executable</label>
            <div class="item-input">
              <input number="19" name="item-input-19-instance-1_7" path="['executables'][6]" id="item-19-instance-1_7" class=" item-input-text" type="text">
              </input>
              <div id="item-path-19-instance-1_7" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-19-instance-1_7" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-19-instance-1_8" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-19-instance-1_8" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">19</div>
            <label class="item-label" for="item-input-19-instance-1_8">Executable</label>
            <div class="item-input">
              <input number="19" name="item-input-19-instance-1_8" path="['executables'][7]" id="item-19-instance-1_8" class=" item-input-text" type="text">
              </input>
              <div id="item-path-19-instance-1_8" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-19-instance-1_8" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-19-instance-1_9" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-19-instance-1_9" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">19</div>
            <label class="item-label" for="item-input-19-instance-1_9">Executable</label>
            <div class="item-input">
              <input number="19" name="item-input-19-instance-1_9" path="['executables'][8]" id="item-19-instance-1_9" class=" item-input-text" type="text">
              </input>
              <div id="item-path-19-instance-1_9" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-19-instance-1_9" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-19-instance-1_10" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-19-instance-1_10" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">19</div>
            <label class="item-label" for="item-input-19-instance-1_10">Executable</label>
            <div class="item-input">
              <input number="19" name="item-input-19-instance-1_10" path="['executables'][9]" id="item-19-instance-1_10" class=" item-input-text" type="text">
              </input>
              <div id="item-path-19-instance-1_10" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-19-instance-1_10" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-20-instance-1_1" class="item-enclosing">
          <div id="repeat-button-20-instance-1" class="btn btn-sm btn-default">Add Version</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-20-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-20-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">20</div>
            <label class="item-label" for="item-input-20-instance-1_1">Version</label>
            <div class="item-input">
              <input number="20" name="item-input-20-instance-1_1" path="['version'][0]" id="item-20-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-20-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-20-instance-1_1" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-20-instance-1_2" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-20-instance-1_2" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">20</div>
            <label class="item-label" for="item-input-20-instance-1_2">Version</label>
            <div class="item-input">
              <input number="20" name="item-input-20-instance-1_2" path="['version'][1]" id="item-20-instance-1_2" class=" item-input-text" type="text">
              </input>
              <div id="item-path-20-instance-1_2" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-20-instance-1_2" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-20-instance-1_3" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-20-instance-1_3" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">20</div>
            <label class="item-label" for="item-input-20-instance-1_3">Version</label>
            <div class="item-input">
              <input number="20" name="item-input-20-instance-1_3" path="['version'][2]" id="item-20-instance-1_3" class=" item-input-text" type="text">
              </input>
              <div id="item-path-20-instance-1_3" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-20-instance-1_3" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-20-instance-1_4" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-20-instance-1_4" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">20</div>
            <label class="item-label" for="item-input-20-instance-1_4">Version</label>
            <div class="item-input">
              <input number="20" name="item-input-20-instance-1_4" path="['version'][3]" id="item-20-instance-1_4" class=" item-input-text" type="text">
              </input>
              <div id="item-path-20-instance-1_4" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-20-instance-1_4" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-20-instance-1_5" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-20-instance-1_5" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">20</div>
            <label class="item-label" for="item-input-20-instance-1_5">Version</label>
            <div class="item-input">
              <input number="20" name="item-input-20-instance-1_5" path="['version'][4]" id="item-20-instance-1_5" class=" item-input-text" type="text">
              </input>
              <div id="item-path-20-instance-1_5" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-20-instance-1_5" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-20-instance-1_6" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-20-instance-1_6" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">20</div>
            <label class="item-label" for="item-input-20-instance-1_6">Version</label>
            <div class="item-input">
              <input number="20" name="item-input-20-instance-1_6" path="['version'][5]" id="item-20-instance-1_6" class=" item-input-text" type="text">
              </input>
              <div id="item-path-20-instance-1_6" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-20-instance-1_6" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-20-instance-1_7" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-20-instance-1_7" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">20</div>
            <label class="item-label" for="item-input-20-instance-1_7">Version</label>
            <div class="item-input">
              <input number="20" name="item-input-20-instance-1_7" path="['version'][6]" id="item-20-instance-1_7" class=" item-input-text" type="text">
              </input>
              <div id="item-path-20-instance-1_7" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-20-instance-1_7" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-20-instance-1_8" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-20-instance-1_8" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">20</div>
            <label class="item-label" for="item-input-20-instance-1_8">Version</label>
            <div class="item-input">
              <input number="20" name="item-input-20-instance-1_8" path="['version'][7]" id="item-20-instance-1_8" class=" item-input-text" type="text">
              </input>
              <div id="item-path-20-instance-1_8" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-20-instance-1_8" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-20-instance-1_9" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-20-instance-1_9" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">20</div>
            <label class="item-label" for="item-input-20-instance-1_9">Version</label>
            <div class="item-input">
              <input number="20" name="item-input-20-instance-1_9" path="['version'][8]" id="item-20-instance-1_9" class=" item-input-text" type="text">
              </input>
              <div id="item-path-20-instance-1_9" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-20-instance-1_9" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-20-instance-1_10" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-20-instance-1_10" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">20</div>
            <label class="item-label" for="item-input-20-instance-1_10">Version</label>
            <div class="item-input">
              <input number="20" name="item-input-20-instance-1_10" path="['version'][9]" id="item-20-instance-1_10" class=" item-input-text" type="text">
              </input>
              <div id="item-path-20-instance-1_10" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-20-instance-1_10" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-21-instance-1_1" class="item-enclosing">
          <div id="repeat-button-21-instance-1" class="btn btn-sm btn-default">Add Publication About Release</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-21-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-21-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">21</div>
            <label class="item-label" for="item-input-21-instance-1_1">Publication About Release</label>
            <div class="item-input">
              <input number="21" name="item-input-21-instance-1_1" path="['publicationsAboutRelease'][0]" id="item-21-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-21-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-21-instance-1_1" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-21-instance-1_2" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-21-instance-1_2" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">21</div>
            <label class="item-label" for="item-input-21-instance-1_2">Publication About Release</label>
            <div class="item-input">
              <input number="21" name="item-input-21-instance-1_2" path="['publicationsAboutRelease'][1]" id="item-21-instance-1_2" class=" item-input-text" type="text">
              </input>
              <div id="item-path-21-instance-1_2" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-21-instance-1_2" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-21-instance-1_3" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-21-instance-1_3" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">21</div>
            <label class="item-label" for="item-input-21-instance-1_3">Publication About Release</label>
            <div class="item-input">
              <input number="21" name="item-input-21-instance-1_3" path="['publicationsAboutRelease'][2]" id="item-21-instance-1_3" class=" item-input-text" type="text">
              </input>
              <div id="item-path-21-instance-1_3" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-21-instance-1_3" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-21-instance-1_4" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-21-instance-1_4" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">21</div>
            <label class="item-label" for="item-input-21-instance-1_4">Publication About Release</label>
            <div class="item-input">
              <input number="21" name="item-input-21-instance-1_4" path="['publicationsAboutRelease'][3]" id="item-21-instance-1_4" class=" item-input-text" type="text">
              </input>
              <div id="item-path-21-instance-1_4" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-21-instance-1_4" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-21-instance-1_5" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-21-instance-1_5" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">21</div>
            <label class="item-label" for="item-input-21-instance-1_5">Publication About Release</label>
            <div class="item-input">
              <input number="21" name="item-input-21-instance-1_5" path="['publicationsAboutRelease'][4]" id="item-21-instance-1_5" class=" item-input-text" type="text">
              </input>
              <div id="item-path-21-instance-1_5" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-21-instance-1_5" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-21-instance-1_6" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-21-instance-1_6" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">21</div>
            <label class="item-label" for="item-input-21-instance-1_6">Publication About Release</label>
            <div class="item-input">
              <input number="21" name="item-input-21-instance-1_6" path="['publicationsAboutRelease'][5]" id="item-21-instance-1_6" class=" item-input-text" type="text">
              </input>
              <div id="item-path-21-instance-1_6" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-21-instance-1_6" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-21-instance-1_7" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-21-instance-1_7" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">21</div>
            <label class="item-label" for="item-input-21-instance-1_7">Publication About Release</label>
            <div class="item-input">
              <input number="21" name="item-input-21-instance-1_7" path="['publicationsAboutRelease'][6]" id="item-21-instance-1_7" class=" item-input-text" type="text">
              </input>
              <div id="item-path-21-instance-1_7" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-21-instance-1_7" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-21-instance-1_8" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-21-instance-1_8" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">21</div>
            <label class="item-label" for="item-input-21-instance-1_8">Publication About Release</label>
            <div class="item-input">
              <input number="21" name="item-input-21-instance-1_8" path="['publicationsAboutRelease'][7]" id="item-21-instance-1_8" class=" item-input-text" type="text">
              </input>
              <div id="item-path-21-instance-1_8" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-21-instance-1_8" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-21-instance-1_9" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-21-instance-1_9" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">21</div>
            <label class="item-label" for="item-input-21-instance-1_9">Publication About Release</label>
            <div class="item-input">
              <input number="21" name="item-input-21-instance-1_9" path="['publicationsAboutRelease'][8]" id="item-21-instance-1_9" class=" item-input-text" type="text">
              </input>
              <div id="item-path-21-instance-1_9" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-21-instance-1_9" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-21-instance-1_10" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-21-instance-1_10" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">21</div>
            <label class="item-label" for="item-input-21-instance-1_10">Publication About Release</label>
            <div class="item-input">
              <input number="21" name="item-input-21-instance-1_10" path="['publicationsAboutRelease'][9]" id="item-21-instance-1_10" class=" item-input-text" type="text">
              </input>
              <div id="item-path-21-instance-1_10" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-21-instance-1_10" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-22-instance-1_1" class="item-enclosing">
          <div id="repeat-button-22-instance-1" class="btn btn-sm btn-default">Add Grant</div>
          <div class="clr">
          </div>
          <div id="repeating-enclosing-22-instance-1_1" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-22-instance-1_1" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">22</div>
            <label class="item-label" for="item-input-22-instance-1_1">Grant</label>
            <div class="item-input">
              <input number="22" name="item-input-22-instance-1_1" path="['grants'][0]" id="item-22-instance-1_1" class=" item-input-text" type="text">
              </input>
              <div id="item-path-22-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-22-instance-1_1" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-22-instance-1_2" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-22-instance-1_2" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">22</div>
            <label class="item-label" for="item-input-22-instance-1_2">Grant</label>
            <div class="item-input">
              <input number="22" name="item-input-22-instance-1_2" path="['grants'][1]" id="item-22-instance-1_2" class=" item-input-text" type="text">
              </input>
              <div id="item-path-22-instance-1_2" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-22-instance-1_2" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-22-instance-1_3" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-22-instance-1_3" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">22</div>
            <label class="item-label" for="item-input-22-instance-1_3">Grant</label>
            <div class="item-input">
              <input number="22" name="item-input-22-instance-1_3" path="['grants'][2]" id="item-22-instance-1_3" class=" item-input-text" type="text">
              </input>
              <div id="item-path-22-instance-1_3" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-22-instance-1_3" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-22-instance-1_4" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-22-instance-1_4" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">22</div>
            <label class="item-label" for="item-input-22-instance-1_4">Grant</label>
            <div class="item-input">
              <input number="22" name="item-input-22-instance-1_4" path="['grants'][3]" id="item-22-instance-1_4" class=" item-input-text" type="text">
              </input>
              <div id="item-path-22-instance-1_4" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-22-instance-1_4" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-22-instance-1_5" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-22-instance-1_5" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">22</div>
            <label class="item-label" for="item-input-22-instance-1_5">Grant</label>
            <div class="item-input">
              <input number="22" name="item-input-22-instance-1_5" path="['grants'][4]" id="item-22-instance-1_5" class=" item-input-text" type="text">
              </input>
              <div id="item-path-22-instance-1_5" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-22-instance-1_5" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-22-instance-1_6" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-22-instance-1_6" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">22</div>
            <label class="item-label" for="item-input-22-instance-1_6">Grant</label>
            <div class="item-input">
              <input number="22" name="item-input-22-instance-1_6" path="['grants'][5]" id="item-22-instance-1_6" class=" item-input-text" type="text">
              </input>
              <div id="item-path-22-instance-1_6" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-22-instance-1_6" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-22-instance-1_7" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-22-instance-1_7" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">22</div>
            <label class="item-label" for="item-input-22-instance-1_7">Grant</label>
            <div class="item-input">
              <input number="22" name="item-input-22-instance-1_7" path="['grants'][6]" id="item-22-instance-1_7" class=" item-input-text" type="text">
              </input>
              <div id="item-path-22-instance-1_7" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-22-instance-1_7" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-22-instance-1_8" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-22-instance-1_8" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">22</div>
            <label class="item-label" for="item-input-22-instance-1_8">Grant</label>
            <div class="item-input">
              <input number="22" name="item-input-22-instance-1_8" path="['grants'][7]" id="item-22-instance-1_8" class=" item-input-text" type="text">
              </input>
              <div id="item-path-22-instance-1_8" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-22-instance-1_8" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-22-instance-1_9" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-22-instance-1_9" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">22</div>
            <label class="item-label" for="item-input-22-instance-1_9">Grant</label>
            <div class="item-input">
              <input number="22" name="item-input-22-instance-1_9" path="['grants'][8]" id="item-22-instance-1_9" class=" item-input-text" type="text">
              </input>
              <div id="item-path-22-instance-1_9" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-22-instance-1_9" class="item-error">Invalid</div>
          </div>
          <div id="repeating-enclosing-22-instance-1_10" class="repeating-enclosing invisible">
            <div class="remove-button-container">
              <div id="remove-button-22-instance-1_10" class="btn btn-xs btn-default">-</div>
            </div>
            <div class="item-number">22</div>
            <label class="item-label" for="item-input-22-instance-1_10">Grant</label>
            <div class="item-input">
              <input number="22" name="item-input-22-instance-1_10" path="['grants'][9]" id="item-22-instance-1_10" class=" item-input-text" type="text">
              </input>
              <div id="item-path-22-instance-1_10" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-22-instance-1_10" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-23-instance-1_1" class="item-enclosing">
          <div id="repeating-enclosing-23-instance-1_1" class="repeating-enclosing">
            <div class="item-number">23</div>
            <label class="item-label" for="item-input-23-instance-1_1">Available On Olympus</label>
            <div class="item-input">
              <input number="23" name="item-input-23-instance-1_1" path="['availableOnOlympus']" id="item-23-instance-1_1" class=" item-input-text" type="checkbox">
              </input>
              <div id="item-path-23-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-23-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-24-instance-1_1" class="item-enclosing">
          <div id="repeating-enclosing-24-instance-1_1" class="repeating-enclosing">
            <div class="item-number">24</div>
            <label class="item-label" for="item-input-24-instance-1_1">Available On UIDS</label>
            <div class="item-input">
              <input number="24" name="item-input-24-instance-1_1" path="['availableOnUIDS']" id="item-24-instance-1_1" class=" item-input-text" type="checkbox">
              </input>
              <div id="item-path-24-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-24-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
        <div id="item-enclosing-25-instance-1_1" class="item-enclosing">
          <div id="repeating-enclosing-25-instance-1_1" class="repeating-enclosing">
            <div class="item-number">25</div>
            <label class="item-label" for="item-input-25-instance-1_1">Sign In Required</label>
            <div class="item-input">
              <input number="25" name="item-input-25-instance-1_1" path="['signInRequired']" id="item-25-instance-1_1" class=" item-input-text" type="checkbox">
              </input>
              <div id="item-path-25-instance-1_1" class="item-path" enabled="true"></div>
            </div>
            <div class="clr">
            </div>
            <div id="item-error-25-instance-1_1" class="item-error">Invalid</div>
          </div>
        </div>
      </div>
    </div>
  </div>

        <div id="validation-errors" class="validationErrors">The form is not yet complete. Check through the form for error messages</div>
        <div class="repeating-enclosing category-div" style="display:none">
            <label class="item-label">Category</label>
            <div class="item-input">
                <select class="item-input-text">
                    <option value="none">None provided</option>
                    <c:forEach items="${categoryPaths}" var="categoryPath">
                        <option value="${categoryPath.key}">${categoryPath.value}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="item-error" style="display: none;">Invalid</div>
        </div>
        <div id="submit" class="submit btn btn-sm btn-default">Submit</div>
        <span id="submit-spinner" style="display:none;">
            <img src="<c:url value='/resources/img/spinner.gif'/>"></img>
        </span>

        <p><div id="submit-comments"></div></p>

    </form>
    
</div>
</body>
<myTags:footer></myTags:footer>

</html>