using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLAPP.WinService.Models;

namespace TCMPLAPP.WinService.Services
{
    public interface IProcessDBStatus
    {
        public void ProcessStarted(HCModel hCModel);
        public void StopWithSuccess(HCModel hCModel);
        public void StopWithError(HCModel hCModel);

    }

    public class ProcessDBStatus : IProcessDBStatus
    {
        private static string _uriProcessStarted = "QueueProcesses/ProcessStarted";
        private static string _uriStopWithSucces = "QueueProcesses/StopWithSuccess";
        private static string _uriStopWithError = "QueueProcesses/StopWithError";


        IHttpClientTCMPLAppWebApi _webApiClient;

        public ProcessDBStatus(IHttpClientTCMPLAppWebApi httpClientTCMPLAppWebApi)
        {
            _webApiClient = httpClientTCMPLAppWebApi;

        }

        public void ProcessStarted(HCModel hCModel)
        {
            _webApiClient.PostUriAsync(hCModel, _uriProcessStarted);
        }


        public void StopWithSuccess(HCModel hCModel)
        {
            _webApiClient.PostUriAsync(hCModel, _uriStopWithSucces);
        }

        public void StopWithError(HCModel hCModel)
        {
            _webApiClient.PostUriAsync(hCModel, _uriStopWithError);

        }
    }
}
