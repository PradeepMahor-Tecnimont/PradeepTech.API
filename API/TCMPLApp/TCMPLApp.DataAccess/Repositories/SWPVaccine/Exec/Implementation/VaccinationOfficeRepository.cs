using System;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Domain.Context;
using Microsoft.Extensions.Configuration;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;
using System.Data;
using ClosedXML.Excel;
using System.IO;
using System.Collections.Generic;
using TCMPLApp.DataAccess.Base;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class VaccinationOfficeRepository : ExecRepository, IVaccinationOfficeRepository
    {
        readonly DataContext _dataContext;

        public VaccinationOfficeRepository(IConfiguration configuration, DataContext dataContext,ExecDBContext execDBContext) : base(execDBContext)
        {
            _dataContext = dataContext;
        }

        public IEnumerable<SwpBusRoute> BusRoutes()
        {
            return _dataContext.SwpBusRoutes.Select(b => b);
        }

        public async Task<ProcedureResult> AddRegistration(string userWinUid, VaccinationOffice vaccinationOffice)
        {
            var obj = new
            {
                param_win_uid = userWinUid,
                param_cowin_regtrd = vaccinationOffice.CowinRegistered,
                param_mobile_no = vaccinationOffice.CowinRegisteredMobile,
                param_office_bus = vaccinationOffice.CompanyBus,
                param_office_bus_route = vaccinationOffice.CompanyBusRoute,
                param_is_attending = vaccinationOffice.IsAttendingForJab,
                param_not_attending_reason = vaccinationOffice.ReasonForNotAttendingJab,
                param_jab_number = vaccinationOffice.JabNumber
            };
            var retVal = await ExecuteProc("selfservice.swp_office_vaccine.add_registration", obj);
            return retVal;
        }

        public async Task<SwpVaccinationOffice> GetRegistrationDetails(string userWinUid)
        {
            return await QueryFirstOrDefaultAsync<SwpVaccinationOffice>("select * from selfservice.Swp_Vaccination_Office where empno = selfservice.swp_users.get_empno_from_win_uid(:param_win_uid)", new { param_win_uid = userWinUid });
        }

        public async Task<SwpTplVaccineBatch> GetRegistrationBatch()
        {
            return await QueryFirstOrDefaultAsync<SwpTplVaccineBatch>("select * from selfservice.swp_tpl_vaccine_batch where batch_key_id='B0000002'");
        }

        public async Task<IEnumerable<VaccinationOfficeRegistrations>> GetRegistrationList()
        {
            string strSql = @"Select
                                vo.empno,
                                e.name employee_name,
                                e.parent,
                                c.name   dept_desc,
                                e.grade,
                                nvl(e.email, e.ad_email) email,
                                e.emptype,
                                Case
                                    When cowin_regtrd = 'OK' Then
                                        'Yes'
                                    Else
                                        'No'
                                End is_cowin_registred,
                                --cowin_regtrd,
                                mobile   mobile_number,
                                Case
                                    When office_bus = 'OK' Then
                                        'Office Bus'
                                    Else
                                        'Own Arrangements'
                                End mode_of_transport,
                                --office_bus,
                                office_bus_route,
                                Case
                                    When attending_vaccination = 'OK' Then
                                        'Yes'
                                    Else
                                        'No'
                                End is_attending_vaccination,
                                --attending_vaccination,
                                not_attending_reason,
                                jab_number
                            From
                                selfservice.swp_vaccination_office   vo,
                                selfservice.ss_emplmast              e,
                                selfservice.ss_costmast              c
                            Where
                                e.empno = vo.empno
                                And e.parent = c.costcode";

            return await QueryAsync<VaccinationOfficeRegistrations>(strSql);
        }


        public async Task<ProcedureResult> RemoveRegistration(string empno)
        {
            var obj = new
            {
                param_empno = empno,
            };
            var retVal = await ExecuteProc("selfservice.swp_office_vaccine.del_registration", obj);
            return retVal; 
        }

        public async Task<SwpEmployeeRegistrationBatch2> GetEmployeeRegistrationBatch2(string userWinUid)
        {
            string strSql = @"Select
                                *
                                From
                                    selfservice.swp_vaccination_office_batch_2
                                Where
                                    empno = selfservice.swp_users.get_empno_from_win_uid(
                                        :p_win_uid
                                    )";
            return await QueryFirstOrDefaultAsync<SwpEmployeeRegistrationBatch2>(strSql, new { p_win_uid = userWinUid });
        }


        public async Task<IEnumerable<SwpEmployeeFamilyRegistrationBatch2>> GetEmployeeFamilyRegistrationBatch2(string userWinUid)
        {
            string strSql = @"Select
                                *
                                From
                                    selfservice.SWP_VACCINATION_OFFICE_FAMILY
                                Where
                                    empno = selfservice.swp_users.get_empno_from_win_uid(
                                        :p_win_uid
                                    )";
            return await QueryAsync<SwpEmployeeFamilyRegistrationBatch2>(strSql, new { p_win_uid = userWinUid });
        }


    }
}
