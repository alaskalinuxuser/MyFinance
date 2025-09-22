import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3

/* to replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import "./js/storage.js" as Storage


/* Show a Dialog where the user can choose to delete ALL the saved expense */
Dialog {
        id: dataBaseEraserDialog
        text: "<b>"+ i18n.tr("Remove ALL Database Contents")+" ?"+"<br/>"+i18n.tr("(there is no restore)")+"</b>"

        Row{
           anchors.horizontalCenter: parent.horizontalCenter
           Label{
                id: deleteOperationResult
                text: " "
           }
        }

        Row{
              //x: dataBaseEraserDialog.width/10
              anchors.horizontalCenter: dataBaseEraserDialog.Center
              spacing: units.gu(1)

              Button {
                    id: closeButton
                    text: i18n.tr("Close")
                    width: units.gu(14)
                    onClicked: PopupUtils.close(dataBaseEraserDialog)
              }

              Button {
                    id: importButton
                    text: i18n.tr("Delete")
                    width: units.gu(14)
                    color: LomiriColors.red
                    onClicked: {
                          loadingPageActivity.running = true
                          Storage.cleanAllDatabase();

                          deleteOperationResult.text = i18n.tr("Succesfully Removed ALL data")
                          deleteOperationResult.color = LomiriColors.green
                          closeButton.enabled = true

                          /* blank settings flag that notify default data already imported.
                             So that the user can import them again with the option in
                             the configuration page.
                          */
                          settings.defaultDataAlreadyImported = false

                          Storage.getAllCategory(); //refresh ListModel
                          adaptivePageLayout.removePages(Qt.resolvedUrl("./pages/CategoryExpensePage.qml"))
                          adaptivePageLayout.removePages(Qt.resolvedUrl("./pages/ConfigurationPage.qml"))

                          loadingPageActivity.running = false
                    }
                }
          }
    }
