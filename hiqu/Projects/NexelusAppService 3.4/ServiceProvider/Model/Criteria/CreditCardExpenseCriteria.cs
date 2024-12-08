using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "CreditCardExpenseCriteria", Namespace = "")]
    public class CreditCardExpenseCriteria<T> : CriteriaBase<T> where T : CreditCardExpense, new()
    {
        #region Private Properties

        private string _resource_id;
        private int _cc_exp_id;
        private string _record_id;
        private string _applied_date;
        private int _split_flag;        
        private int _company_or_personal_flag;        
        private int _cc_type_id;

        #endregion

        #region Public Properties

        [DataMember]
        public string ResourceID
        {
            get { return _resource_id; }
            set { _resource_id = value; }
        }
        [DataMember]
        public int cc_exp_id
        {
            get { return _cc_exp_id; }
            set { _cc_exp_id = value; }
        }
        [DataMember]
        public string record_id
        {
            get { return _record_id; }
            set { _record_id = value; }
        }
        [DataMember]
        public string applied_date
        {
            get { return _applied_date; }
            set { _applied_date = value; }
        }
        [DataMember]
        public int split_flag
        {
            get { return _split_flag; }
            set { _split_flag = value; }
        }
        [DataMember]
        public int company_or_personal_flag
        {
            get { return _company_or_personal_flag; }
            set { _company_or_personal_flag = value; }
        }
        [DataMember]
        public int cc_type_id
        {
            get { return _cc_type_id; }
            set { _cc_type_id = value; }
        }

        #endregion
    
    }
}
