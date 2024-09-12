using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class EmployeeMasterRepository : Base.ExecRepository, IEmployeeMasterRepository
    {
        public EmployeeMasterRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        public async Task<EmployeeMasterMainAdd> AddEmployee(EmployeeMasterMainAdd employeeMasterMainAdd)
        {
            return await ExecuteProcAsync(employeeMasterMainAdd);
        }

        public async Task<EmployeeMasterMainEdit> EditEmployeeMain(EmployeeMasterMainEdit employeeMasterMainEdit)
        {
            return await ExecuteProcAsync(employeeMasterMainEdit);
        }

        public async Task<EmployeeMasterAddressUpdate> UpdateEmployeeAddress(EmployeeMasterAddressUpdate employeeMasterAddressUpdate)
        {
            return await ExecuteProcAsync(employeeMasterAddressUpdate);
        }

        public async Task<EmployeeMasterApplicationsUpdate> UpdateEmployeeApplications(EmployeeMasterApplicationsUpdate employeeMasterApplicationsUpdate)
        {
            return await ExecuteProcAsync(employeeMasterApplicationsUpdate);
        }

        public async Task<EmployeeMasterOrganizationUpdate> UpdateEmployeeOrganization(EmployeeMasterOrganizationUpdate employeeMasterOrganizationUpdate)
        {
            return await ExecuteProcAsync(employeeMasterOrganizationUpdate);
        }

        public async Task<EmployeeMasterRolesUpdate> UpdateEmployeeRoles(EmployeeMasterRolesUpdate employeeMasterRolesUpdate)
        {
            return await ExecuteProcAsync(employeeMasterRolesUpdate);
        }

        public async Task<EmployeeMasterMiscUpdate> UpdateEmployeeMisc(EmployeeMasterMiscUpdate employeeMasterMiscUpdate)
        {
            return await ExecuteProcAsync(employeeMasterMiscUpdate);
        }

        public async Task<EmployeeDeactivate> DeactivateEmployee(EmployeeDeactivate employeeDeactivate)
        {
            return await ExecuteProcAsync(employeeDeactivate);
        }
        public async Task<EmployeeActivate> ActivateEmployee(EmployeeActivate employeeActivate)
        {
            return await ExecuteProcAsync(employeeActivate);
        }

        public async Task<EmployeeClone> CloneEmployee(EmployeeClone employeeClone)
        {
            return await ExecuteProcAsync(employeeClone);
        }

    }
}
