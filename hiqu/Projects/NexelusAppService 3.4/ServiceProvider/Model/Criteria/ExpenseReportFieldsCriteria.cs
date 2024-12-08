using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "ExpenseReportFieldsCriteria", Namespace = "")]
    public class ExpenseReportFieldsCriteria<T> : CriteriaBase<T> where T : ExpenseReportFields, new()
    {
        #region Private Properties

        private int _cost_type;        
        private int _res_type;

        #endregion

        #region Public Properties

        [DataMember]
        public int cost_type
        {
            get { return _cost_type; }
            set { _cost_type = value; }
        }
        [DataMember]
        public int res_type
        {
            get { return _res_type; }
            set { _res_type = value; }
        }

        #endregion
    }
}
