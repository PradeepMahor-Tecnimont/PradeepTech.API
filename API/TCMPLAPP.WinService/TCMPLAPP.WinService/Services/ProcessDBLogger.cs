using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLAPP.WinService.Models;

namespace TCMPLAPP.WinService.Services
{
    public interface IProcessDBLogger
    {
        public void LogInformation(HCModel hCModel);
        public void LogWarning(HCModel hCModel);
        public void LogError(HCModel hCModel);

    }

    public class ProcessDBLogger : IProcessDBLogger
    {

        private static string _uriInformation = "QueueProcesses/LogInformation";
        private static string _uriWarning = "QueueProcesses/LogWarning";
        private static string _uriError = "QueueProcesses/LogError";

        IHttpClientTCMPLAppWebApi _webApiClient;

        public ProcessDBLogger(IHttpClientTCMPLAppWebApi webApiClient)
        {
            _webApiClient = webApiClient;
        }

        public void LogInformation(HCModel hCModel)
        {
            _webApiClient.PostUriAsync(hCModel, _uriInformation);
        }


        public void LogWarning(HCModel hCModel)
        {
            _webApiClient.PostUriAsync(hCModel, _uriWarning);
        }

        public void LogError(HCModel hCModel)
        {
            _webApiClient.PostUriAsync(hCModel, _uriError);
        }
    }
}
