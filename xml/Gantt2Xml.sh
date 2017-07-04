#! /usr/bin/env bash
# This script take in input a station XML file used by the planner. 
# The script will extract xml station definition from it and will put
# them in the svg file.

# PARAMETERS:
# $1: stations XML file
# $2: svg file
# $3: 0 = Exclude "+" attributes
#     1 = Include "+" attributes
set -e 

VERBOSE=false
xsl_verbose=""
sflag=false
DEST_DIR=`date +%Y%m%d%H%M`

# read the options
TEMP=`getopt -o s:d:v --long source:,verbose,dest_dir: -- "$@"`
eval set -- "$TEMP"

# extract options and their arguments into variables.
while true ; do
  case "$1" in
    -s|--source)
      SOURCE_FILE=$2; sflag=true; shift 2;;
    -v|--verbose)
      VERBOSE=true; xsl_verbose="-v"; shift;;
    -d|--dest_dir)
      DEST_DIR=$2; shift 2;;
    --) shift ; break ;;
      *) echo "Internal error!"; exit 1;;
  esac
done

if ! $sflag
then 
  echo "Argument -s or --source source_file is mandatary."
  exit -1

fi  

if [ ! -e $SOURCE_FILE ]
then
  echo "Bad argument value -s or --source. File $SOURCE_FILE does not exist."
  exit -1
fi

if $VERBOSE
then
  echo "==============================================="
  echo "Generation of station.xml file"
  echo "==============================================="
fi
xsltproc $xsl_verbose -o station.xml  Gantt2Station.xsl  $SOURCE_FILE
xsltproc $xsl_verbose -o qual.xml     Gantt2Qual.xsl     $SOURCE_FILE
xsltproc $xsl_verbose -o acts.xml     Gantt2Acts.xsl     $SOURCE_FILE
xsltproc $xsl_verbose -o trip.xml     Gantt2Trip.xsl     $SOURCE_FILE
xsltproc $xsl_verbose -o trip_sup.xml Gantt2Trip_sup.xsl $SOURCE_FILE

