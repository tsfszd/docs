using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class RulesChild : EntityBase
    {
        [DataMember]
        public int id { get; set; }
        [DataMember]
        public string path { get; set; }
        [DataMember]
        public string code { get; set; }
        [DataMember]
        public string value { get; set; }

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
