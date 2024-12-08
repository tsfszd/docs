using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class SysNames : EntityBase
    {

        #region Private Properties

        private string _FieldName = "";
        private string _DisplayName = "";

        #endregion

        #region public Properties

        [DataMember]
        public string FieldName
        {
            get { return _FieldName; }
            set { _FieldName = value; }
        }
        [DataMember]
        public string DisplayName
        {
            get { return _DisplayName; }
            set { _DisplayName = value; }
        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
