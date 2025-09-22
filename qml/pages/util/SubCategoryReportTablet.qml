import QtQuick 2.4

//import QtQuick.Layouts 1.3
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Components.Pickers 1.3

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Lomiri.Components.ListItems 1.3 as ListItem

/* Thanks to: https://github.com/jwintz/qchart.js for QML bindings for Charts.js, */

import "../../js/storage.js" as Storage
import "../../js/utility.js" as Utility
import "../../js/subCategoryReportChart.js" as SubCategoryReportChart
import "../../js/QChart.js" as Charts

import "../../dialogs"

/*
   Content of the report Page (charts) for a chosen SUB-Category. 
   This is the content for Tablet devices
*/
Column{
    id: reportPageColumn
    anchors.fill: parent
    spacing: units.gu(3.5)

    /* properties used inside this file */
    property string currency : Storage.getConfigParamValue('currency');
    property int currentReportItemSelected : 0;
    /* a local properties used to intercept selected category changes event */
    property int selectedCategoryId: statisticsPage.categoryId;


    /* transparent placeholder: required to place the content under the header */
    Rectangle {
        /* to get the background color of the curreunt theme. Necessary if default theme is not used */
        color: theme.palette.normal.background
        width: parent.width
        height: units.gu(8)
    }

    Component {
        id: reportTypeSelectorDelegate
        OptionSelectorDelegate { text: name; subText: description; }
    }

    onSelectedCategoryIdChanged: {
        /* hide all charts beacuse the user has choose a different category */
        subCategoryInstantReportChartRow.visible = false;
        subCategoryLastMonthChartRow.visible = false
        subCategoryCustomRangeChartRow.visible = false
        chartTitleLabelContainer.visible = false
    }

    ListModel {
        id: reportTypeModel
    }

    /* fill listmodel using this method because allow you to use i18n */
    Component.onCompleted: {
          reportTypeModel.append( { name: "<b>"+i18n.tr("Instant Report")+"</b>", description: i18n.tr("subcategory expenses at current date"), value:1 } );
          reportTypeModel.append( { name: "<b>"+i18n.tr("Last Month Report")+"</b>", description: i18n.tr("subcategory expenses in the last month"), value:2 } );
          reportTypeModel.append( { name: "<b>"+i18n.tr("Custom Report")+"</b>", description: i18n.tr("subcategory expenses in a custom range"), value:3 } );
    }

    Row{
        id: reporTypeSelectorrow
        spacing: units.gu(3)

        Rectangle {
            color: "transparent"
            width:reporTypeSelectorrow.width/6
            height:units.gu(1)
        }

        Label {
            id: reportTypeItemSelectorLabel
            anchors.verticalCenter: reportTypeItemSelector.Center
            text: "<b>"+i18n.tr("Available Report")+":"+"</b>"
        }

        Rectangle{
            width:units.gu(50)
            height:units.gu(7)
            /* to get the background color of the curreunt theme. Necessary if default theme is not used */
            color: theme.palette.normal.background

            ListItem.ItemSelector {
                id: reportTypeItemSelector
                delegate: reportTypeSelectorDelegate
                model: reportTypeModel
                containerHeight: itemHeight * 3

                /* ItemSelectionChange event is not built-in with ItemSelector: use a workaround */
                onDelegateClicked:{

                    if(reportTypeItemSelector.currentlyExpanded.toString() != 'false'){

                        if(currentReportItemSelected !== selectedIndex){
                            currentReportItemSelected = selectedIndex;

                            /* hide all until the user choose a report and press 'Show' button */
                            subCategoryInstantReportChartRow.visible = false;
                            subCategoryLastMonthChartRow.visible = false
                            subCategoryCustomRangeChartRow.visible = false
                            chartTitleLabelContainer.visible = false
                        }
                    }
                }
             }
        }


        Button {
            id: showChartButton
            text: i18n.tr("Show/Refresh")
            onClicked: {

                    if (reportTypeModel.get(reportTypeItemSelector.selectedIndex).value === 1) {  /* instant report */

                        SubCategoryReportChart.getLegendDataInstantReport(statisticsPage.categoryId);

                        sub_category_report_current_chart.chartData = SubCategoryReportChart.getChartDataInstantReport(statisticsPage.categoryId);

                        subCategoryInstantReportChartRow.visible = true;
                        subCategoryLastMonthChartRow.visible = false;
                        subCategoryCustomRangeChartRow.visible = false;
                        chartTitleLabel.text= "<b>"+i18n.tr("Situation at")+": "+ Qt.formatDateTime(new Date(), "dd MMMM yyyy")+"</b> "+i18n.tr("(date format is yyyy-mm-dd)")
                        chartTitleLabelContainer.visible = true;

                    } else if (reportTypeModel.get(reportTypeItemSelector.selectedIndex).value === 2) { /* monthly report */

                        var today = Utility.getTodayDate();  //eg: Wed Mar 29 00:00:00 2017 GMT
                        var monthAgo = Utility.addDaysToDate(today, -30);

                        SubCategoryReportChart.getLegendDataForLastMonthReport( Utility.formatDateToString(monthAgo), Utility.formatDateToString(today),statisticsPage.categoryId );

                        /* true if no data found */
                        if(lastMonthChartListModel.count === 0){

                           chartTitleLabel.text= "<b>"+i18n.tr("NO DATA FOUND")+"</b> "+i18n.tr("for Monthly report from")+": "+Utility.formatDateToString(monthAgo)+" "+ i18n.tr("to")+": "+Utility.formatDateToString(today)+"</b> "+i18n.tr("(date format is yyyy-mm-dd)")
                           chartTitleLabelContainer.visible = true;

                        }else{

                            sub_category_report_history_chart.chartData = SubCategoryReportChart.getChartDataLastMonthReport(Utility.formatDateToString(monthAgo), Utility.formatDateToString(today), statisticsPage.categoryId);

                            subCategoryInstantReportChartRow.visible = false;
                            subCategoryCustomRangeChartRow.visible = false;
                            subCategoryLastMonthChartRow.visible = true;
                            chartTitleLabel.text= "<b>"+i18n.tr("Monthly report from")+": "+Utility.formatDateToString(monthAgo)+ i18n.tr("to")+": "+Utility.formatDateToString(today)+"</b> "+i18n.tr("(date format is yyyy-mm-dd)")
                            chartTitleLabelContainer.visible = true;
                        }

                    } else if (reportTypeModel.get(reportTypeItemSelector.selectedIndex).value === 3) { /* custom report */

                         /* allow to specify the time range and load data for chart legend */
                         PopupUtils.open(popoverTimeRangeChooserComponent, showChartButton)

                         subCategoryInstantReportChartRow.visible = false;
                         subCategoryLastMonthChartRow.visible = false;
                         subCategoryCustomRangeChartRow.visible = true;
                         chartTitleLabelContainer.visible = true;
                    }
              }
          }
    }

    //------------ Time Range chooser Component ---------
    Component {
         id: popoverTimeRangeChooserComponent

         Dialog {
             id: timeRangePickerDialog
              contentWidth: units.gu(42)

             Column{
                 spacing: units.gu(1)
                 width:  reportPageColumn.width + units.gu(6)

             Row{
                 Label{
                     text: "<b>"+i18n.tr("From")+": </b>"
                 }
             }

             Row{
                 width: reportPageColumn.width/3
                 DatePicker {
                     id: timeFromPicker
                     width: parent.width
                     mode: "Days|Months|Years"
                     minimum: {
                         var time = new Date()
                         time.setFullYear('2000')
                         return time
                     }
                 }
             }

             Row{
                 Label{
                     text: "<b>"+i18n.tr("To")+": </b>"
                 }
             }

             Row{
                 width: reportPageColumn.width/3
                 DatePicker {
                     id: timeToPicker
                     width: parent.width
                     mode: "Days|Months|Years"
                     minimum: {
                         var time = new Date()
                         time.setFullYear(time.getFullYear())
                         return time
                     }
                 }
             }

             Row {
                 width: reportPageColumn.width/3
                 spacing: units.gu(2)

                 Button {
                     text: i18n.tr("Confirm")
                     width: units.gu(17)
                     onClicked: {

                         var to = new Date (timeToPicker.date);
                         var from = new Date (timeFromPicker.date);

                         chartTitleLabel.text= "<b>"+i18n.tr("Custom report from")+": "+Utility.formatDateToString(from)+i18n.tr("to")+": "+Utility.formatDateToString(to)+"</b> "+i18n.tr("(date format is yyyy-mm-dd)")

                         SubCategoryReportChart.getLegendDataForCustomRangeReport(Utility.formatDateToString(from),Utility.formatDateToString(to),statisticsPage.categoryId);

                         /* if no data found create an empty chart legend */
                         if(customRangeChartListModel.count === 0){
                             chartTitleLabel.text= "<b>"+i18n.tr("NO DATA FOUND")+"</b>"+i18n.tr("from")+": "+Utility.formatDateToString(from)+ i18n.tr("to")+": "+Utility.formatDateToString(to)+i18n.tr("(date format is yyyy-mm-dd)")
                         }else{
                            sub_category_report_history_custom_chart.chartData = SubCategoryReportChart.getChartDataCustomRangeReport(Utility.formatDateToString(from),Utility.formatDateToString(to),statisticsPage.categoryId);
                         }
                         PopupUtils.close(timeRangePickerDialog)
                     }
                 }

                 Button {
                     text: i18n.tr("Close")
                     width: units.gu(17)
                     onClicked: {
                        PopupUtils.close(timeRangePickerDialog)
                     }
                 }
             }

         }//col
         }
    }
   //-----------------------------------------


   /* Chart Title/Header */
   Rectangle {
        id: chartTitleLabelContainer
        visible: false
        /* get default backbround. to support dark theme */
        color: theme.palette.normal.background
        width: parent.width
        height: units.gu(3)
        Label{
            id: chartTitleLabel
            anchors.centerIn: parent
        }
    }


   //------------- Instant report chart ---------------------
   Grid {
       id: subCategoryInstantReportChartRow
       visible: false
       columns:2
       columnSpacing: units.gu(1)
       width: parent.width;
       height: parent.height

       //Chart {
       QChart{
           id: sub_category_report_current_chart;
           width: parent.width - units.gu(30);
           height: parent.height - reporTypeSelectorrow.height - units.gu(25);
           chartAnimated: false;
           //chartData: SubCategoryReportChart.getChartDataInstantReport(statisticsPage.categoryId);
           chartType: Charts.ChartType.BAR;
       }

       /* model for the chart table legend */
       ListModel {
           id: instantReportTableListModel
       }

       /* Chart data legend */
       ListView {
           width: parent.width
           height: parent.height
           model: instantReportTableListModel
           delegate:

               Component{
                   id: instantReportChartLegend
                   Rectangle {
                       id: wrapper
                       height: legendRow.height + units.gu(1)
                       border.color: LomiriColors.lightGrey
                       border.width:units.gu(1)

                       Label {
                           anchors.horizontalCenter: wrapper.Center
                           id: legendRow
                           text: "<b>"+sub_cat_name+"</b> :  "+current_amount +" <i>"+currency+ "</i>"

                       }
                   }
               }
        }
   }


   //------------- Last month chart ---------------------
   Grid {
       id: subCategoryLastMonthChartRow
       visible: false
       columns:2
       columnSpacing: units.gu(1)
       width: parent.width;
       height: parent.height

       //Chart {
       QChart{
           id: sub_category_report_history_chart;
           width: parent.width - units.gu(30);
           height: parent.height - reporTypeSelectorrow.height - units.gu(25);
           chartAnimated: false;
           chartType: Charts.ChartType.BAR;
       }

       /* model for the chart table legend */
       ListModel {
           id: lastMonthChartListModel
       }

       /* Chart data legend */
       ListView {
           width: parent.width
           height: parent.height
           model: lastMonthChartListModel
           delegate:

               Component{
               id: lastMonthChartLegend
               Rectangle {
                   id: wrapper
                   height: legendEntry.height + units.gu(1)
                   border.color: LomiriColors.lightGrey
                   border.width:units.gu(1)

                   Label {
                       anchors.horizontalCenter: wrapper.Center
                       id: legendEntry
                       text: "<b>"+sub_cat_name+"</b> :  "+current_amount +" <i>"+currency+ "</i>"
                   }
               }
           }
       }
   }


   //------------- Custom range chart ---------------
   Grid {
       id: subCategoryCustomRangeChartRow
       visible: false
       columns:2
       columnSpacing: units.gu(1)
       width: parent.width;
       height: parent.height

       //Chart {
       QChart{
           id: sub_category_report_history_custom_chart;
           width: parent.width - units.gu(30);
           height: parent.height - reporTypeSelectorrow.height - units.gu(25);
           chartAnimated: false;
           chartType: Charts.ChartType.BAR;
       }

       /* model for the chart table legend */
       ListModel {
           id: customRangeChartListModel
       }

       /* Chart data legend */
       ListView {
           width: parent.width
           height: parent.height
           model: customRangeChartListModel
           delegate:

               Component{
               id: customReportChartLegend
               Rectangle {
                   id: wrapper
                   height: legendEntry.height + units.gu(1)
                   border.color: LomiriColors.lightGrey
                   border.width:units.gu(1)

                   Label {
                       anchors.horizontalCenter: wrapper.Center
                       id: legendEntry
                       text: "<b>"+sub_cat_name+"</b> :  "+current_amount +" <i>"+currency+ "</i>"
                   }
               }
           }
       }
   }

}
