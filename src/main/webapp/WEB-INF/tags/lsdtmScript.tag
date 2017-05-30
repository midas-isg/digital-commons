<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="myTags" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="s" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<table style="width: 100%; table-layout: fixed;"><tr><td style="width:36px"><pre style="margin: 0; line-height: 125%; border:none; border-right: 1px solid #ccc;"> 1
 2
 3
 4
 5
 6
 7
 8
 9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
53
54
55
56
57
58
59
60
61
62
63
64
65
66
67
68
69
70
71
72
73
74
75
76
77
78
79
80
81
82</pre></td><td style="background: #f5f5f5;"><pre id="lsdtm-script" style="margin: 0; line-height: 125%; border:none; display:inline-block; overflow:visible"><span style="color: #0099FF; font-style: italic">#!/bin/sh</span>

<span style="color: #003333">base_dir</span><span style="color: #555555">=</span><span style="color: #006699; font-weight: bold">$(</span>dirname <span style="color: #CC3300">"$0"</span><span style="color: #006699; font-weight: bold">)</span>
<span style="color: #003333">population_type</span><span style="color: #555555">=</span><span style="color: #CC3300">"synthetic_population_id"</span>
<span style="color: #0099FF; font-style: italic">#model="fred/fred-phdl2.12.0-isg1.0"</span>
<span style="color: #003333">model</span><span style="color: #555555">=</span><span style="color: #CC3300">"fred/pfred-0.0.8"</span>
<span style="color: #003333">ecosystem</span><span style="color: #555555">=</span><span style="color: #CC3300">"fred_populations/spew2synthia-1.2.0"</span>

<span style="color: #006699; font-weight: bold">function </span>usage
<span style="color: #555555">{</span>
        <span style="color: #336666">echo</span> <span style="color: #CC3300">"Usage: lsdtm.sh [[-p Synthetic Population ID] (OPTIONS: [[-e Ecosystem] [-o Output Directory]])] | [-h Help]"</span>
        <span style="color: #336666">echo</span>
<span style="color: #336666">        echo</span> <span style="color: #CC3300">"-p, --population"</span>
        <span style="color: #336666">echo</span> <span style="color: #CC3300">"    Synthetic Population ID"</span>
        <span style="color: #336666">echo</span> <span style="color: #CC3300">"-e, --ecosystem"</span>
        <span style="color: #336666">echo</span> <span style="color: #CC3300">"    Ecosystem containing population (default is fred_populations/spew2synthia-1.2.0)"</span>
        <span style="color: #336666">echo</span> <span style="color: #CC3300">"-o, --output_directory"</span>
        <span style="color: #336666">echo</span> <span style="color: #CC3300">"    Directory where the output will be generated"</span>
        <span style="color: #336666">echo</span> <span style="color: #CC3300">"-h, --help"</span>
        <span style="color: #336666">echo</span> <span style="color: #CC3300">"    Display this help information"</span>
        <span style="color: #336666">echo</span>
<span style="color: #555555">}</span>

<span style="color: #006699; font-weight: bold">while</span> <span style="color: #555555">[</span> <span style="color: #CC3300">"$1"</span> !<span style="color: #555555">=</span> <span style="color: #CC3300">""</span> <span style="color: #555555">]</span>; <span style="color: #006699; font-weight: bold">do</span>
<span style="color: #006699; font-weight: bold">    case</span> <span style="color: #003333">$1</span> in
        -p | --population <span style="color: #555555">)</span>        <span style="color: #336666">shift</span>
<span style="color: #336666">                                   </span><span style="color: #003333">population_id</span><span style="color: #555555">=</span><span style="color: #003333">$1</span>
                                   ;;
        -f | --fips <span style="color: #555555">)</span>              <span style="color: #003333">population_type</span><span style="color: #555555">=</span><span style="color: #CC3300">"fips"</span>
                                   ;;
        -c | --city <span style="color: #555555">)</span>              <span style="color: #006699; font-weight: bold">if</span> <span style="color: #555555">[</span> <span style="color: #CC3300">"$population_type"</span> !<span style="color: #555555">=</span> <span style="color: #CC3300">"fips"</span> <span style="color: #555555">]</span>; <span style="color: #006699; font-weight: bold">then</span>
<span style="color: #006699; font-weight: bold">                                         </span><span style="color: #003333">population_type</span><span style="color: #555555">=</span><span style="color: #CC3300">"city"</span>
                                   <span style="color: #006699; font-weight: bold">fi</span>
                                   ;;
        -C | --county <span style="color: #555555">)</span>            <span style="color: #006699; font-weight: bold">if</span> <span style="color: #555555">[</span> <span style="color: #CC3300">"$population_type"</span> !<span style="color: #555555">=</span> <span style="color: #CC3300">"city"</span> <span style="color: #555555">]</span> <span style="color: #555555">&amp;&amp;</span> <span style="color: #555555">[</span> <span style="color: #003333">$population_type</span> !<span style="color: #555555">=</span> <span style="color: #CC3300">"fips"</span> <span style="color: #555555">]</span>; <span style="color: #006699; font-weight: bold">then</span>
