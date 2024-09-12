using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS

{
    public interface IInvItemAsgmtTypesDataTableListRepository
    {
        public Task<IEnumerable<InvItemAsgmtTypesDataTableList>> InvItemAsgmtTypesDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        public Task<IEnumerable<InvItemAsgmtTypesDataTableList>> InvItemAsgmtTypesDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}