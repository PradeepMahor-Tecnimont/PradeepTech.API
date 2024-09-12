using NLog.Extensions.Logging;
using TCMPLApp.RAPReporting.WinService;
using TCMPLApp.RAPReporting.WinService.Services;

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices((hostContext, services) =>
    {
        services.AddHostedService<Worker>();        

        services.AddLogging(loggingBuilder =>
        {
            IConfiguration Configuration = hostContext.Configuration;

            loggingBuilder.ClearProviders();
            loggingBuilder.AddConfiguration(Configuration.GetSection("Logging"));

            loggingBuilder.AddNLog();
        });

        services.AddHttpClient<IHttpClientRapReporting, HttpClientRapReporting>().ConfigurePrimaryHttpMessageHandler(() =>
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
