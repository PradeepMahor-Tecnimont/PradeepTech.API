using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface IEmployeeMasterViewRepository
    {        
        public Task<IEnumerable<EmployeeMasterMain>> GetEmployeeMasterListAsync(string curr_user);

        public Task<EmployeeMasterMain> EmployeeMainDetail(string id, string curr_user);

        public Task<EmployeeMasterAddress> EmployeeAddressDetail(string id, string curr_user);

        public Task<EmployeeMasterApplications> EmployeeApplicationsDetail(string id, string curr_user);

        public Task<EmployeeMasterOrganization> EmployeeOrganizationDetail(string id, string curr_user);

        public Task<IEnumerable<EmployeeMasterOrganizationQualificationDataTableList>> EmployeeOrganizationQualificationList(string id);

        public Task<EmployeeMasterRoles> EmployeeRolesDetail(string id, string curr_user);

        public Task<EmployeeMasterMisc> EmployeeMiscDetail(string id, string curr_user);

        public Task<IEnumerable<EmployeeMasterDownload>> GetEmployeeMasterDownload(int? statusflag);
    }
}
