using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class EmployeeTrainingRepository : ExecRepository, IEmployeeTrainingRepository
    {
        public EmployeeTrainingRepository(IConfiguration configuration, ExecDBContext execDBContext) : base(execDBContext)
        {
        }

        public Task<IEnumerable<EmployeeTraining>> GetEmployeeTrainings()
        {
            string strSql = SWPVaccineQueries.GetEmployeeTrainings;

            return QueryAsync<EmployeeTraining>(strSql, null);

        }
    }
}
