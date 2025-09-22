import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Components.Pickers 1.3
import Lomiri.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Lomiri.Components.ListItems 1.3 as ListItem

import "../js/utility.js" as Utility
import "../js/categoryUtils.js" as CategoryUtils
import "../js/storage.js" as Storage
import "../js/subCategoryReportChart.js" as SubCategoryReportChart

/* import folder */
import "../dialogs"
import "./util"


/*
  Global Report Page: show reports for all the saved Category
*/
Page {
     id: globalReportPage

     header: PageHeader {
        title: i18n.tr("Category Global Report")
     }

     Layouts {
         id: layoutGlobalReportPage
         width: parent.width
         height: parent.height
         layouts:[

             ConditionalLayout {
                 name: "layoutsConfiguration"
                 when: root.width > units.gu(120)
                     GlobalReportTablet{}
             }
         ]
         //else
         GlobalReportPhone{}
     }
}
