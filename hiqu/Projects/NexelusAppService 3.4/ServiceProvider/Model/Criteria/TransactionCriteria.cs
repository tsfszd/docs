using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "TransactionCriteria", Namespace = "")]
    public class TransactionCriteria<T> : CriteriaBase<T> where T : Transaction, new()
    {

        #region Private Properties

        private string _ResourceID;
        private DateTime _StartDate = default(DateTime);
        private DateTime _EndDate = default(DateTime);
        private string _TransactionID = "";
        private string notificationId = string.Empty;

        

        #endregion

        #region Public Properties

        [DataMember]
        public string TransactionID
        {
            get { return _TransactionID; }
            set { _TransactionID = value; }
        }

        [DataMember]
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }
        [DataMember]
        public DateTime StartDate
        {
            get { return _StartDate ; }
            set { _StartDate = value ; }
        }
        [DataMember]
        public DateTime EndDate
        {
            get { return _EndDate ; }
            set { _EndDate = value ; }
        }
        [DataMember]
        public string NotificationID
        {
            get { return notificationId; }
            set { notificationId = value; }
        }
        #endregion

    }
}
