using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public interface IInvTransactionDataTableListRepository
    {
        public Task<IEnumerable<InvTransactionDataTableList>> TransactionDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<InvTransactionDataTableList>> TransactionReserveItemsDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<InvTransactionDataTableList>> TransactionDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}