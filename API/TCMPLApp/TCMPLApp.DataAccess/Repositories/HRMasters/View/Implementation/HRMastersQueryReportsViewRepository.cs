using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Attendance;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class HRMastersQueryReportsViewRepository : Base.ExecRepository, IHRMastersQueryReportsViewRepository
    {
        public HRMastersQueryReportsViewRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        public async Task<IEnumerable<EmployeewiseReporting>> EmployeewiseReportingListAsync()
        {
            return await QueryAsync<EmployeewiseReporting>(HRMastersQueries.EmployeewiseReportingList);
        }

        public async Task<IEnumerable<EmployeeResigned>> EmployeeResignedListAsync(DateTime? startDate, DateTime? endDate)
        {
            return await QueryAsync<EmployeeResigned>(HRMastersQueries.EmployeeResignedList, new { pStartDate = startDate, pEndDate = endDate });
        }

        public async Task<IEnumerable<EmployeeResignedCostcode>> EmployeeResignedCostcodeListAsync(DateTime? startDate, DateTime? endDate)
        {
            return await QueryAsync<EmployeeResignedCostcode>(HRMastersQueries.EmployeeResignedCostcodewiseList, new { pStartDate = startDate, pEndDate = endDate });
        }

        public async Task<IEnumerable<EmployeeResignedMonth>> EmployeeResignedMonthListAsync(DateTime? startDate, DateTime? endDate)
        {
            return await QueryAsync<EmployeeResignedMonth>(HRMastersQueries.EmployeeResignedMonthwiseList, new { pStartDate = startDate, pEndDate = endDate });
        }

        public async Task<IEnumerable<EmployeeJoined>> EmployeeJoinedListAsync(DateTime? startDate, DateTime? endDate)
        {
            return await QueryAsync<EmployeeJoined>(HRMastersQueries.EmployeeJoinedList, new { pStartDate = startDate,  pEndDate = endDate });
        }
        public async Task<IEnumerable<EmployeeJoinedCostcode>> EmployeeJoinedCostcodeListAsync(DateTime? startDate, DateTime? endDate)
        {
            return await QueryAsync<EmployeeJoinedCostcode>(HRMastersQueries.EmployeeJoinedCostcodewiseList, new { pStartDate = startDate, pEndDate = endDate });
        }

        public async Task<IEnumerable<EmployeeJoinedMonth>> EmployeeJoinedMonthListAsync(DateTime? startDate, DateTime? endDate)
        {
            return await QueryAsync<EmployeeJoinedMonth>(HRMastersQueries.EmployeeJoinedMonthwiseList, new { pStartDate = startDate, pEndDate = endDate });
        }

        public async Task<IEnumerable<CostcodewiseEmployee>> CostcodewiseEmployeeCountListAsync()
        {
            return await QueryAsync<CostcodewiseEmployee>(HRMastersQueries.CostcodewiseEmployeeCountList);
        }

        public async Task<IEnumerable<CategorywiseEmployee>> CategorywiseEmployeeCountListAsync()
        {
            return await QueryAsync<CategorywiseEmployee>(HRMastersQueries.CategorywiseEmployeeCountList);
        }

        public async Task<IEnumerable<ContractEmployee>> ContractEmployeeListAsync()
        {
            return await QueryAsync<ContractEmployee>(HRMastersQueries.ContractEmployeeList);
        }

        public async Task<IEnumerable<SubcontractEmployee>> SubcontractEmployeeListAsync()
        {
            return await QueryAsync<SubcontractEmployee>(HRMastersQueries.SubcontractEmployeeList);
        }

        public async Task<IEnumerable<SubcontractEmployee>> SubcontractActiveEmployeeListAsync()
        {
            return await QueryAsync<SubcontractEmployee>(HRMastersQueries.SubcontractActiveEmployeeList);
        }

        public async Task<IEnumerable<OutsourceEmployee>> OutsourceEmployeeListAsync(string yyyymm)
        {
            return await QueryAsync<OutsourceEmployee>(HRMastersQueries.OutsourceEmployeeList, new { pYyyymm = yyyymm });
        }
        public async Task<IEnumerable<SubcontractEmployeePivot>> SubcontractEmployeePivotListAsync(string yyyymm)
        {
            return await QueryAsync<SubcontractEmployeePivot>(HRMastersQueries.SubcontractEmployeePivotList, new { pYyyymm = yyyymm });
        }

        public async Task<string> ParentwiseSubcontractListAsync(string yyyymm)
        {
            return await QueryFirstOrDefaultAsync<string> (HRMastersQueries.ParentwiseSubcontractEmployee, new { pYyyymm = yyyymm });
        }

    }
}
