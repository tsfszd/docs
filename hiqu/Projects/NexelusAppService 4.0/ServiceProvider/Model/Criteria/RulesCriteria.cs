using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "RulesCriteria", Namespace = "")]
    public class RulesCriteria<T> : CriteriaBase<T> where T : Rules, new()
    {
        #region Private Properties

        private int _id;
        private int _is_customfields_by_expansegroup;
        private string _resource_id;        

        #endregion

        #region Public Properties

        [DataMember]
        public int id
        {
            get { return _id; }
            set { _id = value; }
        }
        [DataMember]
        public int is_customfields_by_expansegroup
        {
            get { return _is_customfields_by_expansegroup; }
            set { _is_customfields_by_expansegroup = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _resource_id; }
            set { _resource_id = value; }
        }

        #endregion
    }
}
