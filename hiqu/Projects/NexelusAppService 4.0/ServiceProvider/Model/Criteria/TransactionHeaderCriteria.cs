using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "TransactionHeaderCriteria", Namespace = "")]
    public class TransactionHeaderCriteria<T> : CriteriaBase<T> where T : TransactionHeader, new()
    {
        #region Private Properties

        private string _transaction_id;
        private string _report_name;
        private string _resource_id;
        private string _record_id;
        private string _re_approval_flag;

        #endregion

        #region Public Properties

        [DataMember]
        public string transaction_id
        {
            get { return _transaction_id; }
            set { _transaction_id = value; }
        }
        [DataMember]
        public string report_name
        {
            get { return _report_name; }
            set { _report_name = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _resource_id; }
            set { _resource_id = value; }
        }
        [DataMember]
        public string record_id
        {
            get { return _record_id; }
            set { _record_id = value; }
        }
        [DataMember]
        public string re_approval_flag
        {
            get { return _re_approval_flag; }
            set { _re_approval_flag = value; }
        }

        #endregion
    }
}
