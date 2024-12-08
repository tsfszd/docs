using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Text;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class CompanyAuthentication : EntityBase
    {
        #region PROPERTIES
        [DataMember]
        public string AuthKey { get; set; }
        [DataMember]
        public string AuthMode { get; set; }
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
        [DataMember]
        public string ApiToken { get; set; }
        [DataMember]
        public string ClientCode { get; set; }
        [DataMember]
        public string ClientSecret { get; set; }
        [DataMember]
        public string BaseUrl { get; set; }
        [DataMember]
        public string OktaRedirectUrl { get; set; }
        [DataMember]
        public string authServerId { get; set; }
        #endregion
        #region CONSTRUNCTORS
        public CompanyAuthentication() { }
        #endregion
        #region METHODS
        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
        #endregion
    }
}
