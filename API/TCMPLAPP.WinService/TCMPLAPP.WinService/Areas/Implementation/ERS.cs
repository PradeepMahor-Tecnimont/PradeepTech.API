

using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using System.IO.Compression;
using System.Net.Http;
using System.Security;
using TCMPLAPP.WinService.Models;
using TCMPLAPP.WinService.Services;
using Microsoft.SharePoint.Client;
using SP = Microsoft.SharePoint.Client;
using System.Net;
using Microsoft.Office.SharePoint.Tools;

namespace TCMPLAPP.WinService.Areas
{
    public class ERS : IERS
    {
        ILogger<IERS> _logger;
        IHttpClientTCMPLAppWebApi _httpClientTCMPLAppWebApi;

        IConfiguration _configuration;
        private readonly IProcessDBLogger _processDBLogger;

        private static string ModuleERS = "M12";
        protected static string UriSyncSharePoint = "SharePoint/GetVacancyList";
        protected static string ProcessIdSyncSharePoint = "ERSSP";        

        public ERS(ILogger<IERS> logger, IHttpClientTCMPLAppWebApi httpClientTCMPLAppWebApi, IConfiguration configuration, IProcessDBLogger processDBLogger)
        {
            _logger = logger;
            _httpClientTCMPLAppWebApi = httpClientTCMPLAppWebApi;
            _configuration = configuration;
            _processDBLogger = processDBLogger;
        }

        public WSMessageModel ExecuteProcess(ProcessQueueModel currProcess)
        {
            if (currProcess.ModuleId == ModuleERS && currProcess.ProcessId == ProcessIdSyncSharePoint)
            {
                return SyncSharePointERS(currProcess);
            }

            return new WSMessageModel { Status = "KO", Message = "ERS - Corresponding method not found" };
        }

        public WSMessageModel SyncSharePointERS(ProcessQueueModel currProcess)
        {
            string webUrl = _configuration.GetValue<string>("PortalVacanciesBaseUri");
            //string listName = "ERS Vacancy List";
            string listid = "24101178-915E-47D5-B169-A53EF06F8907";

            using (ClientContext clientContext = new ClientContext(webUrl))
            {
                //string vUserName = Environment.UserDomainName + "\\" + ;
                string vPassword = "*****";
                //string[] vUserSplit = vUserName.Split('\\');

                //var securePassword = new SecureString();
                //foreach (char c in vPassword)
                //{ securePassword.AppendChar(c); }

                clientContext.Credentials = new NetworkCredential(Environment.UserName, vPassword, Environment.UserDomainName);
                //clientContext.Credentials = new SharePointOnlineCredentials(vUserName, securePassword);
                clientContext.ExecuteQuery();


                //SP.List oList = clientContext.Web.Lists.GetByTitle(listName);
                SP.List oList = clientContext.Web.Lists.GetById(Guid.Parse(listid));

                //// Deleting existing records from list

                ListItemCollection listItems = oList.GetItems(CamlQuery.CreateAllItemsQuery());
                clientContext.Load(listItems, eachItem => eachItem.Include(item => item, item => item["ID"]));
                clientContext.ExecuteQuery();

                var totalListItems = listItems.Count;
                if (totalListItems > 0)
                {
                    for (var counter = totalListItems - 1; counter > -1; counter--)
                    {
                        listItems[counter].DeleteObject();
                        clientContext.ExecuteQuery();
                    }
                }

                //// Adding latest 5 records to list

                var httpResponse = Task.Run(async () => await _httpClientTCMPLAppWebApi.ExecuteUriAsync(new HCModel { }, UriSyncSharePoint)).Result;
                var retObj = HttpResponseHelper.ConvertResponseMessageToObject<IEnumerable<VacancyData>>(httpResponse);

                if (retObj.Status == "OK")
                {
                    if (retObj.Data.Count() > 0)
                    {
                        SP.ListItemCreationInformation createInfo = null;

                        foreach (var itm in retObj.Data)
                        {
                            SP.ListItem item = oList.AddItem(createInfo);
                            item["Title"] = Convert.ToString(itm.JobLocation);
                            item["JOB_KEY_ID"] = Convert.ToString(itm.JobKeyId);
                            item["JOB_REFERENCE_CODE"] = Convert.ToString(itm.JobReferenceCode);
                            item["COSTCODE"] = Convert.ToString(itm.Costcode);
                            item["JOB_LOCATION"] = Convert.ToString(itm.JobLocation);
                            item["JOB_TYPE"] = Convert.ToString(itm.JobType);
                            item["SHORT_DESC"] = Convert.ToString(itm.ShortDesc);
                            item.Update();
                        }
                        clientContext.ExecuteQuery();
                    }

                    _processDBLogger.LogInformation(new HCModel { Keyid = currProcess.KeyId, LogMessage = "This is a test info message" });

                    return new WSMessageModel { Status = "OK", Message = "Procedure executed successfully" };
                }
                else if (retObj.Status == "KO")
                    return new WSMessageModel { Status = "KO", Message = retObj.Message };
                else
                    return new WSMessageModel { Status = "KO", Message = "URI returned unknown." };

            }
        }
    }
}