using System.Diagnostics;
using System.Net.Security;
using System.Security.Cryptography.X509Certificates;
using TCMPLAPP.WinService.Areas;
//using System.Net.Mail;
using TCMPLAPP.WinService.Models;
using TCMPLAPP.WinService.Services;

namespace TCMPLAPP.WinService
{

    public class Worker : BackgroundService
    {
        private static readonly string _uriPendingProcess = "QueueProcesses/GetPendingProcesses";

        //private readonly string _moduleSmartWorkPolicy = "05";



        private readonly bool _boolGenerateDBLogs = false;

        private readonly ILogger<Worker> _logger;
        private readonly IProcessDBLogger _processDBLogger;
        private readonly IProcessDBStatus _processDBStatus;

        private readonly IServiceProvider _serviceProvider;
        private readonly ISWP _iSWP;
        private readonly IRapReporting _iRapReporting;
        private readonly IAttendance _attendance;
        private readonly IEmpGenInfo _empGenInfo;
        private readonly ITcmplAppConfig _tcmplAppConfig;

        private readonly IServiceScopeFactory _serviceScopeFactory;

        private readonly IConfiguration _configuration;
        private readonly double _workerProcessDelayInMinutes;
        private readonly string _applicationErrorFilePathName;



        private static string ModuleAttendance = "M04";
        private static string ModuleSwp = "M05";
        private static string ModuleRapReporting = "M07";
        private static string ModuleEmpGenInfo = "M11";
        private static string ModuleTcmplAppConfig = "M13";

        public Worker(ILogger<Worker> logger, IConfiguration configuration,
            IProcessDBLogger processDBLogger,
            IProcessDBStatus processDBStatus,
            IServiceProvider serviceProvider,
            IServiceScopeFactory serviceScopeFactory,
            ISWP iSWP,
            IRapReporting iRapReporting,
            IAttendance attendance,
            IEmpGenInfo empGenInfo,
            ITcmplAppConfig tcmplAppConfig
            )
        {
            _logger = logger;
            _processDBLogger = processDBLogger;
            _processDBStatus = processDBStatus;

            _serviceProvider = serviceProvider;
            _serviceScopeFactory = serviceScopeFactory;
            _configuration = configuration;

            _iSWP = iSWP;
            _iRapReporting = iRapReporting;
            _attendance = attendance;
            _empGenInfo = empGenInfo;
            _tcmplAppConfig = tcmplAppConfig;

            var delay = _configuration.GetSection("WorkerProcessDelayInMinutes").Value?.ToString();
            _boolGenerateDBLogs = _configuration.GetSection("GenerateDBLogs").Value?.ToString() == "true";

            _workerProcessDelayInMinutes = double.Parse(delay);
            _applicationErrorFilePathName = AppDomain.CurrentDomain.BaseDirectory + "Error.txt";

        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {

                _logger.LogInformation($"{DateTime.Now}: TCMPLApp worker process running.");
                DoWorkAsync().Wait(stoppingToken);

                await Task.Delay(TimeSpan.FromMinutes(_workerProcessDelayInMinutes), stoppingToken);
            }
        }

        public override Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation($"{DateTime.Now}: TCMPLApp worker process started.");

            return base.StartAsync(cancellationToken);
        }


        public override Task StopAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation($"{DateTime.Now}: TCMPLApp worker process stopped.");

            return base.StopAsync(cancellationToken);
        }

        private Task DoWorkAsync()
        {
            try
            {
                bool checkForpendingProcesses = true;


                IHttpClientTCMPLAppWebApi webApiClient = (IHttpClientTCMPLAppWebApi)_serviceProvider.GetService(typeof(IHttpClientTCMPLAppWebApi));


                while (checkForpendingProcesses)
                {
                    var response = webApiClient.ExecuteUriAsync(null, _uriPendingProcess).Result;

                    var pendingProcesses = HttpResponseHelper.ConvertResponseMessageToObject<IEnumerable<ProcessQueueModel>>(response);

                    if (pendingProcesses.Status != "OK")
                    {
                        _logger.LogError(pendingProcesses.Message);
                        break;
                    }

                    var processList = pendingProcesses.Data ?? Enumerable.Empty<ProcessQueueModel>();

                    if (!processList.Any())
                    {
                        checkForpendingProcesses = false;
                        break;
                    }
                    foreach (var currProcess in processList)
                    {
                        //Current process started
                        _processDBStatus.ProcessStarted(new HCModel { Keyid = currProcess.KeyId, LogMessage = "Processs started." });

                        _logger.LogInformation($"{DateTime.Now} Process Id: {currProcess.ProcessId}, Process Description: {currProcess.ProcessDesc}");
                        

                        //Current process being executed
                        WSMessageModel currProcessReturnMessage = null;
                        if (currProcess.ModuleId == ModuleSwp)
                        {
                            currProcessReturnMessage = _iSWP.ExecuteProcess(currProcess);
                        }
                        else if (currProcess.ModuleId == ModuleRapReporting)
                        {
                            currProcessReturnMessage = _iRapReporting.ExecuteProcess(currProcess);
                        }
                        else if (currProcess.ModuleId == ModuleAttendance)
                        {
                            currProcessReturnMessage = _attendance.ExecuteProcess(currProcess);
                        }
                        else if (currProcess.ModuleId == ModuleEmpGenInfo)
                        {
                            currProcessReturnMessage = _empGenInfo.ExecuteProcess(currProcess);
                        }
                        else if (currProcess.ModuleId == ModuleTcmplAppConfig)
                        {
                            currProcessReturnMessage = _tcmplAppConfig.ExecuteProcess(currProcess);
                        }


                        //Current process stopped
                        if (currProcessReturnMessage.Status == "OK")
                            _processDBStatus.StopWithSuccess(new HCModel { Keyid = currProcess.KeyId, LogMessage = currProcessReturnMessage.Message });
                        else
                            _processDBStatus.StopWithError(new HCModel { Keyid = currProcess.KeyId, LogMessage = currProcessReturnMessage.Message });

                    }
                }

            }
            catch (Exception ex)
            {
                _logger.LogError(ex?.InnerException?.ToString());
            }

            return Task.CompletedTask;
        }

    }
}