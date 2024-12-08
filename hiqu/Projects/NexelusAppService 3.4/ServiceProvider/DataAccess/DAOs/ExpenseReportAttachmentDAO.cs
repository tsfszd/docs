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
using com.paradigm.esm.general;
using System.Collections;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class ExpenseReportAttachmentDAO<T> : DAOBase<T> where T : ExpenseReportAttachment, new()
    {
        public ExpenseReportAttachmentDAO(NexContext ctx)
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
