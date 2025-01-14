using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "NotificationCriteria", Namespace = "")]
    public class NotificationCriteria<T> : CriteriaBase<T> where T : Notification, new()
    {

        #region Private Properties

        private string _ResourceID;
        private string _Mode = "";
        private string _NotificationID = "";

        #endregion

        #region Public Properties

        [DataMember]
        public string NotificationID
        {
            get { return _NotificationID; }
            set { _NotificationID = value; }
        }

        [DataMember]
        public string Mode
        {
            get { return _Mode; }
            set { _Mode = value; }
        }

        [DataMember]
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }

        #endregion

    }
}
