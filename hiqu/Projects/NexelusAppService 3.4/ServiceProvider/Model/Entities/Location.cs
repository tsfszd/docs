using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class Location : EntityBase
    {

        #region Private Properties

        private string _LocationCode;
        private string _LocationName; 

        #endregion

        #region Public Properties
        
        [DataMember]
        public string LocationCode
        {
            get { return _LocationCode; }
            set { _LocationCode = value; }
        }
        [DataMember]
        public string LocationName
        {
            get { return _LocationName; }
            set { _LocationName = value; }
        }

        #endregion

        #region Constructors

        public Location()
        {

        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
