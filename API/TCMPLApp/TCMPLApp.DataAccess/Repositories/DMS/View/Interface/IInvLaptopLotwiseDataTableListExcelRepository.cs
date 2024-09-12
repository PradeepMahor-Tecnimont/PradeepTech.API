using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public interface IInvLaptopLotwiseDataTableListExcelRepository
    {        

        public Task<IEnumerable<InvLaptopLotwiseDataTableListExcel>> LaptopLotwiseAllDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<InvLaptopLotwiseDataTableListExcel>> LaptopLotwiseIssuedDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
        public Task<IEnumerable<InvLaptopLotwiseDataTableListExcel>> LaptopLotwisePendingDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);

        
    }
}