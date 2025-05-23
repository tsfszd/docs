﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "ExpenseReportAttachmentCriteria", Namespace = "")]
    public class ExpenseReportAttachmentCriteria<T> : CriteriaBase<T> where T : ExpenseReportAttachment, new()
    {

        #region Private Properties

        private string _ResourceId;
        private string _RecordId;

        #endregion

        #region Public Properties

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

        #endregion

    }
}
