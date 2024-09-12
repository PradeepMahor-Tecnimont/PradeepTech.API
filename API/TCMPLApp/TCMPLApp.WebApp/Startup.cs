using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Server.IISIntegration;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using NLog.Web;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Net.Http;
using System.Reflection;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.DataAccess.Repositories.Timesheet;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;
using TCMPLApp.Library.Excel.Template;
using TCMPLApp.WebApp;
using TCMPLApp.WebApp.CustomPolicyProvider;
using TCMPLApp.WebApp.Extensions;
using TCMPLApp.WebApp.Middleware;
using TCMPLApp.WebApp.Services;

namespace TCMPLApp
{
    public class Startup
    {
        public Startup(IConfiguration configuration, IWebHostEnvironment env)
        {
            _configuration = configuration;
        }

        public IConfiguration _configuration { get; }

        private string connectionString = string.Empty;

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllersWithViews();

            #region DB Context

            //if (IsProductionEnvironment)
            //    connectionString = _configuration.GetConnectionString("ProductionConnectString");
            //else if (IsStagingEnvironment)
            //    connectionString = _configuration.GetConnectionString("StagingConnectString");
            //else
            //    connectionString = _configuration.GetConnectionString("DevelopmentConnectString");

            connectionString = _configuration.GetConnectionString("TCMPLWebAppConnectString");


            //if (IsDevelopmentEnvironment || IsStagingEnvironment)
            //{
            //    dbCompatibilityVersion = "12";
            //}

            services.AddDbContext<DataContext>(
                    options => options.UseOracle(
                                connectionString: connectionString,
                                oracleOptionsAction: oOA => oOA.UseOracleSQLCompatibility(OracleSQLCompatibility.DatabaseVersion19)
                            )
            );

            services.AddDbContext<ExecDBContext>(
                    options => options.UseOracle(
                                connectionString: connectionString,
                                oracleOptionsAction: oOA => oOA.UseOracleSQLCompatibility(OracleSQLCompatibility.DatabaseVersion19)
                            )
            );

            services.AddSingleton(s => new ViewTcmPLContextOption(disableCache: true));
            services.AddDbContext<ViewTcmPLContext>(options =>
                options.UseOracle(connectionString: connectionString,
                oracleOptionsAction =>
                {
                    //oracleOptionsAction.CommandTimeout(int.Parse(Configuration["AppSettings:CommandTimeoutSecond"]));
                    oracleOptionsAction.UseOracleSQLCompatibility(OracleSQLCompatibility.DatabaseVersion19);
                }
            ));

            services.AddSingleton(s => new ExecTcmPLContextOption(disableCache: true));
            services.AddDbContext<ExecTcmPLContext>(options =>
                options.UseOracle(connectionString: connectionString,
                oracleOptionsAction =>
                {
                    //oracleOptionsAction.CommandTimeout(int.Parse(Configuration["AppSettings:CommandTimeoutSecond"]));
                    oracleOptionsAction.UseOracleSQLCompatibility(OracleSQLCompatibility.DatabaseVersion19);
                }
            ));

            #endregion DB Context

            #region Localization

            services.AddSingleton<SharedViewLocalizer>();

            services.AddMvc()
                .AddViewLocalization()
                .AddDataAnnotationsLocalization(options =>
                {
                    options.DataAnnotationLocalizerProvider = (type, factory) =>
                    {
                        var assemblyName = new AssemblyName(typeof(SharedResource).GetTypeInfo().Assembly.FullName);
                        return factory.Create("SharedResource", assemblyName.Name);
                    };
                });

            services.Configure<RequestLocalizationOptions>(
                options =>
                {
                    var supportedCultures = new List<CultureInfo>
                        {
                            new CultureInfo("en-US"),
                            new CultureInfo("it-IT")
                        };

                    options.DefaultRequestCulture = new RequestCulture(culture: "en-US", uiCulture: "en-US");
                    options.SupportedCultures = supportedCultures;
                    options.SupportedUICultures = supportedCultures;
                });

            #endregion Localization

            #region Logging

            services.AddLogging(loggingBuilder =>
            {
                loggingBuilder.ClearProviders();
                loggingBuilder.AddConfiguration(_configuration.GetSection("Logging"));
                loggingBuilder.AddNLogWeb();
            });

            #endregion Logging

            services.AddSingleton<IHttpContextAccessor, HttpContextAccessor>();
            services.AddDataAccessService();

            services.AddTransient<IUserProfileRepository, UserProfileRepository>();

            services.AddTransient<IUserRolesActionsRepository, UserRolesActionsRepository>();

            services.AddScoped<UserIdentity, UserIdentity>();
            services.AddScoped<BaseSpTcmPL, BaseSpTcmPL>();

            services.AddTransient<IUtilityRepository, UtilityRepository>();
            services.AddTransient<IOpenXMLUtilityRepository, OpenXMLUtilityRepository>();

            services.AddAuthentication(IISDefaults.AuthenticationScheme);

            //services.AddRoleAuthorization<RoleProvider>();

            services.AddSingleton<IAuthorizationPolicyProvider, RoleActionPolicyProvider>();

            // As always, handlers must be provided for the requirements of the authorization policies
            services.AddSingleton<IAuthorizationHandler, RoleActionAuthorizationHandler>();

