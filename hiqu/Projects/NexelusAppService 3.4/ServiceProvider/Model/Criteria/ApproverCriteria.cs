using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "ApproverCriteria", Namespace = "")]
    public class ApproverCriteria<T> : CriteriaBase<T> where T : Approver, new()
    {
        private string _resource_id;

        [DataMember]
        public string ResourceID
        {
            get { return _resource_id; }
            set { _resource_id = value; }
        }
    }
}
