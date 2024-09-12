using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvEmployeeTransactionDetailDataTableListRepository : ViewTcmPLRepository<InvEmployeeTransactionDetailDataTableList>, IInvEmployeeTransactionDetailDataTableListRepository
    {
        public InvEmployeeTransactionDetailDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<InvEmployeeTransactionDetailDataTableList>> EmployeeTransactionDetailDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_transactions_det_qry.fn_employee_transactions_detail_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<InvEmployeeTransactionDetailDataTableList>> EmployeeTransactionDetailDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_transactions_det_qry.fn_employee_transactions_detail_excel_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}