using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.SWPVaccine;

namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public interface IEmployeeTrainingRepository
    {
        public Task<IEnumerable<EmployeeTraining>> GetEmployeeTrainings();

    }
}
