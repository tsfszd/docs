using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "TaskCriteria", Namespace = "")]
    public class TaskCriteria<T> : CriteriaBase<T> where T : Task, new()
    {
        [DataMember]
        public string TaskCode { get; set; }
    }
}
