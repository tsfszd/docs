using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "CostCodeCriteria", Namespace = "")]
    public class CostCodeCriteria<T> : CriteriaBase<T> where T : CostCodes, new()
    {

        #region Private Properties

        private int _cost_type;
        private string _res_category_code;
        private int _res_type;
        private string _effective_date;

        #endregion

        #region Public Properties

        [DataMember]
        public int cost_type
        {
            get { return _cost_type; }
            set { _cost_type = value; }
        }
        [DataMember]
        public string res_category_code
        {
            get { return _res_category_code; }
            set { _res_category_code = value; }
        }
        [DataMember]
        public int res_type
        {
            get { return _res_type; }
            set { _res_type = value; }
        }
        [DataMember]
        public string effective_date
        {
            get { return _effective_date; }
            set { _effective_date = value; }
        }

        #endregion
    }
}
