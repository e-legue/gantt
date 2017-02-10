#! /usr/bin/env bash
# This script take in input a station XML file used by the planner. 
# The script will extract xml station definition from it and will put
# them in the svg file.

# PARAMETERS:
# $1: stations XML file
# $2: svg file
# $3: 0 = Exclude "+" attributes
#     1 = Include "+" attributes

VERBOSE=0

# read the options
TEMP=`getopt -o x:s:v --long xml:,svg:,verbose' -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
    case "$1" in
        -x|--xml)
            XML_FILE=$2 ; shift 2 ;;
        -s|--svg)
            SVG_FILE=$2 ; shift 2 ;;
        -v|--verbose)
            VERBOSE=1; shift;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done

if [! -e XML_FILE ] then
  echo "Bad argument -x or --xml. File $XML_FILE does not exist.";
  exit -1;
fi
if [! -e SVG_FILE ] then
  echo "Bad argumetn -s or --svg. File $SVG_FILE does not exist.";
  exit -1;
fi


xsltproc -o station.gantt.xml Station2Gantt.xsl station.xml

