using Newtonsoft.Json;
using TCMPLApp.RAPReporting.WinService.Services;

namespace TCMPLApp.RAPReporting.WinService
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;

        private readonly AppSettings _appSettings;
        private readonly IConfiguration _configuration;
        private readonly IServiceProvider _serviceProvider;

        private const string constCheckForJobsYes = "YES";
        private const string constCheckForJobsNo = "NO";

        private readonly double _workerProcessDelayInMinutes;


        public Worker(ILogger<Worker> logger, IConfiguration configuration, IServiceProvider serviceProvider)
        {
            _appSettings = new AppSettings();
            _logger = logger;
            _configuration = configuration;
            _configuration.Bind(_appSettings);
            _serviceProvider = serviceProvider;

            var delay = _configuration.GetSection("WorkerProcessDelayInMinutes").Value.ToString();
            _workerProcessDelayInMinutes = double.Parse(delay);

        }

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);
                DoWorkAsync();

                await Task.Delay(TimeSpan.FromMinutes(_workerProcessDelayInMinutes), stoppingToken);

                //await Task.Delay(180000, stoppingToken);   //180000

            }
        }

        public override Task StartAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation($"{DateTime.Now}: Worker started.");


            return base.StartAsync(cancellationToken);
        }


        public override Task StopAsync(CancellationToken cancellationToken)
        {
            _logger.LogInformation($"{DateTime.Now}:Worker stopped. ");

            return base.StopAsync(cancellationToken);
        }

        private void DoWorkAsync()
        {
            string checkForJobs = constCheckForJobsYes;
            try
            {
                IHttpClientRapReporting _httpClientRapReporting = (IHttpClientRapReporting)_serviceProvider.GetService(typeof(IHttpClientRapReporting));

                string urlGetList4WorkerProcess = _appSettings.WinServiceAppSettings.urlGetList4WorkerProcess;

                while (checkForJobs == constCheckForJobsYes)
                {
                    var returnResponse = _httpClientRapReporting.ExecuteUriAsync(null, urlGetList4WorkerProcess).Result;
                    returnResponse.EnsureSuccessStatusCode();
                    if (returnResponse.IsSuccessStatusCode)
                    {
                        var fileJsonString = returnResponse.Content.ReadAsStringAsync().Result;
                        RapRptProcessObj rapRptProcessObj = JsonConvert.DeserializeObject<RapRptProcessObj>(fileJsonString);


                        if (rapRptProcessObj.data.Value.Count == 0)
                        {
                            checkForJobs = constCheckForJobsNo;
                            _logger.LogInformation($"{DateTime.Now}: No Report Scheduled.");
                            return;
                        }
                        else
                        {
                            try
                            {
                                checkForJobs = constCheckForJobsYes;
                                foreach (var row in rapRptProcessObj.data.Value)
                                {
                                    var reportID = row.reportid.ToString();
                                    _logger.LogInformation($"{DateTime.Now}: " + reportID + " report has been scheduled.");

                                    switch (row.reportid.ToString())
                                    {
                                        case "CHA1E":
                                            RAPLib.bulkDownload(
                                                                keyid: row.keyid.ToString(),
                                                                user: row.userid.ToString(),
                                                                yyyy: row.yyyy.ToString(),
                                                                yymm: row.yymm.ToString(),
                                                                yearmode: row.yearmode.ToString(),
                                                                reportid: row.reportid.ToString(),
                                                                reportMode: "SINGLE",
                                                                appSettings: _appSettings,
                                                                logger: _logger,
                                                                serviceProvider: _serviceProvider

                                                                ).Wait();

                                            break;

                                        case "CHA1STA6TM02":
                                            RAPLib.bulkCha1Sta6Tm02Download(
                                                                           keyid: row.keyid.ToString(),
                                                                           user: row.userid.ToString(),
                                                                           yyyy: row.yyyy.ToString(),
                                                                           yymm: row.yymm.ToString(),
                                                                           yearmode: row.yearmode.ToString(),
                                                                           reportid: row.reportid.ToString(),
                                                                           appSettings: _appSettings,
                                                                           logger: _logger,
                                                                           serviceProvider: _serviceProvider
                                                                           ).Wait();
                                            break;

                                        case "TM01Dupl":
                                            RAPLib.bulkTM01DuplDownload(
                                                                        keyid: row.keyid.ToString(),
                                                                        user: row.userid.ToString(),
                                                                        yyyy: row.yyyy.ToString(),
                                                                        yymm: row.yymm.ToString(),
                                                                        yearmode: row.yearmode.ToString(),
                                                                        simul: "",
                                                                        reportid: row.reportid.ToString(),
                                                                        appSettings: _appSettings,
                                                                        logger: _logger,
                                                                        serviceProvider: _serviceProvider
                                                                        ).Wait();
                                            break;
                                        case "CHA1ExptEngg":
                                        case "CHA1ExptEnggMumbai":
                                        case "CHA1ExptEnggDelhi":
                                        case "Cha1ExptNonEngg":
                                        case "Cha1ExptNonEnggMumbai":
                                        case "Cha1ExptNonEnggDelhi":
                                        case "Cha1ExptEnggNonEngg":
                                        case "Cha1ExptEnggNonEnggMumbai":
                                        case "Cha1ExptEnggNonEnggDelhi":
                                        case "CHA1ExptEnggS":
                                        case "CHA1ExptEnggMumbaiS":
                                        case "CHA1ExptEnggDelhiS":
                                        case "Cha1ExptNonEnggS":
                                        case "Cha1ExptNonEnggMumbaiS":
                                        case "Cha1ExptNonEnggDelhiS":
                                        case "Cha1ExptEnggNonEnggS":
                                        case "Cha1ExptEnggNonEnggMumbaiS":
                                        case "Cha1ExptEnggNonEnggDelhiS":
                                            RAPLib.bulkCha1ExptDownload(
                                                                       keyid: row.keyid.ToString(),
                                                                       user: row.userid.ToString(),
                                                                       yyyy: row.yyyy.ToString(),
                                                                       yymm: row.yymm.ToString(),
                                                                       yearmode: row.yearmode.ToString(),
                                                                       category: row.category.ToString(),
                                                                       simul: row.simul?.ToString(),
                                                                       reportid: row.reportid.ToString(),
                                                                       appSettings: _appSettings,
                                                                       logger: _logger,
                                                                       serviceProvider: _serviceProvider
                                                                       ).Wait();
                                            break;
                                        case "TMAProcoDetail":
                                        case "TMAProcoSummary":
                                        case "TMAAFCDetail":
                                        case "TMAAFCSummary":
                                        case "TMAMngtDetail":
                                        case "TMAMngtSummary":
                                            RAPLib.bulkTMADownload(
                                                                    keyid: row.keyid.ToString(),
                                                                    user: row.userid.ToString(),
                                                                    yyyy: row.yyyy.ToString(),
                                                                    yymm: row.yymm.ToString(),
                                                                    yearmode: row.yearmode.ToString(),
                                                                    reporttype: row.reporttype.ToString(),
                                                                    reportid: row.reportid.ToString(),
                                                                    appSettings: _appSettings,
                                                                    logger: _logger,
                                                                    serviceProvider: _serviceProvider
                                                                    ).Wait();
                                            break;
                                        case "TCMJobsGrp":
                                            RAPLib.bulkTCMJobsGrp(
                                                                    keyid: row.keyid.ToString(),
                                                                    user: row.userid.ToString(),
                                                                    yyyy: row.yyyy.ToString(),
                                                                    yymm: row.yymm.ToString(),
                                                                    yearmode: row.yearmode.ToString(),
                                                                    reportid: row.reportid.ToString(),
                                                                    appSettings: _appSettings,
                                                                    logger: _logger,
                                                                    serviceProvider: _serviceProvider
                                                                    ).Wait();
                                            break;
                                    }
                                    _logger.LogInformation($"{DateTime.Now}: " + reportID + "  report has been Finished.");
                                }
                            }
                            catch (Exception ex)
                            {
                                _logger.LogError(ex, "Error while executing report");
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex?.InnerException?.ToString());
            }
        }
    }
}