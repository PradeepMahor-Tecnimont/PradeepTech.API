using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using NLog;
using NLog.Web;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;

namespace RapReportingApi
{
    public static class Program
    {
        private static Logger _logger = LogManager.GetCurrentClassLogger();
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();

        }

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureAppConfiguration((hostingContext, config) =>
                {
                    if ((hostingContext.HostingEnvironment.IsProduction() || hostingContext.HostingEnvironment.IsStaging()))
                    {
                        config.AddJsonFile("C:\\AppConfig\\TCMPLApp\\RAPApi\\TCMPLApp-RAPApi-appSettings.json", optional: true, reloadOnChange: true);

                    }
                })
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                })
                .ConfigureServices((hostContext, services) =>
                {
                    IConfiguration Configuration = hostContext.Configuration;

                    string logDir = Configuration.GetSection("TCMPLAppLogDirs")["BaseDir"];
                    string rapReportingDir = Configuration.GetSection("TCMPLAppLogDirs")["RapReporting"];

                    string logDirectoryPath = Path.Combine(logDir, rapReportingDir);

                    LogManager.Configuration.Variables["logdir"] = logDirectoryPath;
                });
    }
}