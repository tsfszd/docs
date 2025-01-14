using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "MultiCurrrencyRateTypeHeaderCriteria", Namespace = "")]
    public class MultiCurrencyRateTypeHeaderCriteria<T> : CriteriaBase<T> where T : MultiCurrencyRateTypeHeader, new()
    {
        #region Private Properties

        private string _mc_rate_type;        
        private int _active_flag;

        #endregion

        #region Public Properties


        [DataMember]
        public string mc_rate_type
        {
            get { return _mc_rate_type; }
            set { _mc_rate_type = value; }
        }
        [DataMember]
        public int active_flag
        {
            get { return _active_flag; }
            set { _active_flag = value; }
        }

        #endregion

    }
}
