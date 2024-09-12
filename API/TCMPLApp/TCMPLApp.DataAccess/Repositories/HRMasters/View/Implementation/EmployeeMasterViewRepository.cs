using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class EmployeeMasterViewRepository : Base.ExecRepository, IEmployeeMasterViewRepository
    {
        public EmployeeMasterViewRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {
            
        }
        public async Task<IEnumerable<EmployeeMasterMain>> GetEmployeeMasterListAsync(string curr_user)
        {
            return await QueryAsync<EmployeeMasterMain>(HRMastersQueries.EmployeeMasterList,new { pUser = curr_user });
        }

        public async Task<EmployeeMasterMain> EmployeeMainDetail(string id, string curr_user)
        {
            return await QueryFirstOrDefaultAsync<EmployeeMasterMain>(HRMastersQueries.EmployeeMainDetail, new { pEmpno = id, pUser = curr_user });
        }

        public async Task<EmployeeMasterAddress> EmployeeAddressDetail(string id, string curr_user)
        {
            return await QueryFirstOrDefaultAsync<EmployeeMasterAddress>(HRMastersQueries.EmployeeMasterAddressDetail, new { pEmpno = id, pUser = curr_user });
        }

        public async Task<EmployeeMasterApplications> EmployeeApplicationsDetail(string id, string curr_user)
        {
            return await QueryFirstOrDefaultAsync<EmployeeMasterApplications>(HRMastersQueries.EmployeeMasterApplicationsDetail, new { pEmpno = id, pUser = curr_user });
        }

        public async Task<EmployeeMasterOrganization> EmployeeOrganizationDetail(string id, string curr_user)
        {
            return await QueryFirstOrDefaultAsync<EmployeeMasterOrganization>(HRMastersQueries.EmployeeMasterOrganizationDetail, new { pEmpno = id, pUser = curr_user });
        }

        public async Task<IEnumerable<EmployeeMasterOrganizationQualificationDataTableList>> EmployeeOrganizationQualificationList(string id)
        {
            return await QueryAsync<EmployeeMasterOrganizationQualificationDataTableList>(HRMastersQueries.EmployeeMasterOrganizationQualificationList, new { pEmpno = id });
        }

        public async Task<EmployeeMasterRoles> EmployeeRolesDetail(string id, string curr_user)
        {
            return await QueryFirstOrDefaultAsync<EmployeeMasterRoles>(HRMastersQueries.EmployeeMasterRolesDetail, new { pEmpno = id, pUser = curr_user });
        }

        public async Task<EmployeeMasterMisc> EmployeeMiscDetail(string id, string curr_user)
        {
            return await QueryFirstOrDefaultAsync<EmployeeMasterMisc>(HRMastersQueries.EmployeeMasterMiscDetail, new { pEmpno = id, pUser = curr_user });
        }

        public async Task<IEnumerable<EmployeeMasterDownload>> GetEmployeeMasterDownload(int? statusflag)
        {
            return await QueryAsync<EmployeeMasterDownload>(HRMastersQueries.EmployeeMasterDownload, new { pStatus = statusflag });
        }

    }
}
