using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class LoginInfo : EntityBase
    {
        #region PROPERTIES
        [DataMember]
        public string SourceField { get; set; }
        [DataMember]
        public string MappedField { get; set; }
        [DataMember]
        public string LoginId { get; set; }
        [DataMember]
        public string ResourceId { get; set; }
        [DataMember]
        public string ResPassword { get; set; }
        #endregion
        #region CONSTRUNCTORS
        public LoginInfo() { }
        #endregion
        #region METHODS
        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
        #endregion
    }
}
