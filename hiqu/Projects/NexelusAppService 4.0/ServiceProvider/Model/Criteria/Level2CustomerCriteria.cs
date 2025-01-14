using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "Level2CustomerCriteria", Namespace = "")]
    class Level2CustomerCriteria<T> : CriteriaBase<T> where T : Level2Customer, new()
    {
        private string _CustomerCode;
        private string _Level2Key;

        [DataMember]
        public string CustomerCode
        {
            get { return _CustomerCode; }
            set { _CustomerCode = value; }
        }

        [DataMember]
        public string Level2Key
        {
            get { return _Level2Key; }
            set { _Level2Key = value; }
        }
    }
}