            services.AddHttpClient<IHttpClientRapReporting, HttpClientRapReporting>().ConfigurePrimaryHttpMessageHandler(() =>
                {
                    return new HttpClientHandler()
                    {
                        UseDefaultCredentials = true
                    };
                }
            );

            services.AddHttpClient<IHttpClientWebApi, HttpClientWebApi>().ConfigurePrimaryHttpMessageHandler(() =>
                {
                    return new HttpClientHandler()
                    {
                        UseDefaultCredentials = true
                    };
                }
            );

            services.AddTransient<IExcelTemplate, ExcelTemplate>();

            services.AddMvc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, IHostApplicationLifetime appLifetime)
        {
            if (env.IsDevelopment())
            {
                //app.UseDeveloperExceptionPage();

                app.UseExceptionHandler("/Error/Details");
            }
            else
            {
                app.UseExceptionHandler("/Error");
            }

            app.UseHsts();
            app.UseHttpsRedirection();

            if (env.IsDevelopment())
                HelperTcmPL.InitializeEnv(HelperTcmPL.EnvOptions.Development);
            else if (env.IsStaging())
                HelperTcmPL.InitializeEnv(HelperTcmPL.EnvOptions.Staging);
            else if (env.IsProduction())
                HelperTcmPL.InitializeEnv(HelperTcmPL.EnvOptions.Production);

            app.UseStatusCodePagesWithReExecute("/Error/StatusCodePages", "?statusCode={0}");

            //app.UseStatusCodePages(async context => {
            //    if (context.HttpContext.Response.StatusCode == 403)
            //    {
            //        context.HttpContext.Response.Redirect("/Error/AccessDenied");
            //    }
            //});

            //app.UseStatusCodePages();

            app.UseStaticFiles();

            app.UseRouting();

            app.UseMiddleware<ExceptionMiddleware>();

            app.UseAuthentication();
            app.UseMiddleware<UserIdentityMiddleware>();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapAreaControllerRoute(name: "offboarding", areaName: "offboarding", pattern: "OffBoarding/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "swpvaccine", areaName: "swpvaccine", pattern: "SWPVaccine/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "hrmasters", areaName: "hrmasters", pattern: "HRMasters/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "selfservice", areaName: "selfservice", pattern: "SelfService/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "DigiForm", areaName: "DigiForm", pattern: "DigiForm/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "SWP", areaName: "SWP", pattern: "SWP/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "Desk Management", areaName: "DMS", pattern: "DMS/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "Rap Reporting", areaName: "RapReporting", pattern: "RapReporting/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "Letter of credit", areaName: "LC", pattern: "LC/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "Bank guarantee", areaName: "BG", pattern: "BG/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "Employee general info", areaName: "EmpGenInfo", pattern: "EmpGenInfo/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "MailQueue", areaName: "MailQueue", pattern: "MailQueue/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "Health Safety and Environment", areaName: "HSE", pattern: "HSE/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "Job Master", areaName: "JOB", pattern: "JOB/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "Employee Referral Program", areaName: "ERS", pattern: "ERS/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "RSVP", areaName: "RSVP", pattern: "RSVP/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "Timesheet", areaName: "Timesheet", pattern: "Timesheet/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "CoreSettings", areaName: "CoreSettings", pattern: "CoreSettings/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "DeskBooking", areaName: "DeskBooking", pattern: "DeskBooking/{controller=Home}/{action=Index}/{id?}");
                endpoints.MapAreaControllerRoute(name: "Logbook", areaName: "Logbook", pattern: "Logbook/{controller=Logbook}/{action=Index}/{id?}");
                endpoints.MapControllerRoute(name: "default", pattern: "{controller=Home}/{action=Index}/{id?}");
            });

            appLifetime.ApplicationStarted.Register(OnStarted);
        }

        private void OnStarted()
        {
            //Create PhotoICard directory

            //var baseRepository = _configuration["TCMPLAppBaseRepository"];
            //var tcmplAppBaseRepository = _configuration["TCMPLAppBaseRepository"];
            //var icardPhotoRepository = _configuration["AreaRepository:ICardPhoto"];
            //var icardPhotoConsentedRepository = _configuration["AreaRepository:ICardPhotoConsented"];

            var tcmplAppDownloadRepository = _configuration["TCMPLAppDownloadRepository"];
            var tcmplAppTemplatesRepository = _configuration["TCMPLAppTemplatesRepository"];

            //string icardPhotoDir = Path.Combine(tcmplAppBaseRepository, icardPhotoRepository);
            //string icardPhotoConsentedDir = Path.Combine(tcmplAppBaseRepository, icardPhotoConsentedRepository);

            //if (Directory.Exists(icardPhotoDir) == false)
            //    Directory.CreateDirectory(icardPhotoDir);
            //if (Directory.Exists(icardPhotoConsentedDir) == false)
            //    Directory.CreateDirectory(icardPhotoConsentedDir);

            if (Directory.Exists(tcmplAppDownloadRepository) == false)
                Directory.CreateDirectory(tcmplAppDownloadRepository);
            if (Directory.Exists(tcmplAppTemplatesRepository) == false)
                Directory.CreateDirectory(tcmplAppTemplatesRepository);
        }
    }
}