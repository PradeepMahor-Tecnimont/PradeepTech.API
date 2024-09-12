using TCMPLApp.Domain.Context;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.Domain.Models.SWPVaccine;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public interface IEmployeePolicyRepository  
    {
        public Task<ProcedureResult> Create(string userWinUid, EmployeePolicyExecModel employeePolicy);
        public Task<ProcedureResult> SWPPreCheck(string userWinUid);
        public Task<SwpVuEmpResponse> EmpSWPDetails(string userWinUid);
        public Task<SwpEmpTraining> EmpTrainingDetails(string userWinUid);
        public IEnumerable<DdlModel> SelectListISP();


    }
}
