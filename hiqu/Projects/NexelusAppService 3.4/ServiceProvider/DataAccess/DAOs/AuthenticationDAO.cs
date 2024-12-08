using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;


namespace NexelusApp.Service.DataAccess.DAOs
{
    public class AuthenticationDAO<T> : DAOBase<T> where T : Authentication, new()
    {

        public AuthenticationDAO(NexContext ctx)
            : base(ctx)
        {

        }


        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            throw new NotImplementedException();
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }

        public override bool Save(T entity)
        {
            throw new NotImplementedException();
        }

        public override bool Delete(CriteriaBase<T> criteria)
        {
            throw new NotImplementedException();
        }

    }
}
