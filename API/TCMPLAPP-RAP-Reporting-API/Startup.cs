using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.IISIntegration;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using NLog.Extensions.Logging;
using RapReportingApi.Middleware;
using RapReportingApi.Models;
using RapReportingApi.RAPEntityModels;
using RapReportingApi.Repositories;
using RapReportingApi.Repositories.HRMasters;
using RapReportingApi.Repositories.Interfaces;
using RapReportingApi.Repositories.Interfaces.Mast;
using RapReportingApi.Repositories.Interfaces.Rpt;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.CC;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.CC.proj;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.Mgmt;
using RapReportingApi.Repositories.Interfaces.Rpt.Cmplx.proco;
using RapReportingApi.Repositories.Interfaces.User;
using RapReportingApi.Repositories.Mast;
using RapReportingApi.Repositories.Rpt;
using RapReportingApi.Repositories.Rpt.Cmplx.CC;
using RapReportingApi.Repositories.Rpt.Cmplx.CC.proj;
using RapReportingApi.Repositories.Rpt.Cmplx.Mgmt;
using RapReportingApi.Repositories.Rpt.Cmplx.proco;
using RapReportingApi.Repositories.User;
using TIMESHEEET_API.Middleware;

namespace RapReportingApi
{
    public class Startup
    {
        private AppSettings oAppSettings = new AppSettings();
        private IWebHostEnvironment _env { get; set; }

        public Startup(IConfiguration configuration, IWebHostEnvironment env)
        {
            Configuration = configuration;
            _env = env;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.Configure<AppSettings>(Configuration);

            //AppSettings oAppSettings = new AppSettings();
            Configuration.Bind(oAppSettings);
            //oAppSettings.TCMPLAppBaseRepository = Configuration.GetSection("TCMPLAppBaseRepository").Value.ToString();
            //oAppSettings.TCMPLAppBaseRepository = Configuration.GetValue<string>("TCMPLAppBaseRepository");
            services.AddLogging(loggingBuilder =>
            {
                loggingBuilder.ClearProviders();
                loggingBuilder.AddConfiguration(Configuration.GetSection("Logging"));
                loggingBuilder.AddNLog(Configuration);
            }
            );

            services.AddTransient<IMastdownloadRepository, MastdownloadRepository>();

            //Simple Reports
            services.AddTransient<IBeforePostCCRepository, BeforePostCCRepository>();
            services.AddTransient<IBeforePostProjRepository, BeforePostProjRepository>();

            services.AddTransient<IProcoRepository, ProcoRepository>();

            //AfterPost
            services.AddTransient<IAfterPostProjRepository, AfterPostProjRepository>();
            services.AddTransient<IAfterPostCostRepository, AfterPostCostRepository>();
            services.AddTransient<IAfterPostAFCRepository, AfterPostAFCRepository>();
            services.AddTransient<IHRRepository, HRRepository>();
            services.AddTransient<IUnPivotReportRepository, UnPivotReportRepository>();
            services.AddTransient<IMasterRepository, MasterRepository>();

            //Complex Reports
            services.AddTransient<ICha1Sta6Tm02Repository, Cha1Sta6Tm02Repository>();
            services.AddTransient<ICHA01ERepository, CHA01ERepository>();
            services.AddTransient<IDuplTm02Repository, DuplTm02Repository>();
            services.AddTransient<ITMARepository, TMARepository>();
            services.AddTransient<ITM11TM01GRepository, TM11TM01GRepository>();
            services.AddTransient<IComplexProcoRepository, ComplexProcoRepository>();
            services.AddTransient<IWorkloadRepository, WorkloadRepository>();
            services.AddTransient<ITM01AllRepository, TM01AllRepository>();
            services.AddTransient<IResourceRepository, ResourceRepository>();
            services.AddTransient<ICHA1EGRPRepository, CHA1EGRPRepository>();
            services.AddTransient<IBreakupRepository, BreakupRepository>();

            // HR Masters
            services.AddTransient<IHRMastersReportRepository, HRMastersReportRepository>();

            // User
            services.AddTransient<IUserRepository, UserRepository>();

            services.AddAuthentication(IISDefaults.AuthenticationScheme);


            //Fetching Connection string from APPSETTINGS.JSON
            //var ConnectionString = Configuration.GetConnectionString("OraDbConstr");

            //Entity Framework

            services.AddDbContext<RAPDbContext>(options => options.UseOracle(
                connectionString: oAppSettings.RAPAppSettings.RAPApiConnectionString,
                oracleOptionsAction: oOA => oOA.UseOracleSQLCompatibility( OracleSQLCompatibility.DatabaseVersion19)
                ));

            services.AddControllers().AddNewtonsoftJson(options =>
                options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
            );



            services.AddMvcCore();

            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            services.AddEndpointsApiExplorer();
            services.AddSwaggerGen();


            //            //services.AddControllers(mvcOptions => mvcOptions.EnableEndpointRouting = false);
            //            services.AddMvc(option => option.EnableEndpointRouting = false);

            //            services.AddOData();
            //            services.AddMvc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI();

            }
            app.UseHsts();
            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseAuthorization();

            //app.UseMvc(routeBuilder =>
            //{
            //    routeBuilder.EnableDependencyInjection();
            //    routeBuilder.Select().Expand().Filter().MaxTop(100).OrderBy().Count();
            //    //routeBuilder.MapODataServiceRoute("odata", "odata", GetEdmModel());

            //});

            app.UseMiddleware<SetHeaderUserIdentity>();

            if (oAppSettings.RAPAppSettings.IsEncryptionEnable)
            {
                app.UseMiddleware<RequestDecryptMiddleWare>();
            }

            app.UseResponseHandlingMiddleware();



            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();



                //endpoints.EnableDependencyInjection();
                //endpoints
                //    .Select()
                //    .Expand()
                //    .Filter()
                //    .OrderBy()
                //    .MaxTop(2000)
                //    .Count();

                //endpoints.MapODataRoute("odata", "api/rap", GetEdmModelSingle());
            });


        }

       
    }
}