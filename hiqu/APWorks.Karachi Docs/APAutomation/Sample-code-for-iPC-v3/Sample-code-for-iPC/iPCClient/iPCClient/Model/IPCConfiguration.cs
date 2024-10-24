using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace iPCClient.Model
{
    public class IPCConfiguration
    {
        public IPCConfiguration()
        {
            iPCDevToken = "Dummy";
        }
        /// <summary>
        /// Ad Tool identifier on iPC.
        /// </summary>
        public int AdToolId { get; set; }
        /// <summary>
        /// iPC Account 
        /// </summary>
        public string AccountId { get; set; }
        /// <summary>
        /// iPC Account may have multiple Google Ads Account, AccessTag is being used to identify sepecific Google Ads account.
        /// </summary>
        public string AccessTag { get; set; }
        /// <summary>
        /// iPC User ID, iPC validates the client request initially based on iPCUserId, iPCUserPassword and iPCDevToken and then go ahead for next steps.
        /// </summary>
        public string iPCUserId { get; set; }
        /// <summary>
        /// iPC User ID, iPC validates the client request initially based on iPCUserId, iPCUserPassword and iPCDevToken and then go ahead for next steps.
        /// </summary>
        public string iPCUserPassword { get; set; }
        /// <summary>
        /// iPC User ID, iPC validates the client request initially based on iPCUserId, iPCUserPassword and iPCDevToken and then go ahead for next steps.
        /// </summary>
        public string iPCDevToken { get; set; }
    }
}
