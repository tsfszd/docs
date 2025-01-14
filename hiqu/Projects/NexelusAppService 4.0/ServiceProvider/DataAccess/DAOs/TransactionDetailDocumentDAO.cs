using com.paradigm.esm.general;
using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.Model.Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class TransactionDetailDocumentDAO<T> : DAOBase<T> where T : TransactionDetailDocument, new()
    {
        public TransactionDetailDocumentDAO(NexContext ctx)
            : base(ctx)
        {

        }
        public override bool Delete(CriteriaBase<T> criteria)
        {
            var response = false;
            var docCriteria = criteria as TransactionDetailDocumentCriteria<T>;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@transaction_id", SqlDbType.VarChar);
            param.Value = docCriteria.TransactionId;
            parameters.Add(param);

            param = new SqlParameter("@user_id", SqlDbType.VarChar);
            param.Value = Context.LoginID;
            parameters.Add(param);

            response = DbContext.Update("pdsw_trx_documents_dtl_delete", parameters, enumDatabaes.ESM, true);

            return response;
        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.TransactionId = dataReader["transaction_id"] == DBNull.Value ? "" : Converter.ToString(dataReader["transaction_id"]);
                objEntity.DocumentName = dataReader["document_name"] == DBNull.Value ? "" : Converter.ToString(dataReader["document_name"]);
                objEntity.DocumentDescription = dataReader["document_description"] == DBNull.Value ? "" : Converter.ToString(dataReader["document_description"]);
                objEntity.DocumentLink = dataReader["document_link"] == DBNull.Value ? "" : Converter.ToString(dataReader["document_link"]);
                objEntity.ExtDriveID = dataReader["Doc_Drive_ID"] == DBNull.Value ? "" : Converter.ToString(dataReader["Doc_Drive_ID"]);
                objEntity.DocSource = dataReader["Doc_source"] == DBNull.Value ? default(int) : Converter.ToInteger(dataReader["Doc_source"]);
                objEntity.CreateDate = dataReader["create_date"] == DBNull.Value ? "" : Converter.ToString(dataReader["create_date"]);
                if (!string.IsNullOrEmpty(objEntity.ExtDriveID))
                {
                    objEntity.DocumentLink += "?" + objEntity.ExtDriveID;
                }
            }
        }

        public override bool Save(T entity)
        {
            var response = false;
            SqlParameter[] param = new SqlParameter[] {
                new SqlParameter("@company_code", Context.ComapnyCode),
                new SqlParameter("@transaction_id", entity.TransactionId),
                new SqlParameter("@document_name", entity.DocumentName),
                new SqlParameter("@document_description", string.Empty),
                new SqlParameter("@uploaded_by_resource_id", entity.UploadedBy),
                new SqlParameter("@document_link", entity.DocumentLink),
                new SqlParameter("@Doc_Drive_ID", entity.ExtDriveID),
                new SqlParameter("@Doc_source", entity.DocSource),
                new SqlParameter("@action_flag", entity.Action),
                new SqlParameter("@user_id", Context.LoginID),
                new SqlParameter("@size", entity.FileSize)
            };
            List<SqlParameter> parameters = param.ToList();

            response = DbContext.Update("pdsw_trx_documents_dtl_set", parameters, enumDatabaes.ESM, true);

            return response;
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            List<SqlParameter> parameters = new List<SqlParameter>();
            var docCriteria = criteria as TransactionDetailDocumentCriteria<T>;

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@user_id", SqlDbType.VarChar);
            param.Value = Context.LoginID;
            parameters.Add(param);

            param = new SqlParameter("@transaction_id", SqlDbType.VarChar);
            param.Value = docCriteria.TransactionId;
            parameters.Add(param);

            retList = DbContext.GetEntitiesList(this, "pdsw_trx_documents_dtl_get", parameters, enumDatabaes.ESM);

            return retList;
        }
    }
}
