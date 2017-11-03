/**
 * Created by jdl50 on 11/3/17.
 */

function toggleElementById(id, element) {
    event.preventDefault();
    var example = $(element).text().indexOf('example') > -1;
    var isVisible = $(id).is(":visible");

    if(isVisible) {
        $(id).fadeOut();

        if(!example) {
            $(element).toggleClass('glyphicon-minus glyphicon-plus');
            $('#example-' + id.replace('#','')).fadeOut();

            var spanId = "#span-a-" + id.replace('#','').replace('-code-block', '');
            var hrefId = "#a-" + id.replace('#','').replace('-code-block', '');

            $(spanId).hide();
            $(hrefId).text('show example');
        } else {
            $(element).text('show example');
        }
    } else {
        $(id).fadeIn();

        if(!example) {
            $(element).toggleClass('glyphicon-plus glyphicon-minus');
            $('#example-' + id.replace('#','')).fadeOut();

            var spanId = "#span-a-" + id.replace('#','').replace('-code-block', '');
            $(spanId).show();
        } else {
            $(element).text('hide example');
        }
    }
}



function drawDiagram() {

    $('#workflow-none-img').hide();
    $('#workflow-spew-img').hide();
    $('#workflow-synthia-img').hide();

    var synthpop = $('input[name=synthpop]:checked').val();
    var dtm = $('input[name=dtm]:checked').val();
    var olympusUsername =$('#olympus-username').val();

    var locationValues = $('#location-select').val().split('_');
    var formattedLocation = formatLocation(locationValues[0]);
    var locationCode = locationValues[1];

    if(synthpop == 'spew') {
        $('#workflow-spew-img').show();
    } else if(synthpop == 'synthia') {
        $('#workflow-synthia-img').show();
    } else {
        $('#workflow-none-img').show();
    }

    if(locationCode != null && synthpop != null && dtm != null) {
        var username = "<username>";
        if(olympusUsername != null && olympusUsername.trim() != '') {
            username = olympusUsername;
        }

        var outputDirectory = locationCode + "_" + dtm + "_" + getFormattedDate();

        if(synthpop == 'spew' ) {
            $('#submit-lsdtm-script').text("/mnt/lustre0/data/shared_group_data/syneco/spew2synthia/scripts/lsdtm.sh -p 2010_ver1_" + locationCode + " -o " + outputDirectory);
        } else {
            $('#submit-lsdtm-script').text("/mnt/lustre0/data/shared_group_data/syneco/spew2synthia/scripts/lsdtm.sh -p 2010_ver1_" + locationCode + " -o " + outputDirectory + " -e fred_populations/United_States_2010_ver1");
        }
        //$('#submit-lsdtm-script').text("/mnt/lustre0/data/shared_group_data/syneco/spew2synthia/scripts/lsdtm.sh -p spew_1.2.0_" + locationCode + " -o " + outputDirectory);
        $('#example-submit-lsdtm-script').text("-bash-4.2$ /mnt/lustre0/data/shared_group_data/syneco/spew2synthia/scripts/lsdtm.sh -p spew_1.2.0_" +
            locationCode + " -o /home/" + username + "/test\n557925.pbs.olympus.psc.edu");

        $('#status-lsdtm-script').text("qstat | grep " + username);
        $('#example-status-lsdtm-script').text("-bash-4.2$ qstat | grep " + username + "\n557925.pbs.olympus.psc.edu ...synthia-1.2.0 " + username + "        00:33:37 R batch");

        $('#view-output-lsdtm-script').text("ls " + outputDirectory);
        $('#example-view-output-lsdtm-script').text("-bash-4.2$ ls /home/" + username + "/test\nspew2synthia-1.2.0.e557925  spew2synthia-1.2.0.o557925  OUT  params");

        if(synthpop == 'spew') {
            $('#view-error-lsdtm-script').text("cat " + outputDirectory + "/spew2synthia-1.2.0.e######");
            $('#example-view-error-lsdtm-script').text("-bash-4.2$ cat /home/" + username + "/spew2synthia-1.2.0.e557925\n\nThe following have been reloaded with a version change:\n1) gcc/4.8.3 => gcc/6.1.0");

        } else {
            $('#view-error-lsdtm-script').text("cat " + outputDirectory + "/United_States_2010_ver1.e######");
            $('#example-view-error-lsdtm-script').text("-bash-4.2$ cat /home/" + username + "/United_States_2010_ver1.e557925\n\nThe following have been reloaded with a version change:\n1) gcc/4.8.3 => gcc/6.1.0");
        }

        if(synthpop == 'spew') {
            $('#view-stdout-lsdtm-script').text("tail " + outputDirectory + "/spew2synthia-1.2.0.o######");
            $('#example-view-stdout-lsdtm-script').text("-bash-4.2$ tail /home/" + username + "/spew2synthia-1.2.0.o557925\n\nday 239 report population took 0.000115 seconds\n" +
                "day 239 maxrss 4068524\nday 239 finished Fri Apr  7 14:53:10 2017\nDAY_TIMER day 239 took 0.002799 seconds\n\n\n" +
                "FRED simulation complete. Excluding initialization, 240 days took 0.493485 seconds\nFRED finished Fri Apr  7 14:53:10 2017\nFRED took 52.511174 seconds");
        } else {
            $('#view-stdout-lsdtm-script').text("tail " + outputDirectory + "/United_States_2010_ver1.o######");
            $('#example-view-stdout-lsdtm-script').text("-bash-4.2$ tail /home/" + username + "/United_States_2010_ver1.o557925\n\nday 239 report population took 0.000115 seconds\n" +
                "day 239 maxrss 4068524\nday 239 finished Fri Apr  7 14:53:10 2017\nDAY_TIMER day 239 took 0.002799 seconds\n\n\n" +
                "FRED simulation complete. Excluding initialization, 240 days took 0.493485 seconds\nFRED finished Fri Apr  7 14:53:10 2017\nFRED took 52.511174 seconds");
        }
        $('#view-fred-out-lsdtm-script').text("cat " + outputDirectory + "/OUT/out1.txt");
        $('#example-view-fred-out-lsdtm-script').text("-bash-4.2$ cat /home/" + username + "/OUT/out1.txt\nDay 0 Date 2012-01-02 WkDay Tue C 10 College 0 Cs 0 E 10 GQ 0 I 0 Is 0 M 0" +
            "Military 0 N 2278377 Nursing_Home 0 P 10 Prison 0 R 0 S 2278367 Week 1 Year 2012 AR 0.00 ARs 0.00 RR 0.00\nDay 1 Date 2012-01-03 WkDay Wed C 0 College 0 Cs 1 E" +
            "9 GQ 0 I 1 Is 1 M 0 Military 0 N 2278377 Nursing_Home 0 P 10 Prison 0 R 0 S 2278367 Week 1 Year 2012 AR 0.00 ARs 0.00 RR 0.00\n.\n.\n.\nDay 238 Date 2012-08-27" +
            "WkDay Tue C 127 College 0 Cs 81 E 232 GQ 0 I 570 Is 376 M 0 Military 0 N 2278377 Nursing_Home 0 P 802 Prison 0 R 2904 S 2274671 Week 35 Year 2012 AR 0.23 ARs 0.14 RR 0.95\n" +
            "Day 239 Date 2012-08-28 WkDay Wed C 108 College 0 Cs 75 E 228 GQ 0 I 593 Is 389 M 0 Military 0 N 2278377 Nursing_Home 0 P 821 Prison 0 R 2966 S 2274590 Week 35 Year 2012 AR 0.23 ARs 0.15 RR 1.20");

        $('#lsdtm-script-container').show();
    } else {
        $('#lsdtm-script-container').hide();
    }
}

