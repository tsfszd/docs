
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "TransactionExpenseCriteria", Namespace = "")]
    public class TransactionExpenseCriteria<T> : CriteriaBase<T> where T : TransactionExpense, new()
    {

        #region Private Properties

        private string _TransactionId;
        private string _RecordId;
        private string _ResourceId;

        #endregion

        #region Public Properties

        [DataMember]
        public string record_id
        {
            get { return _RecordId; }
            set { _RecordId = value; }
        }
        [DataMember]
        public string transaction_id
        {
            get { return _TransactionId; }
            set { _TransactionId = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _ResourceId; }
            set { _ResourceId = value; }
        }

        #endregion
    }
}
