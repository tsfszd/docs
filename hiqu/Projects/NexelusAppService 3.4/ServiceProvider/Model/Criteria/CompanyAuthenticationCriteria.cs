using NexelusApp.Service.Model.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "CompanyAuthenticationCriteria", Namespace = "")]
    public class CompanyAuthenticationCriteria<T> : CriteriaBase<T> where T : CompanyAuthentication, new()
    {
        [DataMember]
        public string AuthenticationKey { get; set; }
    }
}
