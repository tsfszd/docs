using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using com.paradigm.esm.general;
using System.Globalization;
using System.Collections;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class ExpenseReport : EntityBase
    {
        #region Private Properties

        private TransactionHeader _TrxHeader;
        private List<ExpenseTransaction> _ExpTransactions;

        #endregion

        #region Public Properties

        [DataMember]
        public TransactionHeader TransactionHdr
        {
            get { return _TrxHeader; }
            set { _TrxHeader = value; }
        }
        [DataMember]
        public List<ExpenseTransaction> ExpTransactions
        {
            get { return _ExpTransactions; }
            set { _ExpTransactions = value; }
        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
