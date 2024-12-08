using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "MultiCurrencyRatesTypeDetailCriteria", Namespace = "")]
    public class MultiCurrencyRatesTypeDetailCriteria<T> : CriteriaBase<T> where T : MultiCurrencyRateTypeDetail, new()
    {
        #region Private Properties

        private string _rate_type;        
        private string _efective_date;        
        private int _Rate_id;
        private string _toCurrency;
        
        #endregion

        #region Public Properties

        [DataMember]
        public string ToCurrency
        {
            get { return _toCurrency; }
            set { _toCurrency = value; }
        }

        [DataMember]
        public string rate_type
        {
            get { return _rate_type; }
            set { _rate_type = value; }
        }
        [DataMember]
        public string efective_date
        {
            get { return _efective_date; }
            set { _efective_date = value; }
        }
        [DataMember]
        public int Rate_id
        {
            get { return _Rate_id; }
            set { _Rate_id = value; }
        }

        #endregion
    }
}
