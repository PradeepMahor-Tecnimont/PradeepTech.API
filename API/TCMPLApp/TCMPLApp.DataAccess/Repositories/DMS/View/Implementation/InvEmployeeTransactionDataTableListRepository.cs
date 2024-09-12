using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class InvEmployeeTransactionDataTableListRepository : ViewTcmPLRepository<InvEmployeeTransactionDataTableList>, IInvEmployeeTransactionDataTableListRepository
    {
        public InvEmployeeTransactionDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<InvEmployeeTransactionDataTableList>> EmployeeTransactionDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_transactions_qry.fn_employee_transactions_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<InvEmployeeTransactionDataTableList>> EmployeeTransactionDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_inv_transactions_qry.fn_employee_transactions_excel_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}