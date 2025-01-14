using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using NexelusApp.Service.Model.Entities;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "UserSettingCriteria", Namespace = "")]
    public class UserSettingCriteria<T> : CriteriaBase<T> where T : UserSetting, new()
    {
        #region Private Members

        private string _ResourceID;

        #endregion

        #region Public Members

        [DataMember]
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }

        #endregion
    }
}
