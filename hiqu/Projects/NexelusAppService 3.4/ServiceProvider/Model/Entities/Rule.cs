using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class Rule : EntityBase
    {
        #region Private Properties

        private string _ResourceId;
        private string _DefaultCode;

        #endregion

        #region Public Properties

        [DataMember]
        public string ResourceId
        {
            get { return _ResourceId; }
            set { _ResourceId = value; }
        }
        [DataMember]
        public string DefaultCode
        {
            get { return _DefaultCode; }
            set { _DefaultCode = value; }
        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
