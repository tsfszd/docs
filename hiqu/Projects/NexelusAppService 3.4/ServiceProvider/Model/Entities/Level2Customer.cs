using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

namespace NexelusApp.Service.Model.Entities
{
    [DataContract]
    public class Level2Customer : EntityBase
    {
        #region Private Properties

        private string _CustomerCode = "";
        private string _CusomterName = "";
        private string _Level2Key = "";

        #endregion

        #region Public Properties

        [DataMember]
        public string CustomerCode
        {
            get { return _CustomerCode; }
            set { _CustomerCode = value; }
        }
        [DataMember]
        public string CusomterName
        {
            get { return _CusomterName; }
            set { _CusomterName = value; }
        }
        [DataMember]
        public string Level2Key
        {
            get { return _Level2Key; }
            set { _Level2Key = value; }
        }

        #endregion

        #region Constructors

        public Level2Customer()
        {

        }

        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
