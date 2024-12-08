using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class OrgUnit : EntityBase
    {

        #region Private Properties

        private string _OrgUnitCode = "";
        private string _OrgUnitName = "";
        private string _OrgUnitDescription = "";

        #endregion

        #region Public Properties

        [DataMember]
        public string OrgUnitCode
        {
            get { return _OrgUnitCode; }
            set { _OrgUnitCode = value; }
        }
        [DataMember]
        public string OrgUnitName
        {
            get { return _OrgUnitName; }
            set { _OrgUnitName = value; }
        }
        [DataMember]
        public string OrgUnitDescription
        {
            get { return _OrgUnitDescription; }
            set { _OrgUnitDescription = value; }
        }

        #endregion

        #region Constructors

        public OrgUnit()
        {

        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
