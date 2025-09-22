import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3


Dialog {
    id: operationResult
    title: i18n.tr("Operation Result")
    text: i18n.tr("No Data Found")+" !"
    Button {
        text: "Close"
        onClicked: PopupUtils.close(operationResult)
    }
}
