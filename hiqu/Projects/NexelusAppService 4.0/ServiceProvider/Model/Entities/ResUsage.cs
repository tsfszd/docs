using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class ResUsage : EntityBase
    {

        #region Private Properties

        private string _ResUsageCode = "";
        private string _ResUsageDescription = "";

        #endregion
        
        #region Public Properties

        [DataMember]
        public string ResUsageCode
        {
            get { return _ResUsageCode; }
            set { _ResUsageCode = value; }
        }
        [DataMember]
        public string ResUsageDescription
        {
            get { return _ResUsageDescription; }
            set { _ResUsageDescription = value; }
        }

        #endregion

        #region Constructors

        public ResUsage()
        {

        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
