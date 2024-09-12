using NLog.Extensions.Logging;
using TCMPLAPP.WinService.Services;
using TCMPLAPP.WinService;
using NLog;


IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureAppConfiguration((context, builder) =>
    {
        //var environment = Environment.GetEnvironmentVariable("DOTNET_ENVIRONMENT");
        if (context.HostingEnvironment.IsStaging() || context.HostingEnvironment.IsProduction())
        {
            builder.AddJsonFile(@"C:\AppConfig\TCMPLApp\WinServices\TCMPLApp-WorkerProc-WinService-appSettings.json", optional: true, reloadOnChange: true);
            builder.Build();
        }
        //if (environment == Environments.Staging || environment == Environments.Production || environment == Environments.Development)
        //    config.AddJsonFile("C:\\AppConfig\\TCMPLApp\\TCMPLApp-WorkerProc-WinService-appSettings.json", optional: true, reloadOnChange: true);
    })
    .ConfigureServices((hostContext, services) =>
    {
        IConfiguration Configuration = hostContext.Configuration;

        services.AddHostedService<Worker>();

        services.AddServices();

        string logDir = Configuration.GetSection("TCMPLAppLogDirs")["BaseDir"];
        string winServiceDir = Configuration.GetSection("TCMPLAppLogDirs")["WinService"];

        string logDirectoryPath = Path.Combine(logDir, winServiceDir);

        LogManager.Configuration.Variables["logdir"] = logDirectoryPath;
        services.AddLogging(loggingBuilder =>
        {

            loggingBuilder.ClearProviders();
            loggingBuilder.AddConfiguration(Configuration.GetSection("Logging"));

            loggingBuilder.AddNLog();
        });


        services.AddHttpClient<IHttpClientTCMPLAppWebApi, HttpClientTCMPLAppWebApi>().ConfigurePrimaryHttpMessageHandler(() =>
        {
            return new HttpClientHandler()
            {
                UseDefaultCredentials = true
            };
        });

        services.AddHttpClient<IHttpClientRapReporting, HttpClientRapReporting>().ConfigurePrimaryHttpMessageHandler(() =>
        {
            return new HttpClientHandler()
            {
                UseDefaultCredentials = true
            };
        });

    })
    .UseWindowsService()
    .Build();

await host.RunAsync();