function checkLocationSelect() {
    if($("#location-select").val() != '') {
        $("#synthpop-radios").children().each(function(index, child) {
            var text = $(child).text();

            $(child).removeAttr("disabled");

            $(child).children().each(function(index, childsChild) {
                $(childsChild).removeAttr("disabled");
                /*if(text == "SPEW") {
                 $(childsChild).click();
                 }*/
            });
            drawDiagram();
        });
    } else {
        $("#synthpop-radios").children().each(function(index, child) {
            var text = $(child).text();
            $(child).attr("disabled", "disabled");

            if(text == "SPEW") {
                $(child).children().each(function(index, childsChild) {
                    $(childsChild).attr("disabled", "disabled");
                    $(childsChild).removeAttr("checked");
                });
                drawDiagram();
            }
        });
    }
}

function getFormattedDate() {
    var date = new Date();
    var year = date.getYear()-100;
    var month = date.getMonth() + 1;
    var day = date.getDate();
    var minutes = date.getMinutes();
    var seconds = date.getSeconds();

    year = convertDateNumToString(year);
    month = convertDateNumToString(month);
    day = convertDateNumToString(day);
    minutes = convertDateNumToString(minutes);
    seconds = convertDateNumToString(seconds);

    var formattedDate = year + month + day + minutes + seconds;

    return formattedDate;
}
