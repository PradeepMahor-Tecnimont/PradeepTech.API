
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.LC;


namespace TCMPLApp.DataAccess.Repositories.LC
{
    public interface ICurrencyDetailsRepository
    {
        public Task<CurrencyDetails> CurrencyDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }


}
