import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3


Dialog {

    id: operationFailNewExpenseDialog
    title: i18n.tr("Operation Result")
    contentWidth: units.gu(42) /* the width of the Dialog */

    Label{
        anchors.horizontalCenter: operationFailNewExpenseDialog.Center
        text: i18n.tr("Missing required value, or invalid 'Amount'")+" <br/><b> "+i18n.tr("Note: decimal separator is . ")+"</b>"
        color: LomiriColors.red
    }

    Button {
        text: "Close"
        onClicked:
            PopupUtils.close(operationFailNewExpenseDialog)
    }
}
