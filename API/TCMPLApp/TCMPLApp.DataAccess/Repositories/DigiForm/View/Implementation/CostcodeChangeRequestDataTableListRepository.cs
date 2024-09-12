using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DigiForm;

namespace TCMPLApp.DataAccess.Repositories.DigiForm
{
    public class CostcodeChangeRequestDataTableListRepository : ViewTcmPLRepository<CostcodeChangeRequestDataTableList>, ICostcodeChangeRequestDataTableListRepository
    {
        public CostcodeChangeRequestDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {

        }
        public async Task<IEnumerable<CostcodeChangeRequestDataTableList>> CostcodeChangeRequestDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_dg_mid_transfer_costcode_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<CostcodeChangeRequestDataTableList>> HodApprovalsRequestsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_dg_hod_transfer_costcode_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<CostcodeChangeRequestDataTableList>> HodHistoryApprovalsRequestsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_dg_hod_transfer_costcode_history_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<CostcodeChangeRequestDataTableList>> HrHistoryApprovalsRequestsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_dg_hr_transfer_costcode_history_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<CostcodeChangeRequestDataTableList>> HrApprovedApprovalsRequestsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_dg_hr_transfer_costcode_approved_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<CostcodeChangeRequestDataTableList>> HRApprovalsRequestsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_dg_hr_transfer_costcode_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<CostcodeChangeRequestDataTableList>> TemporaryEmployeesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_dg_temporary_employees_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<CostcodeChangeRequestDataTableList>> HodTransferEmployeesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_dg_hod_transfer_Employee_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<CostcodeChangeRequestDataTableList>> HrTransferEmployeesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_dg_hr_transfer_Employee_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<CostcodeChangeRequestDataTableList>> HrTransferCostcodeExcelDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_dg_mid_transfer_costcode_qry.fn_dg_hr_transfer_costcode_xl";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
