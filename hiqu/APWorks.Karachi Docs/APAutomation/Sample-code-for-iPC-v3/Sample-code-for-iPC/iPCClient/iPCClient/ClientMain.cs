using iPCClient.iPCService;
using iPCClient.Model;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace iPCClient
{
    class ClientMain
    {
        const  int ENTITY_ID = 6;
        public const string DATE_FORMAT = "yyyy-MM-dd";
        private static string DETAIL_LINE_SEP = "|||";
        const string PDFDestinationPath = "C:\\Google Invoices\\";
        static void Main(string[] args)
        {
            Console.WriteLine("Fetching invoices from Google Ads.");
            try
            {
                //FetchInvoicesFromAdWords();
                
                FetchInvoicesFromGoogleAds();
            }
            catch (Exception exc)
            {
                Console.WriteLine(exc.Message);
            }

            Console.WriteLine("Completed.");
            Console.ReadKey();
        }
        public static void FetchInvoicesFromAdWords()
        {
            IPCAdServiceAPIClient serviceAPIClient = new IPCAdServiceAPIClient();
            IPCConfiguration iPCConfiguration = LoadConfiguration();
            //iPC Authentication.
            string token = serviceAPIClient.Authenticate(iPCConfiguration.AccountId, iPCConfiguration.iPCUserId, iPCConfiguration.iPCUserPassword, iPCConfiguration.iPCDevToken, iPCConfiguration.AdToolId, iPCConfiguration.AccessTag, "");

            //Invoice properties you want to pull
            string[] invoiceSelecteables = new string[] { "billingId", "billingAccountId", "billingAccountName", "InvoiceId", "issueDate", "dueDate", "status", "invoiceAmountCurrency", "invoiceSubtotal", "invoiceTaxRate", "invoiceTaxAmount", "invoiceAmountAsMicros", "PDF", "invoiceLine[A].lineId", "invoiceLine[A].customerId", "invoiceLine[A].customerName", "invoiceLine[A].lineType", "invoiceLine[A].budgetOrderName", "invoiceLine[A].poNumber", "invoiceLine[A].product", "invoiceLine[A].description", "invoiceLine[A].quantity", "invoiceLine[A].amount" };

            //Filters
            IPCRecordsFilter[] invoiceFilters = new IPCRecordsFilter[3];
            invoiceFilters[0] = new IPCRecordsFilter();
            invoiceFilters[0].ElementName = "billingId";
            invoiceFilters[0].Operator = IPCRecordsFilterOperator.EQUALS;
            invoiceFilters[0].values = new string[1];
            invoiceFilters[0].values[0] = "2806-4979-2205";

            invoiceFilters[1] = new IPCRecordsFilter();
            invoiceFilters[1].ElementName = "billingAccountId";
            invoiceFilters[1].Operator = IPCRecordsFilterOperator.EQUALS;
            invoiceFilters[1].values = new string[1];
            invoiceFilters[1].values[0] = "0363-9569-3188-2368";

            invoiceFilters[2] = new IPCRecordsFilter();
            invoiceFilters[2].ElementName = "issueDate";
            invoiceFilters[2].Operator = IPCRecordsFilterOperator.BETWEEN;
            invoiceFilters[2].values = new string[] { "2020-07-01 00:00:00", "2020-07-31 23:59:59" };

            //iPC returns data as multi dimension array.
            IPCEntityData edEntityInvoice = serviceAPIClient.GetEntityData(token, ENTITY_ID, invoiceSelecteables, null, invoiceFilters, IPCDataElementNameClass.ADTOOL, -1);
            for (int item = 0; item < edEntityInvoice.Data.Length; item++)
            {
                //Read the invoice from iPC given data.
                ParseInvoice(edEntityInvoice, item);

            }
           
        }

        public static void FetchInvoicesFromGoogleAds()
        {
            IPCAdServiceAPIClient serviceAPIClient = new IPCAdServiceAPIClient();
            IPCConfiguration iPCConfiguration = LoadConfiguration();
            //iPC Authentication.
            string token = serviceAPIClient.Authenticate(iPCConfiguration.AccountId, iPCConfiguration.iPCUserId, iPCConfiguration.iPCUserPassword, iPCConfiguration.iPCDevToken, iPCConfiguration.AdToolId, iPCConfiguration.AccessTag, "");

            //Invoice properties you want to pull
            string[] invoiceSelecteables = new string[] { "billingId", "billingAccountId", "billingAccountName", "InvoiceId", "issueDate", "dueDate", "status", "invoiceAmountCurrency", "invoiceSubtotal", "invoiceTaxRate", "invoiceTaxAmount", "invoiceAmountAsMicros", "PDF", "invoiceLine[A].lineId", "invoiceLine[A].customerId", "invoiceLine[A].customerName", "invoiceLine[A].lineType", "invoiceLine[A].budgetOrderName", "invoiceLine[A].poNumber", "invoiceLine[A].product", "invoiceLine[A].description", "invoiceLine[A].quantity", "invoiceLine[A].amount" };

            //Filters
            IPCRecordsFilter[] invoiceFilters = new IPCRecordsFilter[1];
            invoiceFilters[0] = new IPCRecordsFilter();
            invoiceFilters[0].ElementName = "issueMonth";
            invoiceFilters[0].Operator = IPCRecordsFilterOperator.EQUALS;
            invoiceFilters[0].values = new string[1];
            invoiceFilters[0].values[0] = "Jul/2020";//Format: 3 chars of month/Year(yyyy)

            //iPC returns data as multi dimension array.
            IPCEntityData edEntityInvoice = serviceAPIClient.GetEntityData(token, ENTITY_ID, invoiceSelecteables, null, invoiceFilters, IPCDataElementNameClass.ADTOOL, -1);
            for (int item = 0; item < edEntityInvoice.Data.Length; item++)
            {
                //Read the invoice from iPC given data.
                Console.WriteLine($"Parsing invoice # {item + 1} out of {edEntityInvoice.Data.Length}");
                ParseInvoice(edEntityInvoice, item);
            }
        }
        public static IPCConfiguration LoadConfiguration()
        {
            //reading ipc info from config, you need to keep these info in db, encripted password.
            return new IPCConfiguration()
            {
                AdToolId = Convert.ToInt16(System.Configuration.ConfigurationManager.AppSettings.Get("IPC.AdToolId")),
                AccountId = System.Configuration.ConfigurationManager.AppSettings.Get("IPC.AccountId"),
                AccessTag = System.Configuration.ConfigurationManager.AppSettings.Get("IPC.AccessTag"),
                iPCUserId = System.Configuration.ConfigurationManager.AppSettings.Get("IPC.UserId"),
                iPCUserPassword = System.Configuration.ConfigurationManager.AppSettings.Get("IPC.Password"),
                iPCDevToken = System.Configuration.ConfigurationManager.AppSettings.Get("IPC.DevToken")
            };
        }
        private static void ParseInvoice(IPCEntityData edRep, int item)
        {
            #region read invoice header as below
            //invoice_id = Converter.ToString(edRep.Data[item][3]);
            //primary_billing_id = Converter.ToString(edRep.Data[item][0]);
            //billing_account_id = Converter.ToString(edRep.Data[item][1]);
            //billing_account_name = Converter.ToString(edRep.Data[item][2]);
            //issue_date = Converter.ToDate(edRep.Data[item][4], DATE_FORMAT);
            //due_date = Converter.ToDate(edRep.Data[item][5], DATE_FORMAT);
            //invoice_status = Converter.ToString(edRep.Data[item][6]);
            //invoice_currency = Converter.ToString(edRep.Data[item][7]);
            //invoice_subtotal = Converter.ToDouble(edRep.Data[item][8]);
            //invoice_tax_rate = Converter.ToDouble(edRep.Data[item][9]);
            //invoice_tax_amount = Converter.ToDouble(edRep.Data[item][10]);
            //invoice_amount = Converter.ToDouble(edRep.Data[item][11]);
            //invoice_image_type = "PDF";

            if (edRep.Data[item][12] != null && edRep.Data[item][12].Length > 0)
                SavePDF(edRep.Data[item][12], edRep.Data[item][3]);

            //do your coding for invoice header information.
            #endregion

            #region read invoice detail lines

            string[] lineID = edRep.Data[item][13].Split(new string[] { DETAIL_LINE_SEP }, StringSplitOptions.None);
            string[] customerId = edRep.Data[item][14].Split(new string[] { DETAIL_LINE_SEP }, StringSplitOptions.None);
            string[] customerName = edRep.Data[item][15].Split(new string[] { DETAIL_LINE_SEP }, StringSplitOptions.None);
            string[] lineType = edRep.Data[item][16].Split(new string[] { DETAIL_LINE_SEP }, StringSplitOptions.None);
            string[] budgetOrderName = edRep.Data[item][17].Split(new string[] { DETAIL_LINE_SEP }, StringSplitOptions.None);
            string[] poNumber = edRep.Data[item][18].Split(new string[] { DETAIL_LINE_SEP }, StringSplitOptions.None);
            string[] product = edRep.Data[item][19].Split(new string[] { DETAIL_LINE_SEP }, StringSplitOptions.None);
            string[] description = edRep.Data[item][20].Split(new string[] { DETAIL_LINE_SEP }, StringSplitOptions.None);
            string[] quantity = edRep.Data[item][21].Split(new string[] { DETAIL_LINE_SEP }, StringSplitOptions.None);
            string[] amount = edRep.Data[item][22].Split(new string[] { DETAIL_LINE_SEP }, StringSplitOptions.None);

            //all detail arrrays must be the same size
            for (int i = 0; i < lineID.Length; i++)
            {
                //invoice_line_customer_id = customerId[i];
                //invoice_line_customer_name = customerName[i];
                //invoice_line_line_type = lineType[i];
                //invoice_line_budget_order_name = budgetOrderName[i];
                //invoice_line_po_number = poNumber[i];
                //invoice_line_product = product[i];
                //invoice_line_description = description[i];

                //do your coding for invoice line
            }
            #endregion

        }
        static void  SavePDF(string contents, string invoiceId)
        {
            if (!Directory.Exists(PDFDestinationPath))
                Directory.CreateDirectory(PDFDestinationPath);
            string filePath = PDFDestinationPath + invoiceId + ".PDF";
            if (File.Exists(filePath))
                File.Delete(filePath);

            //byte[] data = System.Text.Encoding.ASCII.GetBytes(contents);
            byte[] data = Array.ConvertAll<string, byte>(contents.Split('-'), s => Convert.ToByte(s, 16));
            File.WriteAllBytes(filePath, data);

        }
    }
}
