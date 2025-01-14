using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.SqlClient;

using NexelusApp.Service.Model;
using NexelusApp.Service.Configuration;
using NexelusApp.Service.Log;
using NexelusApp.Service.Exceptions;


namespace NexelusApp.Service.DataAccess
{
    /// <summary>
    /// maintain connection and transactions
    /// </summary>
    public class DataAccess
    {
       //connection + BeginTrans, endTransa + close connection

        private Dictionary<enumDatabaes,SqlConnection> _ActiveConnections = new Dictionary<enumDatabaes,SqlConnection>();
        private Dictionary<SqlConnection, SqlTransaction> _ActiveTransactions = new Dictionary<SqlConnection, SqlTransaction>();

        public Dictionary<SqlConnection, SqlTransaction> ActiveTransactions
        {
            get { return _ActiveTransactions; }           
        }


        private bool _IsTransactionStarted = false;
        private string mESMConnectionString = "";
        private string mTEConnectionString = "";

        public bool IsTransactionStarted
        {
            get { return _IsTransactionStarted; }
          
        }

        public DataAccess(NexContext ctx)
        {
            mESMConnectionString = ctx.ESM_ConnectionString;
            mTEConnectionString = ctx.TE_ConnectionString;
        }

        public SqlConnection GetActiveConnection(enumDatabaes db)
        {
            SqlConnection mConnection = null;

            try
            {
                if (_ActiveConnections.ContainsKey(db) == true)
                {
                    mConnection = _ActiveConnections[db];

                    //open connection if it is not opened
                    if (mConnection.State != ConnectionState.Open)
                    {
                        mConnection.ConnectionString = GetConnectionString(db);
                        mConnection.Open();
                    }
                }
                else
                {
                    mConnection = new SqlConnection();
                    mConnection.ConnectionString = GetConnectionString(db);                    
                    mConnection.Open();
                    _ActiveConnections.Add(db, mConnection);

                }

                // if transaction flag is set then begin transaction if it is not started
                if (mConnection != null && this.IsTransactionStarted == true)
                {
                    if (_ActiveTransactions.ContainsKey(mConnection) == false)
                    {
                        _ActiveTransactions.Add(mConnection, mConnection.BeginTransaction());
                    }

                }
            }
            catch (SqlException ex)
            {
                _ActiveTransactions.Clear();
                _IsTransactionStarted = false;
                throw new AppException("SYSTEM_STARTUP", ex.Message, LogLevelType.SQLERROR);
            }
            catch (Exception ex)
            {
                _ActiveTransactions.Clear();
                _IsTransactionStarted = false;
                throw new AppException("SYSTEM_STARTUP", ex.Message, LogLevelType.ERROR);
            }

            return mConnection;
        }

        public bool BeginTransaction()
        {
            _IsTransactionStarted = true;
            return _IsTransactionStarted;
        }

        public bool CommitTransaction()
        {
            try
            {
                if (_IsTransactionStarted == true)
                {
                    foreach (SqlTransaction transaction in _ActiveTransactions.Values)
                    {
                        transaction.Commit();
                    }
                    _ActiveTransactions.Clear();
                }
                _IsTransactionStarted = false;
            }

            catch (SqlException ex)
            {
                _ActiveTransactions.Clear();
                _IsTransactionStarted = false;

                if (!ex.Message.Contains("This SqlTransaction has completed"))
                {
                    throw new AppException("SYSTEM_STARTUP", ex.Message, LogLevelType.SQLERROR);    
                }
                
            }
            catch (Exception ex)
            {
                _ActiveTransactions.Clear();
                _IsTransactionStarted = false;

                if (!ex.Message.Contains("This SqlTransaction has completed"))
                {
                    throw new AppException("SYSTEM_STARTUP", ex.Message, LogLevelType.SQLERROR);
                }
            }
            finally
            {
                Close();
            }

            return true;
        }

        public bool RollbackTransaction()
        {
            try
            {
                if (_IsTransactionStarted == true)
                {
                    foreach (SqlTransaction transaction in _ActiveTransactions.Values)
                    {
                        transaction.Rollback();
                    }
                    _ActiveTransactions.Clear();
                }
            }
            catch (SqlException ex)
            {
                _ActiveTransactions.Clear();
                _IsTransactionStarted = false;

                if (!ex.Message.Contains("This SqlTransaction has completed"))
                {
                    throw new AppException("SYSTEM_STARTUP", ex.Message, LogLevelType.SQLERROR);
                }
            }
            catch (Exception ex)
            {
                _ActiveTransactions.Clear();
                _IsTransactionStarted = false;

                if (!ex.Message.Contains("This SqlTransaction has completed"))
                {
                    throw new AppException("SYSTEM_STARTUP", ex.Message, LogLevelType.SQLERROR);
                }
            }
            finally
            {
                _IsTransactionStarted = false;

                Close();
            }
        
            return true;
        }

        public void Close()
        {
            
            if (_IsTransactionStarted == false)
            {
                try
                {
                    foreach (SqlConnection conn in _ActiveConnections.Values)
                    {
                        if (conn.State != ConnectionState.Closed)
                        {
                            conn.Close();
                            conn.Dispose();
                        }
                    }
                }
                catch (SqlException ex)
                {
                    _ActiveTransactions.Clear();
                    _IsTransactionStarted = false;
                    throw new AppException("SYSTEM_STARTUP", ex.Message, LogLevelType.SQLERROR);
                }
                catch (Exception ex)
                {
                    _ActiveTransactions.Clear();
                    _IsTransactionStarted = false;
                    throw new AppException("SYSTEM_STARTUP", ex.Message, LogLevelType.ERROR);
                }
                finally
                {
                    _ActiveConnections.Clear();
                }
            }
        }

        private string GetConnectionString(enumDatabaes db)
        {
            string ConnectionString = "";
            switch (db)
            {
                case enumDatabaes.App: 
                    ConnectionString = "Server=" + Config.Instance.DatabaseServer + ";Database=" + Config.Instance.DatabaseName +
                    ";Connect Timeout=" + Config.Instance.ConnectionTimeOut + ";UID=" + Config.Instance.DatabaseUID + ";PWD=" + Config.Instance.DatabasePWD + ";"; 
                    break;
                case enumDatabaes.ESM: 
                    ConnectionString = mESMConnectionString; 
                    break;
                case enumDatabaes.TE: 
                    ConnectionString = mTEConnectionString; 
                    break;
                default: 
                    ConnectionString = mESMConnectionString; 
                    break;
            }
            return ConnectionString;
        }

        public static T Read<T>(IDataReader Reader, string ColumnName)
        {
            int ordinal = Reader.GetOrdinal(ColumnName);
            if (Reader.IsDBNull(ordinal) == true) return default(T);
            return (T)Convert.ChangeType(Reader[ColumnName], typeof(T));
        }

        public static string Read(IDataReader Reader, string ColumnName)
        {
            if (Reader.IsDBNull(Reader.GetOrdinal(ColumnName))) return "";
            return Reader[ColumnName].ToString().Trim();
        }

        public static T Read<T>(IDataReader Reader, int ordinal)
        {
            if (Reader.IsDBNull(ordinal) == true) return default(T);
            return (T)Convert.ChangeType(Reader[ordinal], typeof(T));
        }

    }
}
