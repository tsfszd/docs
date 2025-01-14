using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using NexelusApp.Service.Model;

using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.Exceptions;


namespace NexelusApp.Service.DataAccess.DAOs
{
    /// <summary>
    /// Base DAO class responsible to interact with the data access layer and 
    /// contains all reusable logic for DAO objects
    /// </summary>
    /// <typeparam name="T">Entity</typeparam>
    public abstract class DAOBase<T> : IDAO<T> where T : EntityBase, new()
    {
        private NexContext _Context = null;
        private DataContext<T> _DbContext = null;

        /// <summary>
        /// Data Access layer
        /// </summary>
        protected DataContext<T> DbContext
        {
            get { return _DbContext; }
        }

        /// <summary>
        /// Application context 
        /// </summary>
        protected NexContext Context
        {
            get { return _Context; }
        }

        /// <summary>
        /// DAO constructor takes Application context
        /// </summary>
        /// <param name="ctx"></param>
        public DAOBase(NexContext ctx)
        {
            _Context = ctx;

            //create the Data Context object 
            _DbContext = new DataContext<T>(ctx);

        }


        /// <summary>
        /// Abstract method to pouploate the respecrive entity from a reader
        /// </summary>
        /// <param name="objEntity"></param>
        /// <param name="dataReader"></param>
        public abstract void PopulateEntityFromReader(T objEntity, IDataReader dataReader);

        /// <summary>
        /// Select the list of entities based on passing criteria
        /// </summary>
        /// <param name="criteria">Filter criteria</param>
        /// <returns>List of Entities</returns>
        public abstract List<T> Select(CriteriaBase<T> criteria);

        /// <summary>
        /// Select all entities
        /// </summary>
        /// <returns>List of Entities</returns>
        public List<T> Select()
        {
            return Select(null);
        }


        public abstract bool Save(T entity);


        /// <summary>
        /// Delete Entities based on filter criteria
        /// </summary>
        /// <param name="criteria">Filter criteria</param>
        /// <returns>true/false</returns>
        public abstract bool Delete(CriteriaBase<T> criteria);

        /// <summary>
        /// Delete Entities based on filter criteria
        /// </summary>
        /// <returns>true/false</returns>
        public bool Delete()
        {
            return Delete(null);
        }

        /// <summary>
        /// Save and Gets the entities
        /// </summary>
        /// <param name="criteria">List of Entities</param>
        /// <returns>List of Entities</returns>

        public virtual List<T> SaveAndGet(List<T> Entities)
        {
            return new List<T>();
        }
    }
}
