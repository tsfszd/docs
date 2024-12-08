using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "Level2Criteria", Namespace = "")]
    public class Level2Criteria<T> : CriteriaBase<T> where T : Level2, new()
    {

        #region Private Properties

        private string _CustomerCode;
        private string _SearchString;
        private int _Mode = default(int);
        private string _ResourceID;
        private int _source = default(int);


        #endregion

        #region Public Properties

        [DataMember]
        public string CustomerCode
        {
            get { return _CustomerCode; }
            set { _CustomerCode = value; }
        }
        [DataMember]
        public string SearchString
        {
            get { return _SearchString; }
            set { _SearchString = value; }
        }
        [DataMember]
        public int Mode
        {
            get { return _Mode; }
            set { _Mode = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }
        [DataMember]
        public int source
        {
            get { return _source; }
            set { _source = value; }
        }

        #endregion

    }
}
