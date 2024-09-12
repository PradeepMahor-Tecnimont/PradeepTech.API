
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.LC;


namespace TCMPLApp.DataAccess.Repositories.LC
{
    public interface IVendorDetailsRepository
    {
        public Task<VendorDetails> VendorDetailsAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }


}
