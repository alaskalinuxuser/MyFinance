import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import Lomiri.Components.Pickers 1.3
import Lomiri.Layouts 1.0

/* replace the 'incomplete' QML API U1db with the low-level QtQuick API */
import QtQuick.LocalStorage 2.0
import Lomiri.Components.ListItems 1.3 as ListItem

/* note: alias name must have first letter in upperCase */
import "../../js/utility.js" as Utility
import "../../js/categoryUtils.js" as CategoryUtils
import "../../js/storage.js" as Storage

Component {
    id: expenseFoundDelegate

    Item {
        id: expenseFoundItem
        width: findExpensePage.width
        height: units.gu(13) /* the heigth of the rectangle that contains an expense in the list */

        /* container for each expense */
        Rectangle {
            id: background
            x: 2;
            y: 2;
            width: parent.width - x*2;
            height: parent.height - y*1
            border.color: "black"
            radius: 5
            /* to get the background color of the curreunt theme. Necessary if default theme is not used */
            color: theme.palette.normal.background
        }

        Component {
            id: confirmDeleteExpenseComponent
            /* Ask a confirmation before Delete an Expense already saved in the database */
            Dialog {
                id: confirmDeleteExpense
                title: i18n.tr("Confirmation")
                modal:true
                text: i18n.tr("Delete selected Expense")+" ?"

                Label{
                    id: deleteSuccessLabel
                    text: ""
                    color: LomiriColors.green
                }

                Button {
                    text: i18n.tr("Close")
                    onClicked: PopupUtils.close(confirmDeleteExpense)
                }

                Button {
                    id:executeButton
                    text: i18n.tr("Delete")
                    color: LomiriColors.red

                    //signal send()
                    //onSend: console.log("Send clicked")

                    onClicked: {

                        /* Before removing the expense is necessary update the expesnes report tables */

                        /* retrieve values from the ListModel */
                        var subCategoryName = expenseModel.get(expenseSearchResultList.currentIndex).sub_cat_name;
                        var expenseAmount = expenseModel.get(expenseSearchResultList.currentIndex).amount;
                        var expsenseId = expenseModel.get(expenseSearchResultList.currentIndex).id;

                        var idSubCategory = Storage.getSubCategoryIdByName(subCategoryName);

                        /* to remove amount set it to negative */
                        var amountToRemove = -1 * expenseAmount;

                        //console.log('AMOUNT to remove:'+amountToRemove +' for idSubCategory: '+idSubCategory+ ' and expenseId: '+expsenseId);

                        /* update the current report tables: increase or decrease, depending on the 'diffAmount' value */
                        Storage.updateCategoryReportCurrentAmount(findExpensePage.categoryId, amountToRemove);
                        Storage.updateSubCategoryReportCurrentAmount(idSubCategory, amountToRemove);
                        Storage.deleteExpenseById(expsenseId);

                        /* refresh category list and their amount */
                        Storage.getAllCategory();

                        /* send a signal to refresh expense list after deletion: https://developer.ubuntu.com/api/apps/qml/sdk-15.04/QtQml.qtqml-syntax-signals/ */
                        //searchExpenseButton.clicked.connect(send);

                        deleteSuccessLabel.text = i18n.tr("OK: Done, Reload the expense List")
                        executeButton.enabled = false;
                    }
                }
            }
       }

        /* This mouse region covers the entire delegate */
        MouseArea {
            id: selectableMouseArea
            anchors.fill: parent
            onClicked: {
                /* move the highlight component to the currently selected item */
                expenseSearchResultList.currentIndex = index
            }
        }

        /* create a row for each entry in the Model */
        Row {
            id: topLayout
            x: 10;
            y: 10;
            height: background.height;
            width: parent.width
            spacing: units.gu(0.5)

            Column {
                width: background.width - 20 - editExpenseColumn.width;
                height: expenseFoundItem.height
                spacing: units.gu(0.2)

                Label {
                    text: "<b>"+i18n.tr("Amount")+ ": </b>"+ amount + " "+findExpensePage.currency
                    fontSize: "medium"
                }

                Label {
                    text: "<b>"+i18n.tr("Date")+ "(yyyy-mm-dd): </b>"+date
                    fontSize: "medium"
                }

                Label {
                    text: "<b>"+i18n.tr("Note")+": </b>"+note
                    fontSize: "medium"
                }

                Label {
                    text: "<b>"+i18n.tr("Category")+": </b>"+cat_name
                    fontSize: "medium"
                }

                Label {
                    text: "<b>"+i18n.tr("SubCategory")+": </b>"+ sub_cat_name
                    fontSize: "medium"
                }
            }

            Column{
                id: editExpenseColumn
                width: units.gu(10)
                anchors.verticalCenter: topLayout.verticalCenter
                spacing: units.gu(1)

                Row{
                    /* note: use Icon Object insted of Image to access at sytem default icon without specify a full path to image */
                    Icon {
                        id: editExpenseIcon
                        width: units.gu(4)
                        height: units.gu(4)
                        name: "edit"

                        MouseArea {
                            width: editExpenseIcon.width
                            height: editExpenseIcon.height
                            onClicked: {
                                adaptivePageLayout.addPageToNextColumn(findExpensePage, Qt.resolvedUrl("../EditExpensePage.qml"),
                                                                       {
                                                                         /* <page-variable-name>:<property-value-to-pass> */
                                                                         categoryId:categoryId,
                                                                         categoryName:cat_name,
                                                                         expenseId: id, //findExpensePage.categoryId,
                                                                         currentSubCategory:sub_cat_name,
                                                                         currentAmount:amount,
                                                                         currentNote: note,
                                                                         currentDate: date
                                                                        }
                                                                       )

                             }
                        }

                    }
                }

                Row{
                    Icon {
                         id: deleteExpenseIcon
                         width: units.gu(4)
                         height: units.gu(4)
                         name: "delete"

                         MouseArea {
                              width: deleteExpenseIcon.width
                              height: deleteExpenseIcon.height
                              onClicked: {
                                    PopupUtils.open(confirmDeleteExpenseComponent);
                              }
                         }
                      }
                 }

            }
        }
    }

}
