using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;
using com.paradigm.esm.general;
using NexelusApp.Service.Exceptions;
using com.paradigm.esm.model;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class SubscriberDAO<T> : DAOBase<T> where T : Subscriber, new()
    {
        public SubscriberDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public void deleteNotificationsDataAgainstSubscriber(int subscriberid)
        {
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@subscriber_id", SqlDbType.Int);
            param.Value = subscriberid;
            parameters.Add(param);

            SqlConnection connection = null;
            SqlCommand cmd = null;
            IDataReader dataReader = null;

            try
            {
                connection = Context.DBConnection.GetActiveConnection(enumDatabaes.ESM);
                cmd = new SqlCommand();

                cmd.Connection = connection;
                cmd.CommandText = "pdsw_apps_delete_subscriber_data";
                cmd.CommandType = CommandType.StoredProcedure;

                foreach (SqlParameter parm in parameters)
                {
                    cmd.Parameters.Add(parm);
                }


                dataReader = cmd.ExecuteReader();
            }
            finally
            {
                if (dataReader != null && !dataReader.IsClosed)
                {
                    dataReader.Close();
                }

                Context.DBConnection.Close();
            }
        }

        public override void PopulateEntityFromReader(T objEntity, System.Data.IDataReader dataReader)
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
