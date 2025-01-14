using NexelusApp.Service.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "LoginInfoCriteria", Namespace = "")]
    public class LoginInfoCriteria<T> : CriteriaBase<T> where T : LoginInfo, new()
    {
        [DataMember]
        public string SourceField { get; set; }
        [DataMember]
        public string MappedField { get; set; }
    }
}
