using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface IEmployeeMasterRepository
    {
        public Task<EmployeeMasterMainAdd> AddEmployee(EmployeeMasterMainAdd employeeMasterMainAdd);

        public Task<EmployeeMasterMainEdit> EditEmployeeMain(EmployeeMasterMainEdit employeeMasterMainEdit);

        public Task<EmployeeDeactivate> DeactivateEmployee(EmployeeDeactivate employeeDeactivate);

        public Task<EmployeeActivate> ActivateEmployee(EmployeeActivate employeeActivate);

        public Task<EmployeeClone> CloneEmployee(EmployeeClone employeeClone);

        public Task<EmployeeMasterAddressUpdate> UpdateEmployeeAddress(EmployeeMasterAddressUpdate employeeMasterAddressUpdate);

        public Task<EmployeeMasterApplicationsUpdate> UpdateEmployeeApplications(EmployeeMasterApplicationsUpdate employeeMasterApplicationsUpdate);

        public Task<EmployeeMasterOrganizationUpdate> UpdateEmployeeOrganization(EmployeeMasterOrganizationUpdate employeeMasterOrganizationUpdate);

        public Task<EmployeeMasterRolesUpdate> UpdateEmployeeRoles(EmployeeMasterRolesUpdate employeeMasterRolesUpdate);

        public Task<EmployeeMasterMiscUpdate> UpdateEmployeeMisc(EmployeeMasterMiscUpdate employeeMasterMiscUpdate);

    }
}
