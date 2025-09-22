import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3


/* Notify an operation executed successfully */
Dialog {
    id: operationSuccessDialog
    /* the message to display (See AddCategoryXXX.qml)  */
    property string msg;
    title: i18n.tr("Operation Result")

    Label{
        text: i18n.tr("OK")+": "+msg
        color: LomiriColors.green
    }

    Button {
        text: i18n.tr("Close")
        onClicked:
            PopupUtils.close(operationSuccessDialog)
    }
}
