import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3


/* Notify an operation failed showing the provided message from the caller */
Dialog {
    /* the message to display (See AddCategoryXXX.qml)  */
    property string msg;

    id: operationFailNewSubCategoryDialog
    title: i18n.tr("Operation Result")
    contentWidth: units.gu(42)  /* the width of the Dialog */

    Label{
        text: i18n.tr("Attention")+": "+msg
        color: LomiriColors.red
    }

    Button {
        text: i18n.tr("Close")
        onClicked:
            PopupUtils.close(operationFailNewSubCategoryDialog)
    }
}
