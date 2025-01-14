using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "ExpenseTransactionCriteria", Namespace = "")]
    public class ExpenseTransactionCriteria<T> : CriteriaBase<T> where T : ExpenseTransaction, new()
    {
        #region Private Properties

        private string _ResourceId;
        private string _RecordId;
        private string _TransactionId;
        private string _LoginId;
        private bool _isFromHeader;

        #endregion

        #region Public Properties

        [DataMember]
        public string LoginID
        {
            get { return _LoginId; }
            set { _LoginId = value; }
        }

        [DataMember]
        public string transaction_id
        {
            get { return _TransactionId; }
            set { _TransactionId = value; }
        }
        [DataMember]
        public string record_id
        {
            get { return _RecordId; }
            set { _RecordId = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _ResourceId; }
            set { _ResourceId = value; }
        }

        public bool IsFromHeader
        {
            get { return _isFromHeader; }
            set { _isFromHeader = value; }
        }

        #endregion

    }
}
