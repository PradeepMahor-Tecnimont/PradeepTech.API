using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using NLog;
using System;
using System.IO;

namespace TCMPLApp
{
    public class Program
    {
        private static Logger _logger = LogManager.GetCurrentClassLogger();

        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)

                .ConfigureAppConfiguration(config =>
                {
                    var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");

                    if (environment == Environments.Staging || environment == Environments.Production)
                        config.AddJsonFile("C:\\AppConfig\\TCMPLApp\\WebApp\\TCMPLApp-WebApp-appSettings.json", optional: true, reloadOnChange: true);

                    //if (environment == Environments.Development)
                    //config.AddJsonFile("C:\\LocalHostAppConfig\\TCMPLApp\\WebApp\\TCMPLApp-WebApp-appSettings.json", optional: true, reloadOnChange: true);
                })
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                    //.ConfigureLogging(logging =>
                    //{
                    //    logging.ClearProviders();
                    //    logging.SetMinimumLevel(LogLevel.Information);
                    //    //logging.AddDebug();
                    //    //logging.AddConsole();
                    //})
                    //.UseNLog();
                })
                .ConfigureServices((hostContext, services) =>
                {
                    IConfiguration Configuration = hostContext.Configuration;

                    string logDir = Configuration.GetSection("TCMPLAppLogDirs")["BaseDir"];
                    string webAppDir = Configuration.GetSection("TCMPLAppLogDirs")["WebApp"];

                    string logDirectoryPath = Path.Combine(logDir, webAppDir);

                    LogManager.Configuration.Variables["logdir"] = logDirectoryPath;
                });
    }
}