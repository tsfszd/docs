using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using com.paradigm.esm.general;
using System.Globalization;
using System.Collections;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class Approver : EntityBase
    {
        #region Private Properties

        private string _ResourceId;
        private string _NameLast;
        private string _NameFirst;

        #endregion

        #region Public Properties

        [DataMember]
        public string name_first
        {
            get { return _NameFirst; }
            set { _NameFirst = value; }
        }
        [DataMember]
        public string name_last
        {
            get { return _NameLast; }
            set { _NameLast = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _ResourceId; }
            set { _ResourceId = value; }
        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
