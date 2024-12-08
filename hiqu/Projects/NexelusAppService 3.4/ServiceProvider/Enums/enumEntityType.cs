using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.Enums
{
    public enum enumEntityType
    {
        // All the entities goes here.
        Level2 = 1,
        Level2Customer,
        Level3,
        TransactionHeader,
        ExpenseTransaction,
        TransactionExpense,
        Transaction,

        CostCodes,
        Approver,
        ExpenseReportFields,
        ExpenseReportRates,
        MultiCurrencyRateTypeDetail,
        MultiCurrencyRateTypeHeader,
        Currencies,
        ResourceType
    }
}
