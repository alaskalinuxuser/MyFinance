import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3

/* Notify an operation failed */
Dialog {

    id: invalidInputDialog
    title: i18n.tr("Operation Result")

    Label{
        text: i18n.tr("Invalid input value(s)")
        color: LomiriColors.red
    }

    Button {
        text: i18n.tr("Close")
        onClicked:
            PopupUtils.close(invalidInputDialog)
    }
}
