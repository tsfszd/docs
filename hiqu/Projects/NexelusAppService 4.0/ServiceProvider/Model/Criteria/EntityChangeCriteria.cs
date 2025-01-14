using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;


namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "EntityChangeCriteria", Namespace = "")]
    public class EntityChangeCriteria<T> : CriteriaBase<T> where T : EntityChange, new()
    {
        private string _ResourceID;
        private List<int> _EntityChangeList;

        [DataMember]
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }
        [DataMember]
        public List<int> EntityChangeList
        {
            get { return _EntityChangeList; }
            set { _EntityChangeList = value; }
        }
    }
}
