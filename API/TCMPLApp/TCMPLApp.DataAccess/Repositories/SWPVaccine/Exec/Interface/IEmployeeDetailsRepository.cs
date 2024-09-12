using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;


namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public interface IEmployeeDetailsRepository
    {
        public Task<EmployeeDetails> GetEmployeeDetailsAsync(string EmpNo);

        public IEnumerable<DdlModel> GetEmployeeSelectAsync();

        public Task<ChangePassword> ChangeTimesheetPasswordAsync(ChangePassword changePassword);

    }
}
