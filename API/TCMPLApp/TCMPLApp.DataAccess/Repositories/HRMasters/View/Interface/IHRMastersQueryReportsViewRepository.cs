using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface IHRMastersQueryReportsViewRepository
    {        
        Task<IEnumerable<EmployeewiseReporting>> EmployeewiseReportingListAsync();

        Task<IEnumerable<EmployeeResigned>> EmployeeResignedListAsync(DateTime? startDate, DateTime? endDate);

        Task<IEnumerable<EmployeeResignedCostcode>> EmployeeResignedCostcodeListAsync(DateTime? startDate, DateTime? endDate);

        Task<IEnumerable<EmployeeResignedMonth>> EmployeeResignedMonthListAsync(DateTime? startDate, DateTime? endDate);

        Task<IEnumerable<EmployeeJoined>> EmployeeJoinedListAsync(DateTime? startDate, DateTime? endDate);

        Task<IEnumerable<EmployeeJoinedCostcode>> EmployeeJoinedCostcodeListAsync(DateTime? startDate, DateTime? endDate);

        Task<IEnumerable<EmployeeJoinedMonth>> EmployeeJoinedMonthListAsync(DateTime? startDate, DateTime? endDate);

        Task<IEnumerable<CostcodewiseEmployee>> CostcodewiseEmployeeCountListAsync();

        Task<IEnumerable<CategorywiseEmployee>> CategorywiseEmployeeCountListAsync();

        Task<IEnumerable<ContractEmployee>> ContractEmployeeListAsync();

        Task<IEnumerable<SubcontractEmployee>> SubcontractEmployeeListAsync();

        Task<IEnumerable<SubcontractEmployee>> SubcontractActiveEmployeeListAsync();

        Task<IEnumerable<OutsourceEmployee>> OutsourceEmployeeListAsync(string yyyymm);

        Task<IEnumerable<SubcontractEmployeePivot>> SubcontractEmployeePivotListAsync(string yyyymm);

        Task<string> ParentwiseSubcontractListAsync(string yyyymm);


    }
}
