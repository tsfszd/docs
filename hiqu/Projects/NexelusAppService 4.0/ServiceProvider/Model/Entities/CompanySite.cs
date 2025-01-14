using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;



namespace NexelusApp.Service.Model.Entities
{
    public class CompanySite : EntityBase
    {

        #region Private Properties

        private int _CompanyCode;
        private string _CompanyName;
        private string _DatabaseServerESM;
        private string _DatabaseNameESM;
        private string _UserIDESM;
        private string _PasswordESM;
        private int _ConnectionTimeoutESM;
        private int _QueryTimeoutESM;
        private string _DatabaseServerESMTE;
        private string _DatabaseNameESMTE;
        private string _UserIDESMTE;
        private string _PasswordESMTE;
        private int _ConnectionTimeoutESMTE;
        private int _QueryTimeoutESMTE;
        private string _AuthenticationMode;
        private string _ADServerName;
        private string _ADDomainName;
        private string _service_path;
        private string _web_url;
        #endregion

        #region Public Properties

        public string ServicePath
        {
            get { return _service_path; }
            set { _service_path = value; }
        }
        public new int CompanyCode
        {
            get { return _CompanyCode; }
            set { _CompanyCode = value; }
        }
        public string CompanyName
        {
            get { return _CompanyName; }
            set { _CompanyName = value; }
        }
        public string DatabaseServerESM
        {
            get { return _DatabaseServerESM; }
            set { _DatabaseServerESM = value; }
        }
        public string DatabaseNameESM
        {
            get { return _DatabaseNameESM; }
            set { _DatabaseNameESM = value; }
        }
        public string UserIDESM
        {
            get { return _UserIDESM; }
            set { _UserIDESM = value; }
        }
        public string PasswordESM
        {
            get { return _PasswordESM; }
            set { _PasswordESM = value; }
        }
        public int ConnectionTimeoutESM
        {
            get { return _ConnectionTimeoutESM; }
            set { _ConnectionTimeoutESM = value; }
        }
        public int QueryTimeoutESM
        {
            get { return _QueryTimeoutESM; }
            set { _QueryTimeoutESM = value; }
        }
        public string DatabaseServerESMTE
        {
            get { return _DatabaseServerESMTE; }
            set { _DatabaseServerESMTE = value; }
        }
        public string DatabaseNameESMTE
        {
            get { return _DatabaseNameESMTE; }
            set { _DatabaseNameESMTE = value; }
        }
        public string UserIDESMTE
        {
            get { return _UserIDESMTE; }
            set { _UserIDESMTE = value; }
        }
        public string PasswordESMTE
        {
            get { return _PasswordESMTE; }
            set { _PasswordESMTE = value; }
        }
        public int ConnectionTimeoutESMTE
        {
            get { return _ConnectionTimeoutESMTE; }
            set { _ConnectionTimeoutESMTE = value; }
        }
        public int QueryTimeoutESMTE
        {
            get { return _QueryTimeoutESMTE; }
            set { _QueryTimeoutESMTE = value; }
        }
        public string AuthenticationMode
        {
            get { return _AuthenticationMode; }
            set { _AuthenticationMode = value; }
        }
        public string ADServerName
        {
            get { return _ADServerName; }
            set { _ADServerName = value; }
        }
        public string ADDomainName
        {
            get { return _ADDomainName; }
            set { _ADDomainName = value; }
        }
        public string WebURL
        {
            get { return _web_url; }
            set { _web_url = value; }
        }
        #endregion

        public override bool Validate(StringBuilder message)
        {
            throw new NotImplementedException();
        }
    }
}
