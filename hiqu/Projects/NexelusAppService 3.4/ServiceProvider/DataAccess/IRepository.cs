using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;

namespace NexelusApp.Service.DataAccess
{
    /// <summary>
    /// DAO Interface to define common Data Access operations. 
    /// DAOBase and Repository implement the DAO interface.
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public interface IRepository<T> where T : EntityBase, new()
    {
        /// <summary>
        /// Select the list of entities based on passing criteria
        /// </summary>
        /// <param name="criteria">Filter criteria</param>
        /// <returns>List of Entities</returns>
        List<T> Select(CriteriaBase<T> criteria);

        /// <summary>
        /// Select all entities
        /// </summary>
        /// <returns>List of Entities</returns>
        List<T> Select();

        /// <summary>
        /// Delete Entities based on filter criteria
        /// </summary>
        /// <param name="criteria">Filter criteria</param>
        /// <returns>true/false</returns>
        bool Delete(CriteriaBase<T> criteria);

        /// <summary>
        /// Delete Entities based on filter criteria
        /// </summary>
        /// <returns>true/false</returns>
        bool Delete();
        
      /// <summary>
      /// Save entity in database
      /// </summary>
      /// <param name="entity">Entity</param>
      /// <returns>true/false</returns>
        bool Save(T entity);
    }
}