<span style="color: #006699; font-weight: bold">                                        </span><span style="color: #003333">population_type</span><span style="color: #555555">=</span><span style="color: #CC3300">"county"</span>
                                   <span style="color: #006699; font-weight: bold">fi</span>
                                   ;;
        -s | --state <span style="color: #555555">)</span>             <span style="color: #006699; font-weight: bold">if</span> <span style="color: #555555">[</span> <span style="color: #CC3300">"$population_type"</span> <span style="color: #555555">==</span> <span style="color: #CC3300">"synthetic_population_id"</span> <span style="color: #555555">]</span>; <span style="color: #006699; font-weight: bold">then</span>
<span style="color: #006699; font-weight: bold">                                        </span><span style="color: #003333">population_type</span><span style="color: #555555">=</span><span style="color: #CC3300">"state"</span>
                                   <span style="color: #006699; font-weight: bold">fi</span>
                                   ;;
        -m | --model <span style="color: #555555">)</span>             <span style="color: #336666">shift</span>
<span style="color: #336666">                                   </span><span style="color: #003333">model</span><span style="color: #555555">=</span><span style="color: #003333">$1</span>
                                   ;;
        -e | --ecosystem <span style="color: #555555">)</span>         <span style="color: #336666">shift</span>
<span style="color: #336666">                                   </span><span style="color: #003333">ecosystem</span><span style="color: #555555">=</span><span style="color: #003333">$1</span>
                                   ;;
        -o | --output_directory <span style="color: #555555">)</span>  <span style="color: #336666">shift</span>
<span style="color: #336666">                                   </span><span style="color: #003333">output_directory</span><span style="color: #555555">=</span><span style="color: #003333">$1</span>
                                   ;;
        -h | --help <span style="color: #555555">)</span>              <span style="color: #336666">echo</span> <span style="color: #CC3300">"This script will call a PSC PBS request to run pFRED on the provided Synthetic Population ID."</span>
                                   usage
                                   <span style="color: #336666">exit</span>
                                   ;;
        * <span style="color: #555555">)</span>                        usage
                                   <span style="color: #336666">exit </span>1
    <span style="color: #006699; font-weight: bold">esac</span>
<span style="color: #006699; font-weight: bold">    </span><span style="color: #336666">shift</span>
<span style="color: #006699; font-weight: bold">done</span>

<span style="color: #006699; font-weight: bold">if</span> <span style="color: #555555">[</span> ! -z <span style="color: #CC3300">"$population_id"</span> <span style="color: #555555">]</span>; <span style="color: #006699; font-weight: bold">then</span>
<span style="color: #006699; font-weight: bold">        if</span> <span style="color: #555555">[</span> ! -z <span style="color: #CC3300">"$output_directory"</span> <span style="color: #555555">]</span>; <span style="color: #006699; font-weight: bold">then</span>
<span style="color: #006699; font-weight: bold">                if</span> <span style="color: #555555">[</span> ! -d <span style="color: #CC3300">"$output_directory"</span> <span style="color: #555555">]</span>; <span style="color: #006699; font-weight: bold">then</span>
<span style="color: #006699; font-weight: bold">                        </span>mkdir <span style="color: #003333">$output_directory</span>
                <span style="color: #006699; font-weight: bold">fi</span>

<span style="color: #006699; font-weight: bold">                </span><span style="color: #336666">cd</span> <span style="color: #003333">$output_directory</span>
        <span style="color: #006699; font-weight: bold">fi</span>

<span style="color: #006699; font-weight: bold">        if</span> <span style="color: #555555">[</span> <span style="color: #CC3300">"$population_type"</span> !<span style="color: #555555">=</span> <span style="color: #CC3300">"synthetic_population_id"</span> <span style="color: #555555">]</span>; <span style="color: #006699; font-weight: bold">then</span>
<span style="color: #006699; font-weight: bold">                </span><span style="color: #336666">echo</span> <span style="color: #CC3300">"Setting $population_id as $population_type"</span>
        <span style="color: #006699; font-weight: bold">fi</span>

<span style="color: #006699; font-weight: bold">        </span>module load <span style="color: #003333">$ecosystem</span>
        <span style="color: #003333">$base_dir</span>/generate_params.sh <span style="color: #003333">$population_id</span> <span style="color: #003333">$population_type</span>
        <span style="color: #003333">$base_dir</span>/run_dtm.sh <span style="color: #003333">$model</span> <span style="color: #003333">$ecosystem</span>
<span style="color: #006699; font-weight: bold">else</span>
<span style="color: #006699; font-weight: bold">        </span>usage
        <span style="color: #006699; font-weight: bold">$(</span>&gt;&amp;2 <span style="color: #336666">echo</span> <span style="color: #CC3300">"Error: Failed to provide Synthetic Population ID"</span><span style="color: #006699; font-weight: bold">)</span>
        <span style="color: #006699; font-weight: bold">$(</span>&gt;&amp;2 <span style="color: #336666">echo</span> <span style="color: #CC3300">"Aborted"</span><span style="color: #006699; font-weight: bold">)</span>
<span style="color: #006699; font-weight: bold">fi</span>
</pre></td></tr></table>