using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Runtime.Serialization;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;

namespace NexelusApp.Service.Model.Criteria
{

    public static class CriteriaFactory<T> where T : EntityBase, new()
    {
        static readonly Dictionary<Type, Type> EntityMap = new Dictionary<Type, Type>();


        /// <summary>
        /// Map the Entityes with respective Critera in the constructor
        /// </summary>
        static CriteriaFactory()
        {
            EntityMap.Add(typeof(Level2), typeof(Level2Criteria<Level2>));
            EntityMap.Add(typeof(Level3), typeof(Level3Criteria<Level3>));
            EntityMap.Add(typeof(Task), typeof(TaskCriteria<Task>));
            EntityMap.Add(typeof(PermanentLine), typeof(PermanentLinesCriteria<PermanentLine>));
        }

        /// <summary>
        /// Return the instace of the respective Criteria
        /// </summary>
        /// <param name="ctx"></param>
        /// <returns></returns>
        public static CriteriaBase<T> GetEntityCriteria()
        {
            CriteriaBase<T> obj = null;

            if (EntityMap.ContainsKey(typeof(T)))
            {
                obj = (CriteriaBase<T>)Activator.CreateInstance(EntityMap[typeof(T)]);
            }


            return obj;
        }
    }
}
