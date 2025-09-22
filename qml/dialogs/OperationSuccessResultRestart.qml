import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3


/* Notify an operation executed successfully and notify that a Restart is required*/
Dialog {
    id: operationSuccessRestartDialog
    title: i18n.tr("Operation Result")

    Label{
        text: i18n.tr("Operation executed successfully")+": <br/> "+i18n.tr("PLEASE, A RESTART IS REQUIRED")
        color: LomiriColors.green
    }

    Button {
        text: "Close"
        onClicked:
            PopupUtils.close(operationSuccessRestartDialog)
    }
}
