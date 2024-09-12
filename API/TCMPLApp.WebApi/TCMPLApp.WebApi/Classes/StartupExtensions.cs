using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.Common;
using TCMPLApp.DataAccess.Repositories.WinService;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.Domain.Models;
using TCMPLApp.DataAccess.Repositories.SWP;
using TCMPLApp.DataAccess.Repositories.MailQueue;
using TCMPLApp.DataAccess.Repositories.RapReporting;
using TCMPLApp.DataAccess.Repositories.Attendance;
using TCMPLApp.DataAccess.Repositories.ERS;
using TCMPLApp.WebApi.Repositories;
using TCMPLApp.DataAccess.Repositories.EmpGenInfo;

namespace TCMPLApp.WebApi.Classes
{
    public static class StartupExtensions
    {
        public static IServiceCollection AddDataAccessService(this IServiceCollection services)
        {
            services.AddTransient<IUserProfileRepository, UserProfileRepository>();
            services.AddScoped<UserIdentity, UserIdentity>();
            services.AddScoped<BaseSpTcmPL, BaseSpTcmPL>();

            services.AddTransient<IUtilityRepository, UtilityRepository>();
            services.AddTransient<IWSQueueProcessesTableListRepository, WSQueueProcessesTableListRepository>();
            services.AddTransient<IWSQueueProcessesLoggerRepository, WSQueueProcessesLoggerRepository>();
            services.AddTransient<IWSQueueProcessesUpdateRepository, WSQueueProcessesUpdateRepository>();

            services.AddTransient<IMailQueueMailsAdd, MailQueueMailsAdd>();


            services.AddTransient<ISWPAttendanceStatusForDayDataTableListRepository, SWPAttendanceStatusForDayDataTableListRepository>();


            #region Rap Reporting
            services.AddTransient<ICostcodeGroupCostcodeDataTableListRepository, CostcodeGroupCostcodeDataTableListRepository>();
            #endregion

            #region SelfService
            services.AddTransient<IAttendancePunchUploadRepository, AttendancePunchUploadRepository>();
            services.AddTransient<IAttendanceEmpCardRFIDUploadRepository, AttendanceEmpCardRFIDUploadRepository>();
            #endregion

            #region ERS
            services.AddTransient<IHRVacanciesDataTableListRepository, HRVacanciesDataTableListRepository>();
            #endregion


            #region "PDF Generator"
            services.AddTransient<IPDFGenerator, PDFGenerator>();

            #endregion

            #region "Open Xml Generator"
            services.AddTransient<IHtmlToOpenXmlDoc, HtmlToOpenXmlDoc>();

            #endregion

            #region Employee General Info
            services.AddTransient<ICommonEmployeeDetailsRepository, CommonEmployeeDetailsRepository>();
            services.AddTransient<ILoAAddendumConsentDetailsRepository, LoAAddendumConsentDetailsRepository>();
            services.AddTransient<ILoAAddendumConsentUpdateRepository, LoAAddendumConsentUpdateRepository >();
            #endregion
            return services;
        }
    }
}