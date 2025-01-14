using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using NexelusApp.Service.Configuration;
using NexelusApp.Service.Model.Entities;
using NexelusApp.Service.DataAccess;
using NexelusApp.Service.DataAccess.DAOs;
using NexelusApp.Service.Model.Criteria;
using com.paradigm.esm.general;
using NexelusApp.Service.eSMWebService;

namespace NexelusApp.Service.Model
{
    /// <summary>
    /// This class is returned after authentication and needed for evey operation.
    /// </summary>
    public class NexContext 
    {
        private string _TE_ConnectionString = "";
        private string _ESM_ConnectionString = "";
        private int _ComapnyCode = 0;
        private string _LoginID = "";
        private int _IsUsingAD = 0;
        private int _SubscriberID;
        private string _ESMDocumentPath;
        private string _web_url;
        private EsmWebService esmWebService = new EsmWebService();

        public string ESMDocumentPath
        {
            get { return _ESMDocumentPath; }
            set { _ESMDocumentPath = value; }
        }

        public EsmWebService EsmWebService
        {
            get { return esmWebService; }
            protected set { esmWebService = value; }
        }

        public int SubscriberID
        {
            get { return _SubscriberID; }
            set { _SubscriberID = value; }
        }

        public int IsUsingAD
        {
            get { return _IsUsingAD; }
            protected set { _IsUsingAD = value; }
        }


        private DataAccess.DataAccess _Connection = null;


        private NexContext()
        {
            _Connection = new DataAccess.DataAccess(this);
        }


        public DataAccess.DataAccess DBConnection
        {
            get { return _Connection; }
        }

        /// <summary>
        /// Company code
        /// </summary>
        public int ComapnyCode
        {
            get { return _ComapnyCode; }
            protected set { _ComapnyCode = value; }
        }

        public string LoginID
        {
            get { return _LoginID; }
        }


        /// <summary>
        /// Connection string for esm
        /// </summary>
        public string ESM_ConnectionString
        {
            get { return _ESM_ConnectionString; }
            protected set  { _ESM_ConnectionString = value; }
        }

        public string WebURL
        {
            get { return _web_url; }
            set { _web_url = value; }
        }

        /// <summary>
        /// Connection string for TE database
        /// </summary>
        public string TE_ConnectionString
        {
            get { return _TE_ConnectionString; }
            protected set { _TE_ConnectionString = value; }
        }

        public static NexContext AuthenticateUser(Authentication auth, SubscriberInfo subInfo)
        {
            

            Resource res;
            NexContext ctx = new NexContext();
            
            CompanySiteDAO<Entities.CompanySite> csDAO = new CompanySiteDAO<Entities.CompanySite>(ctx);
            Entities.CompanySite cs = csDAO.AuthenticateUser(auth);

           
            ctx._LoginID = auth.LoginID;
            ctx.ComapnyCode = cs.CompanyCode;
            
            ctx.ESM_ConnectionString = "Server=" + cs.DatabaseServerESM + ";Database=" + cs.DatabaseNameESM +
                    ";Connect Timeout=" + cs.ConnectionTimeoutESM + ";UID=" + cs.UserIDESM + ";PWD=" + cs.PasswordESM + ";";
            ctx.TE_ConnectionString = "Server=" + cs.DatabaseServerESMTE + ";Database=" + cs.DatabaseNameESMTE +
                    ";Connect Timeout=" + cs.ConnectionTimeoutESMTE + ";UID=" + cs.UserIDESMTE + ";PWD=" + cs.PasswordESMTE + ";";

            ctx._Connection = new DataAccess.DataAccess(ctx);
            ctx.EsmWebService .Url = cs.ServicePath;
            ctx.ESMDocumentPath = cs.ServicePath;   // Need to change this
            ctx.WebURL = cs.WebURL;

            ResourceDAO<Resource> resDAO = new ResourceDAO<Resource>(ctx);

            //TODO 
            // set URL for eServer
            // Authenticate eservice 

            if (GetAuthenticationMode(cs) == (int)enumAuthentication.AD)
            {
                string _serverName = cs.ADServerName;
                string _domainName = cs.ADDomainName;

                ctx.IsUsingAD = 1;
                res = resDAO.LoginUsingAD(_serverName, _domainName, auth.Password);                
            }
            else
            {
                string tempPass = auth.Password;
                TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
                tempPass = TwofishAlgorithm.eEncrypt(tempPass);

                auth.Password = tempPass;

                ctx.IsUsingAD = 0; // REVERT BACK TO 0
                res = resDAO.LoginUsingDB(auth.Password);
                
            }

            if (res == null)
            {
                ctx = null; // Means that login user has been failed
            }

            if (ctx != null)
            {
                // Set and get the subscriber here 
                ctx.SubscriberID = resDAO.GetResourceSubscriberID(subInfo, res.ResourceID);
            }

            return ctx;
        }
        public static NexContext AuthenticateUser(Authentication auth)
        {
            TwofishAlgorithm.CreateKey(TwofishAlgorithm.DEFAULT_KEY);
            NexContext ctx = new NexContext();
            auth.AuthenticationKey = TwofishAlgorithm.eEncrypt(auth.AuthenticationKey);

            CompanySiteDAO<Entities.CompanySite> csDAO = new CompanySiteDAO<Entities.CompanySite>(ctx);
            Entities.CompanySite cs = csDAO.AuthenticateUser(auth);
            ctx.ComapnyCode = cs.CompanyCode;
            
            ctx.ESM_ConnectionString = "Server=" + cs.DatabaseServerESM + ";Database=" + cs.DatabaseNameESM +
                    ";Connect Timeout=" + cs.ConnectionTimeoutESM + ";UID=" + cs.UserIDESM + ";PWD=" + cs.PasswordESM + ";";
            ctx.TE_ConnectionString = "Server=" + cs.DatabaseServerESMTE + ";Database=" + cs.DatabaseNameESMTE +
                    ";Connect Timeout=" + cs.ConnectionTimeoutESMTE + ";UID=" + cs.UserIDESMTE + ";PWD=" + cs.PasswordESMTE + ";";

            ctx._Connection = new DataAccess.DataAccess(ctx);

            return ctx;
        }


        private static int GetAuthenticationMode(Entities.CompanySite cs)
        {
            string authSettings = "";
            authSettings = cs.AuthenticationMode;

            if (authSettings.ToLower().IndexOf("ad") > -1)
                return 1;
            else
                return 2;
        }
        public static NexContext GetContext()
        {
            return new NexContext();
        }
    }
}
