
using TCMPLAPP.WinService.Areas;
using TCMPLAPP.WinService.Services;

namespace TCMPLAPP.WinService
{
    public static class StartupExtensions
    {
        public static IServiceCollection AddServices(this IServiceCollection services)
        {
            services.AddTransient<IProcessDBLogger, ProcessDBLogger>();
            services.AddTransient<IProcessDBStatus, ProcessDBStatus>();
            services.AddTransient<ISWP, SWP>();
            services.AddTransient<IRapReporting, RapReporting>();
            services.AddTransient<IAttendance, Attendance>();
            services.AddTransient<IEmpGenInfo, EmpGenInfo>();
            services.AddTransient<ITcmplAppConfig, TcmplAppConfig>();

            return services;
        }
    }
}