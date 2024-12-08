using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.DataAccess.DAOs;

namespace NexelusApp.Service.DataAccess
{

    /// <summary>
    /// Data Repository 
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class Repository<T> : IRepository<T> where T : EntityBase, new()
    {
        private NexContext _Context = null;

        protected NexContext Context
        {
            get { return _Context; }
        }

        public Repository(NexContext ctx)
        {
            _Context = ctx;
        }

        /// <summary>
        /// Select the list of entities based on passing criteria
        /// </summary>
        /// <param name="criteria">Filter criteria</param>
        /// <returns>List of Entities</returns>
        public List<T> Select(CriteriaBase<T> criteria)
        {
            DAOBase<T> objDAO = DAOFactory<T>.GetDAO(this.Context);
            List<T> result = objDAO.Select(criteria);

            return result;
        }

        /// <summary>
        /// Select all entities
        /// </summary>
        /// <returns>List of Entities</returns>
        public List<T> Select()
        {
            DAOBase<T> objDAO = DAOFactory<T>.GetDAO(this.Context);
            List<T> result = objDAO.Select();
         
            return result;
        }


        public bool Save(T entity)
        {
            DAOBase<T> objDAO = DAOFactory<T>.GetDAO(this.Context);
            return objDAO.Save(entity);
        }

        /// <summary>
        /// Delete Entities based on filter criteria
        /// </summary>
        /// <param name="criteria">Filter criteria</param>
        /// <returns>true/false</returns>
        public bool Delete(CriteriaBase<T> criteria)
        {
            DAOBase<T> objDAO = DAOFactory<T>.GetDAO(this.Context);
            return objDAO.Delete(criteria);
        }

        /// <summary>
        /// Delete Entities based on filter criteria
        /// </summary>
        /// <returns>true/false</returns>
        public bool Delete()
        {
            DAOBase<T> objDAO = DAOFactory<T>.GetDAO(this.Context);
            return objDAO.Delete();
        }

        public List<T> SaveAndGet(List<T> Entities)
        {
            DAOBase<T> objDAO = DAOFactory<T>.GetDAO(this.Context);
            return objDAO.SaveAndGet(Entities);
        }
    }
}
