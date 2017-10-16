define([
  "dojo/_base/declare",
  "dijit/_Widget",
  "dijit/form/Button",
], function(
  declare, 
  _WidgetBase,
  Button
) {

  var DbConfig = {
    version: 1, // this is required
    stores: {
      GraphConfiguration: {
        pk                  : { indexed: true , autoIncrement: true, preference: 100, type: "numeric", },
        transportationTime  : { indexed: false,                                       type: "numeric", default:  0, },
        midnightOffset      : { indexed: false,                                       type: "numeric", default:  0, },
        reportTime          : { indexed: false,                                       type: "numeric", default:  0, },
        releaseTime         : { indexed: false,                                       type: "numeric", default:  0, },
//          CalendarTimezone    : { indexed: false,                                       type: "numeric", default: -1, },
        CalendarTimezoneName: { indexed: false,                                       type: "string" , default: undefined, },
        CalendarStation     : { indexed: false,                                       type: "string" , default: undefined, },
        // CalendarStart       : { indexed: false, }, Should be deduced from Calendar.
        // CalendarEnd         : { indexed: false, },
      }, 

      UIConfiguration: {
        pk                      : { indexed: true , autoIncrement: true, preference: 100, type: "numeric", },
        SHCalendarHours         : { indexed: false,                                       type: "boolean", default: true, },
        SHCalendarHourBars      : { indexed: false,                                       type: "boolean", default: true, },
        SHCalendarDayX          : { indexed: false,                                       type: "boolean", default: true, },
        SHCalendarDayYYYYMMDD   : { indexed: false,                                       type: "boolean", default: true, },
        SHCalendarDayBars       : { indexed: false,                                       type: "boolean", default: true, },
        SHCalendarMon           : { indexed: false,                                       type: "boolean", default: true, },
        SHCalendarTue           : { indexed: false,                                       type: "boolean", default: true, },
        SHCalendarWed           : { indexed: false,                                       type: "boolean", default: true, },
        SHCalendarThu           : { indexed: false,                                       type: "boolean", default: true, },
        SHCalendarFri           : { indexed: false,                                       type: "boolean", default: true, },
        SHCalendarSat           : { indexed: false,                                       type: "boolean", default: true, },
        SHCalendarSun           : { indexed: false,                                       type: "boolean", default: true, },
        XGraphCompression       : { indexed: false,                                       type: "numeric", default: 1, },
        SHActivityHours         : { indexed: false,                                       type: "boolean", default: true, },
        SHActivityDetails       : { indexed: false,                                       type: "boolean", default: true, },
        SHActivityDetailHours   : { indexed: false,                                       type: "boolean", default: true, },
        SHActivityDetailStations: { indexed: false,                                       type: "boolean", default: true, },
        SHActivityDuties        : { indexed: false,                                       type: "boolean", default: true, },
      }, 

      Station: {
        pk         : { indexed: true , autoIncrement: true , preference: 100, type: "numeric", },
        code       : { indexed: true , autoIncrement: false, Preference: 10 , type: "string" , }, 
        name       : { indexed: false,                                        type: "string" , }, 
        dstShift   : { indexed: false,                                        type: "string" , }, 
        dstStartLst: { indexed: false,                                        type: "string" , }, 
        dstEndLst  : { indexed: false,                                        type: "string" , }, 
        utcOffset  : { indexed: false,                                        type: "string" , }, 
        offset     : { indexed: false,                                        type: "numeric", },
        regionList : { indexed: false, multyEntry: true, },
      },

      Coordinate: {
        pk    : { indexed: true , autoIncrement: true , preference: 100, type: "numeric", },
        y     : { indexed: false,                                        type: "numeric", },
        height: { indexed: false,                                        type: "numeric", },
        // fk_hl  : "numeric",
        fk_evt: { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", },
        fk_dst: { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", },
        fk_cm : { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", }, 
      },

      Calendar: {
        pk         : { indexed: true , autoIncrement: true , preference: 100, type: "numeric", },
        x          : { indexed: false,                                        type: "numeric", },
        width      : { indexed: false,                                        type: "numeric", },
        name       : { indexed: false,                                        type: "string" , },
        dayweek    : { indexed: false,                                        type: "string" , },
        relative   : { indexed: false,                                        type: "numeric", },
        startperiod: { indexed: false,                                        type: "boolean", },
        /*
        type          : new ComputedProperty({
          dependsOn : ["pk"],
          getValue  : function(pk) {
            return pk % 2 ? "uneven" : "even";
          }
        }),
        ident         : new ComputedProperty({ 
          dependsOn : ["pk"],
          getValue  : function(pk) {
            return "cd" + pk;  // cd stands for Calendar Day.
          }
        }),
        barident      : new ComputedProperty({ 
          dependsOn : ["pk"],
          getValue  : function(pk) {
            return "bcd" + pk;  // bcd stands for Bar Calendar Day.
          }
        }),*/
      },

      CrewMember: {
        pk       : { indexed: true , autoIncrement: true , preference: 100, type: "numeric", },
        name     : { indexed: false,                                        type: "string" , },
        birthdate: { indexed: false,                                        type: "string" , },
        fk_yc    : { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", },
        lineCount: { indexed: false,                                        type: "numeric", },
        /*ident     : new ComputedProperty({
          dependsOn : ["pk"],
          getValue  : function(pk) {
            return "cm" + pk; // cm stands for CrewMember.
          }
        }),
        barident  : new ComputedProperty({ 
          dependsOn : ["pk"],
          getValue  : function(pk) {
            return "bcm" + pk; // bcm stands for Bar CrewMember.
          }
        }),*/
      },

      Activity: {
        pk                : { indexed: true , autoIncrement: true , preference: 100, type: "numeric", },
        fk_cm             : { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", },
        fk_parent         : { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", },
        name              : { indexed: false,                                        type: "string" , },
        fullName          : { indexed: false,                                        type: "string" , },
        x                 : { indexed: false,                                        type: "numeric", },
        xRefUTC           : { indexed: false,                                        type: "numeric", },
        duration          : { indexed: false,                                        type: "numeric", },
        midnightOffset    : { indexed: false,                                        type: "boolean", },
        transportationTime: { indexed: false,                                        type: "boolean", },
        restBefore        : { indexed: false,                                        type: "numeric", },
        restAfter         : { indexed: false,                                        type: "numeric", },
        type              : { indexed: false,                                        type: "string" , }, //  main type of activity TRP, TRN, RSV, LVE
        activityType      : { indexed: false,                                        type: "string" , }, // for RSV, could be ASBY, HSBY, etc...
        lbtStart          : { indexed: false,                                        type: "string" , },
        lbtEnd            : { indexed: false,                                        type: "string" , },
        utcStart          : { indexed: false,                                        type: "string" , },
        utcEnd            : { indexed: false,                                        type: "string" , },
        block             : { indexed: false,                                        type: "numeric", },
        credit            : { indexed: false,                                        type: "numeric", },
        duty              : { indexed: false,                                        type: "numeric", },
        tafbInPeriod      : { indexed: false,                                        type: "numeric", },
        blockInPeriod     : { indexed: false,                                        type: "numeric", },
        creditInPeriod    : { indexed: false,                                        type: "numeric", },
        dutyInPeriod      : { indexed: false,                                        type: "numeric", },
        station           : { indexed: false,                                        type: "string" , },
        lineNb            : { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", },
        /*ident          : new ComputedProperty({
          dependsOn    : ["pk", "type"],
          getValue     : function(pk, type) {
            return type.toLowerCase() + pk;  // DOxxx or TRPxxx or  .. 
          }
        }),*/
      },

      Distance: {
        pk        : { indexed: true, autoIncrement: true , preference: 100, type: "numeric", },
        fk_actFrom: { indexed: true, autoIncrement: false, preference: 10 , type: "numeric", },
        fk_evtFrom: { indexed: true, autoIncrement: false, preference: 10 , type: "numeric", },
        fk_actTo  : { indexed: true, autoIncrement: false, preference: 10 , type: "numeric", },
        fk_evtTo  : { indexed: true, autoIncrement: false, preference: 10 , type: "numeric", },
        fk_yc     : { indexed: true, autoIncrement: false, preference: 10 , type: "numeric", },
        /*ident      : new ComputedProperty({
          dependsOn : ["pk"],
          getValue: function(pk) {
            return "dst" + pk;  // dst stands for distance
          }
        }),*/
      },

      Event: {
        pk           : { indexed: true , autoIncrement: true , preference: 100, type: "numeric", },
        x            : { indexed: false,                                        type: "numeric", }, // for activity, negative value.
        long_label   : { indexed: false,                                        type: "string" , },
        label        : { indexed: false,                                        type: "string" , },
        fk_act       : { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", }, // 0 means no activity
        fk_act_detail: { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", }, // 0 means no activity detail.
        fk_yc        : { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", },
        order        : { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", },
        thichness    : { indexed: false,                                        type: "numeric", default: 1, },
        color        : { indexed: false,                                        type: "string" , default: "#ff0000", },
        /*ident         : new ComputedProperty({
          dependsOn : ["pk"],
          getValue  : function(pk) {
            return "evt" + pk;  // evt stands for Event
          }
        }),
        barident      : new ComputedProperty({ 
          dependsOn : ["pk"],
          getValue  : function(pk) {
            return "bevt" + pk;  // bevt stands for Bar Event
          }
        }),*/
      },

      Note: {
        pk    : { indexed: true , autoIncrement: true , preference: 100, type: "numeric", },
        x     : { indexed: false,                                        type: "numeric", },
        y     : { indexed: false,                                        type: "numeric", },
        note  : { indexed: false,                                        type: "string" , },
        color : { indexed: false,                                        type: "string" , },
        fk_evt: { indexed: true , autoIncrement: false, preference: 10 , type: "numeric", },
        /*ident  : new ComputedProperty({
          dependsOn : ["pk"],
          getValue  : function(pk) {
            return "note" + pk;  // evt stands for Event
          }
        }),*/
  
      },
    }
  };

  return DbConfig;
}

