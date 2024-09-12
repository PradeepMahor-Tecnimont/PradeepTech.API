using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models;
using TCMPLApp.Domain.Models.SWPVaccine;


namespace TCMPLApp.DataAccess.Repositories.SWPVaccine
{
    public class EmployeeDetailsRepository : Base.ExecRepository, IEmployeeDetailsRepository
    {
        readonly DataContext _dataContext;
        

        public EmployeeDetailsRepository(IConfiguration configuration,DataContext dataContext, ExecDBContext execDBContext) : base(execDBContext)
        {
            _dataContext = dataContext;
        }

        public async Task<EmployeeDetails> GetEmployeeDetailsAsync(string EmpNo)
        {

            string strSql = SWPVaccineQueries.GetEmployeeDetails;


            return await QueryFirstOrDefaultAsync<EmployeeDetails>(strSql, new { emp = EmpNo });
        }

        public  IEnumerable<DdlModel> GetEmployeeSelectAsync()
        {
            var ddlFields = (from emp in _dataContext.SsEmplmasts
                            where emp.Status == true
                            orderby emp.Empno
                            select new DdlModel { Text = emp.Empno + " - " + emp.Personid + " - " + emp.Name,
                                                  Val = emp.Empno
                                                }).AsEnumerable();
            
            return ddlFields;
        }

        public async Task<ChangePassword> ChangeTimesheetPasswordAsync(ChangePassword changePassword)
        {
            return await ExecuteProcAsync(changePassword);
        }
    }
}
