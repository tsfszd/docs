using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class Subscriber : EntityBase
    {

        #region Private Properties
        int _subscriberid;


        #endregion

        #region Public Properties

        [DataMember]
        public int subscriberid
        {
            get { return _subscriberid; }
            set { _subscriberid = value; }
        }

        #endregion

        #region Constructors

        public Subscriber()
        {

        }

        #endregion
        
        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
