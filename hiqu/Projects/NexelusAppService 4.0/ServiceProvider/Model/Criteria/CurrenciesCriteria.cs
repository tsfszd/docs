using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NexelusApp.Service.Model.Entities;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "CurrenciesCriteria", Namespace = "")]
    public class CurrenciesCriteria<T> : CriteriaBase<T> where T : Currencies, new()
    {
        #region Private Properties

        private int _currency_code;
        private int _status_flag;

        #endregion

        #region Public Properties

        [DataMember]
        public int currency_code
        {
            get { return _currency_code; }
            set { _currency_code = value; }
        }
        [DataMember]
        public int status_flag
        {
            get { return _status_flag; }
            set { _status_flag = value; }
        }

        #endregion
    }
}
