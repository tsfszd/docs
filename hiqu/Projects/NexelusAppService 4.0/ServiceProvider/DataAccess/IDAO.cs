using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;


namespace NexelusApp.Service.DataAccess
{
    public interface IDAO<T> : IRepository<T> where T : EntityBase, new()
    {
        /// <summary>
        /// To pouploate the respecrive entity from a reader
        /// </summary>
        /// <param name="objEntity"></param>
        /// <param name="dataReader"></param>
        void PopulateEntityFromReader(T objEntity, IDataReader dataReader);
    }
}
