import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Components.Pickers 1.3
import Lomiri.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Lomiri.Components.ListItems 1.3 as ListItem


//---------------------- Help page ----------------------
Page {
     id: helpPage

     header: PageHeader {
        title: i18n.tr("Help Page")
     }

     Layouts {
         id: layoutHelpPage
         width: parent.width
         height: parent.height
         layouts:[

             ConditionalLayout {
                 name: "helpPageLayout"
                 when: root.width > units.gu(120)
                     HelpPageTablet{}
             }
         ]
         //else
         HelpPagePhone{}
     }
}
//--------------------------------------------------------
