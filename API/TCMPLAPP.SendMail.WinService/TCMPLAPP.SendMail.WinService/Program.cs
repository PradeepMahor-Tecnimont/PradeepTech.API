using Microsoft.EntityFrameworkCore;
using NLog.Extensions.Logging;
using TCMPLApp.SendMail.WinService.Services;
using TCMPLAPP.SendMail.WinService;
using TCMPLAPP.SendMail.WinService.Context;
using TCMPLAPP.SendMail.WinService.Repository;

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureAppConfiguration(config =>
    {

        var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

        if (environment == Environments.Staging || environment == Environments.Production)
            config.AddJsonFile("C:\\AppConfig\\TCMPLApp\\WinServices\\SendMail\\TCMPLApp-SendMail-WinService-appSettings.json", optional: true, reloadOnChange: true);

    })

    .ConfigureServices((hostContext, services) =>
    {
        IConfiguration Configuration = hostContext.Configuration;

        string connectionString = string.Empty;


        //if (hostContext.HostingEnvironment.IsProduction())
        //{
        //    connectionString = Configuration.GetSection("ProductionConnectString").Value.ToString() ?? "";
        //}
        //else if (hostContext.HostingEnvironment.IsProduction())
        //{
        //    connectionString = Configuration.GetSection("StaginConnectString").Value.ToString() ?? "";
        //}
        //else if (hostContext.HostingEnvironment.IsDevelopment())
        //{
        //    connectionString = Configuration.GetSection("DevelopmentConnectString").Value.ToString() ?? "";
        //}

        //connectionString = Configuration.GetSection("SendMailWinServiceConnectString").Value.ToString() ?? "";

        connectionString = Configuration.GetConnectionString("SendMailWinServiceConnectString");
        services.AddHostedService<Worker>();

        //var optionsBuilder = new DbContextOptionsBuilder<ViewTcmPLContext>();
        //optionsBuilder.UseOracle(connectionString: connectionString,
        //    oracleOptionsAction =>
        //    {
        //        //oracleOptionsAction.CommandTimeout(int.Parse(Configuration["AppSettings:CommandTimeoutSecond"]));
        //        oracleOptionsAction.UseOracleSQLCompatibility("11");
        //    });//,
        //services.AddScoped<ViewTcmPLContext>(s => new ViewTcmPLContext(optionsBuilder.Options));

        services.AddTransient<IMailQueueMailsTableListRepository, MailQueueMailsTableListRepository>();
        services.AddTransient<IMailQueueMailsRepository, MailQueueMailsRepository>();

        services.AddDbContext<ViewTcmPLContext>(options =>
            options.UseOracle(connectionString: connectionString ?? string.Empty,
            oracleOptionsAction =>
            {
                //oracleOptionsAction.CommandTimeout(int.Parse(Configuration["AppSettings:CommandTimeoutSecond"]));
                oracleOptionsAction.UseOracleSQLCompatibility("12");
            }
        ));


        services.AddDbContext<ExecTcmPLContext>(options =>
            options.UseOracle(connectionString: connectionString ?? string.Empty,
            oracleOptionsAction =>
            {
                //oracleOptionsAction.CommandTimeout(int.Parse(Configuration["AppSettings:CommandTimeoutSecond"]));
                oracleOptionsAction.UseOracleSQLCompatibility("12");
            }
        ));


        services.AddLogging(loggingBuilder =>
        {

            loggingBuilder.ClearProviders();
            loggingBuilder.AddConfiguration(Configuration.GetSection("Logging"));

            loggingBuilder.AddNLog();
        });
        //services.AddMvc();




        services.AddHttpClient<IHttpClientTCMPLApp, HttpClientTCMPLApp>().ConfigurePrimaryHttpMessageHandler(() =>
        {
            return new HttpClientHandler()
            {
                UseDefaultCredentials = true
            };
        }
);

    })
    .UseWindowsService()
    .Build();

await host.RunAsync();
