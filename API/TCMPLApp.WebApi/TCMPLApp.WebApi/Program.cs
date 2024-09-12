using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Server.IISIntegration;
using Microsoft.EntityFrameworkCore;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;
using TCMPLApp.WebApi.Classes;
using TCMPLApp.WebApi.Middleware;

using NLog;
using NLog.Web;
using System.Configuration;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;
using Irony.Ast;

namespace TCMPLApp.WebApi
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var builder = WebApplication.CreateBuilder(args);

            if (builder.Environment.IsStaging() || builder.Environment.IsProduction())
                builder.Configuration.AddJsonFile("C:\\AppConfig\\TCMPLApp\\Api\\TCMPLApp-Api-appSettings.json", optional: true, reloadOnChange: true);

            IConfiguration Configuration = builder.Configuration;

            string logDir = Configuration.GetSection("TCMPLAppLogDirs")["BaseDir"];
            string WebApiDir = Configuration.GetSection("TCMPLAppLogDirs")["WebApi"];

            string logDirectoryPath = Path.Combine(logDir, WebApiDir);

            LogManager.Configuration.Variables["logdir"] = logDirectoryPath;

            #region DB Context

            string connectionString = string.Empty;

            connectionString = builder.Configuration.GetConnectionString("TCMPLWebApiConnectString");

            builder.Services.AddDbContext<DataContext>(
                    options => options.UseOracle(
                                connectionString: connectionString,
                                oracleOptionsAction: oOA => oOA.UseOracleSQLCompatibility("12")
                            )
            );

            builder.Services.AddDbContext<ExecDBContext>(
                    options => options.UseOracle(
                                connectionString: connectionString,
                                oracleOptionsAction: oOA => oOA.UseOracleSQLCompatibility("12")
                            )
            );

            builder.Services.AddSingleton(s => new ViewTcmPLContextOption(disableCache: true));
            builder.Services.AddDbContext<ViewTcmPLContext>(options =>
                options.UseOracle(connectionString: connectionString,
                oracleOptionsAction =>
                {
                    //oracleOptionsAction.CommandTimeout(int.Parse(Configuration["AppSettings:CommandTimeoutSecond"]));
                    oracleOptionsAction.UseOracleSQLCompatibility("12");
                }
            ));

            builder.Services.AddSingleton(s => new ExecTcmPLContextOption(disableCache: true));
            builder.Services.AddDbContext<ExecTcmPLContext>(options =>
                options.UseOracle(connectionString: connectionString,
                oracleOptionsAction =>
                {
                    //oracleOptionsAction.CommandTimeout(int.Parse(Configuration["AppSettings:CommandTimeoutSecond"]));
                    oracleOptionsAction.UseOracleSQLCompatibility("12");
                }
            ));

            #endregion DB Context

            
            // Add services to the container.

            #region Logging

            builder.Logging.ClearProviders();

            builder.Services.AddLogging(loggingBuilder =>
                {
                    loggingBuilder.ClearProviders();
                    loggingBuilder.AddConfiguration(builder.Configuration.GetSection("Logging"));
                    loggingBuilder.AddNLogWeb();
                });
            //builder.Host.UseNLog();

            #endregion Logging

            builder.Services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            builder.Services.AddDataAccessService();

            builder.Services.AddTransient<IUserProfileRepository, UserProfileRepository>();
            builder.Services.AddScoped<UserIdentity, UserIdentity>();
            builder.Services.AddScoped<BaseSpTcmPL, BaseSpTcmPL>();

            builder.Services.AddTransient<IUtilityRepository, UtilityRepository>();

            builder.Services.AddAuthentication(IISDefaults.AuthenticationScheme);

            builder.Services.AddTransient<IDeemedEmpLoaAcceptanceRepository, DeemedEmpLoaAcceptanceRepository>();

            //services.AddRoleAuthorization<RoleProvider>();

            //builder.Services.AddSingleton<IAuthorizationPolicyProvider, RoleActionPolicyProvider>();

            //// As always, handlers must be provided for the requirements of the authorization policies
            //builder.Services.AddSingleton<IAuthorizationHandler, RoleActionAuthorizationHandler>();

            //builder.Services.AddHttpClient<IHttpClientRapReporting, HttpClientRapReporting>().ConfigurePrimaryHttpMessageHandler(() =>
            //{
            //    return new HttpClientHandler()
            //    {
            //        UseDefaultCredentials = true
            //    };
            //}
            //);
            //services.AddTransient<IExcelTemplate, ExcelTemplate>();

            builder.Services.AddControllers();
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }
            app.UseHsts();
            app.UseHttpsRedirection();
            app.UseMiddleware<ResponseHandleMiddleware>();

            app.UseMiddleware<IpSafeListMiddleware>();


            app.UseMiddleware<UserIdentityMiddleware>();

            
            

            app.UseAuthorization();

            app.MapControllers();

            app.Run();
        }
    }
}