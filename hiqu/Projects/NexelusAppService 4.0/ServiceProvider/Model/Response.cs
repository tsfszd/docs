using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Enums;

namespace NexelusApp.Service.Model
{
    [DataContract]
    public class Response<T> where T : EntityBase, new()
    {

        #region Private Properties

        private string _Message;
        private List<T> _Entities;
        private string _SyncDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");        
        private ResponseType _ResponseType; 

        #endregion

        #region Public Properties

        [DataMember]
        public string Message
        {
            get { return _Message; }
            set { _Message = value; }
        }
        [DataMember]
        public List<T> Entities
        {
            get { return _Entities; }
            set { _Entities = value; }
        }
        [DataMember]
        public ResponseType ResponseType
        {
            get { return _ResponseType; }
            set { _ResponseType = value; }
        }
        [DataMember]
        public string SyncDate
        {
            get { return _SyncDate; }
            set { _SyncDate = value; }
        }

        #endregion

        #region Constructors

        public Response()
        {
            Entities = new List<T>();            
        }

        #endregion

    }
}
