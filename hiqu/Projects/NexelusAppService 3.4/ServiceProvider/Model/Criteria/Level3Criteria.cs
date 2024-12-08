using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;

namespace NexelusApp.Service.Model.Criteria
{
    [DataContract(Name = "Level3Criteria", Namespace = "")]
    public class Level3Criteria<T> : CriteriaBase<T> where T: Level3, new()
    {

        #region Private Properties

        private string _SearchString;
        private string _Level2Key;
        private string _CustomerCode;
        private string _ResourceID;
        private int _Mode = default(int);
        private int _source = default(int);


        #endregion

        #region Public Properties

        [DataMember]
        public string SearchString
        {
            get { return _SearchString; }
            set { _SearchString = value; }
        }

        [DataMember]
        public string CustomerCode
        {
            get { return _CustomerCode; }
            set { _CustomerCode = value; }
        }

        [DataMember]
        public string Level2Key
        {
            get { return _Level2Key; }
            set { _Level2Key = value; }
        }
        [DataMember]
        public string ResourceID
        {
            get { return _ResourceID; }
            set { _ResourceID = value; }
        }
        [DataMember]
        public int Mode
        {
            get { return _Mode; }
            set { _Mode = value; }
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
