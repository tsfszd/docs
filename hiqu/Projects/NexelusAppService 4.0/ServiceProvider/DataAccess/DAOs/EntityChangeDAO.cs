using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using com.paradigm.esm.general;

using NexelusApp.Service.Model;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.Model.Criteria;
using NexelusApp.Service.Exceptions;
using System.Collections;
using System.Globalization;
using NexelusApp.Service.Enums;

namespace NexelusApp.Service.DataAccess.DAOs
{
    public class EntityChangeDAO<T> : DAOBase<T> where T : EntityChange, new()
    {
        public EntityChangeDAO(NexContext ctx)
            : base(ctx)
        {

        }

        public override void PopulateEntityFromReader(T objEntity, IDataReader dataReader)
        {
            if (objEntity != null)
            {
                objEntity.CompanyCode = Context.ComapnyCode;

                objEntity.EntityChangeID = Converter.ToInteger(DataAccess.Read<int>(dataReader, "entity_change_id"));
                objEntity.PrimaryKey = Converter.ToString(DataAccess.Read<string>(dataReader, "primary_key")).Trim();
                objEntity.SubscriberID = Converter.ToString(DataAccess.Read<string>(dataReader, "subscriber_id")).Trim();
                objEntity.EntityAction = (enumEntityAction) DataAccess.Read<int>(dataReader, "entity_action_id");
                objEntity.EntityType = (enumEntityType) Converter.ToInteger(DataAccess.Read<int>(dataReader, "entity_type_id"));
                objEntity.CurrentSyncDate = Converter.ToString(DataAccess.Read<string>(dataReader, "current_sync_date"));
            }
        }

        public override List<T> Select(CriteriaBase<T> criteria)
        {
            List<T> retList = null;
            EntityChangeCriteria<EntityChange> objCrit = criteria as EntityChangeCriteria<EntityChange>;
            List<SqlParameter> parameters = new List<SqlParameter>();

            SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
            param.Value = Context.ComapnyCode;
            parameters.Add(param);

            param = new SqlParameter("@subscriber_id", SqlDbType.VarChar);
            param.Value = Context.SubscriberID;
            parameters.Add(param);

            param = new SqlParameter("@last_sync_date", SqlDbType.VarChar);
            if(objCrit.LastSyncDate == null )
            {
                param.Value = DateTime.Now.ToString("s").Replace("T", " ");
            }
            else
            {
                param.Value=objCrit.LastSyncDate.ToString("s").Replace("T", " ");
            }
            parameters.Add(param);

            try
            {
                retList = DbContext.GetEntitiesList(this, "pdsW_apps_entity_change_get", parameters, enumDatabaes.ESM);
            }
            catch (AppException ex)
            {
                if (ex.LoggerLevel == Log.LogLevelType.INNER)
                {
                    throw ex;
                }
                else
                {
                    throw new AppException(Context.LoginID, string.Format("Error fetching the Entity Change(s): {0} .", ex.Message.Trim()), ex);
                }
            }
            catch (Exception ex)
            {
                throw new AppException(Context.LoginID, string.Format("Error fetching the Entity Change(s): {0} .", ex.Message.Trim()), ex);
            }

            return retList;
        }

        public override bool Save(T entity)
        {
            throw new NotImplementedException();
        }

        public override bool Delete(CriteriaBase<T> criteria)
        {
            bool retVal = false;
            EntityChangeCriteria<EntityChange> objCrit = null;            

            if (criteria != null)
            {
                objCrit = criteria as EntityChangeCriteria<EntityChange>;

                if (objCrit != null)
                {
                    List<SqlParameter> parameters = new List<SqlParameter>();

                    SqlParameter param = new SqlParameter("@company_code", SqlDbType.Int);
                    param.Value = Context.ComapnyCode;
                    parameters.Add(param);

                    //param = new SqlParameter("@entity_change_id", SqlDbType.Int);
                    //parameters.Add(param);
                    //param.Value = entityId;

                    param = new SqlParameter("@keys", SqlDbType.Xml);
                    param.Value = GetXMLFromKeys(objCrit.EntityChangeList);
                    parameters.Add(param);
                        
                                         
                    try
                    {
                        retVal = DbContext.Update("pdsW_apps_entity_change_delete", parameters, enumDatabaes.ESM);
                    }
                    catch (AppException ex)
                    {
                        if (ex.LoggerLevel == Log.LogLevelType.INNER)
                        {
                            throw ex;
                        }
                        else
                        {
                            throw new AppException(Context.LoginID, string.Format("Error deleting the Entity Change(s): {0} .", ex.Message.Trim()), ex);
                        }
                    }
                    catch (Exception ex)
                    {
                        throw new AppException(Context.LoginID, string.Format("Error deleting the Entity Change(s): {0} .", ex.Message.Trim()), ex);
                    }
                    
                }
            }           

            return retVal;
        }

        private string GetXMLFromKeys(List<int> keys)
        {
            StringBuilder xml = new StringBuilder();
            xml.Append("<keys>");

            foreach (int key in keys)
            {
                //string[] splittedKeys = key.Split(new string[] { "~-~" }, StringSplitOptions.None);

                xml.Append("<key>");

                xml.Append("<entity_change_id>");
                xml.Append(key);
                xml.Append("</entity_change_id>");

                xml.Append("</key>");

            }

            xml.Append("</keys>");
            return xml.ToString();
        }

    }
}
